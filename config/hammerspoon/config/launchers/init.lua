-- Shared App Launcher Module
-- Provides common functionality for launching and managing applications
--
-- DEPENDENCY LEVEL: 4 (Feature Module)
-- Dependencies: Level 2 (config.settings.init)
-- Required by: Level 5 (hyperkey_app_launch, singlekey_app_launch)

local launcher = {}

-- Create module-level logger (fixes Issue #8)
local logger = hs.logger.new('launcher', 'info')

-- Load timing settings
local settings = require('config.settings.init')
local timing = settings.timing.launcher

-- Track apps currently being launched to prevent duplicates
local launchingApps = {}

-- Track recently launched apps to prevent duplicate launches (debouncing)
local recentlyLaunched = {}

-- Application watcher for tracking app lifecycle
local appWatcher = nil

-- Track active timers for cleanup (Issue #11.2)
local activeTimers = {}

-- Cleanup old launch tracking entries (older than cleanupDelay seconds)
local function cleanupLaunchTracking()
    local now = hs.timer.secondsSinceEpoch()
    for appName, timestamp in pairs(recentlyLaunched) do
        if now - timestamp > timing.cleanupDelay then
            recentlyLaunched[appName] = nil
        end
    end
end

-- Application lifecycle event handler
local function onAppEvent(appName, eventType, app)
    if eventType == hs.application.watcher.launched then
        -- App successfully launched - clear tracking for this app
        local bundleID = app:bundleID()
        local identifier = bundleID or appName

        if launchingApps[identifier] then
            logger:d("App launched successfully, clearing launch state: " .. identifier)
            launchingApps[identifier] = nil
        end

        -- Keep recentlyLaunched for debouncing purposes
        -- (will be cleared by timer or next cleanup cycle)

    elseif eventType == hs.application.watcher.terminated then
        -- App terminated - clear all tracking for this app
        local bundleID = app and app:bundleID()
        local identifier = bundleID or appName

        if launchingApps[identifier] then
            logger:d("App terminated, clearing launch state: " .. identifier)
            launchingApps[identifier] = nil
        end

        if recentlyLaunched[identifier] then
            logger:d("App terminated, clearing recent launch tracking: " .. identifier)
            recentlyLaunched[identifier] = nil
        end

    elseif eventType == hs.application.watcher.activated then
        -- App activated - if we were tracking it as launching, clear the state
        local bundleID = app:bundleID()
        local identifier = bundleID or appName

        if launchingApps[identifier] then
            logger:d("App activated, clearing launch state: " .. identifier)
            launchingApps[identifier] = nil
        end
    end
end

--- Poll for window visibility with timeout (for fullscreen transitions)
--- Returns a table with cancel() method to stop polling early
--- @param app application The application to check
--- @param callback function Function to call when window is visible or timeout
--- @param maxAttempts number Maximum number of polling attempts (default 20)
--- @param interval number Polling interval in seconds (default 0.1)
--- @return table Poller object with cancel() method
local function pollForWindowVisibility(app, callback, maxAttempts, interval)
    maxAttempts = maxAttempts or 20  -- 20 attempts * 0.1s = 2 seconds max
    interval = interval or 0.1

    local attempts = 0
    local cancelled = false
    local currentTimer = nil

    local poller = {
        cancel = function()
            cancelled = true
            if currentTimer then
                currentTimer:stop()
                currentTimer = nil
            end
        end
    }

    local function checkWindow()
        if cancelled then return end

        attempts = attempts + 1

        -- Check if app still exists
        if not app or not app:isRunning() then
            logger:w("App is no longer running during window polling")
            callback(nil)
            return
        end

        -- Try to get main window
        local mainWin = app:mainWindow()

        if mainWin and mainWin:isVisible() then
            -- Window is visible, we can focus it
            logger:d("Window became visible after " .. attempts .. " attempts")
            callback(mainWin)
            return
        end

        -- Check if we've exceeded max attempts
        if attempts >= maxAttempts then
            logger:w("Window visibility polling timed out after " .. (maxAttempts * interval) .. " seconds")
            callback(mainWin)  -- Try to focus anyway, might work
            return
        end

        -- Schedule next check (track timer for cleanup - Issue #11.2)
        currentTimer = hs.timer.doAfter(interval, checkWindow)
        table.insert(activeTimers, currentTimer)
    end

    -- Start polling
    checkWindow()

    return poller
end

--- Find a running application by name, bundle ID, or path
--- Tries bundle ID first (most reliable), then name, then path
--- @param appData table Configuration with name, bundleID, or path fields
--- @return application|nil The running application, or nil if not found
function launcher.findApp(appData)
    if not appData then return nil end

    local app = nil

    -- Try by bundle ID first (most reliable and fastest)
    if appData.bundleID then
        app = hs.application.get(appData.bundleID)
        if app then return app end
    end

    -- Try by name or app field (support both for compatibility)
    local appName = appData.name or appData.app
    if appName then
        app = hs.application.get(appName)
        if app then return app end
    end

    -- Try by path only if we have bundleID to look up
    -- Skip the expensive infoForBundlePath call if app is not running
    -- This prevents 6-8s delays when checking for non-running apps
    if appData.path and appData.bundleID then
        app = hs.application.get(appData.bundleID)
    end

    return app
end

--- Launch an application using the most reliable method available
--- Prevents duplicate launches by tracking launch state
--- @param appData table Configuration with bundleID, path, or name
--- @return application|nil The launched application, or nil on failure
--- @return string|nil Error message if launch failed
function launcher.launchApp(appData)
    if not appData then
        return nil, "No app data provided"
    end

    local identifier = appData.bundleID or appData.path or appData.name
    if not identifier then
        return nil, "App data missing identifier"
    end

    -- Check if already launching (from Phase 7)
    if launchingApps[identifier] then
        logger:d("App already launching: " .. identifier)
        return nil, "Already launching"
    end

    -- Enhanced diagnostics: Check if app exists at path before attempting launch
    if appData.path then
        local fileExists = hs.fs.attributes(appData.path) ~= nil
        if not fileExists then
            local appName = appData.app or appData.name or "Unknown"
            local errorMsg = "App not found: " .. appName .. " at path: " .. appData.path
            logger:e(errorMsg)
            return nil, errorMsg
        end
    end

    launchingApps[identifier] = true

    -- Try to launch - prefer bundle ID first, then path
    local app = nil
    local attemptedMethod = ""

    if appData.bundleID then
        attemptedMethod = "bundle ID: " .. appData.bundleID
        app = hs.application.open(appData.bundleID)
    end

    -- Fallback to path if bundle ID failed
    if not app and appData.path then
        attemptedMethod = attemptedMethod .. (attemptedMethod ~= "" and ", then " or "") .. "path: " .. appData.path
        app = hs.application.open(appData.path)
    end

    -- Fallback to name if both failed
    if not app and (appData.name or appData.app) then
        local appName = appData.name or appData.app
        attemptedMethod = attemptedMethod .. (attemptedMethod ~= "" and ", then " or "") .. "name: " .. appName
        app = hs.application.open(appName)
    end

    -- Track timer for cleanup (Issue #11.2)
    local cleanupTimer = hs.timer.doAfter(timing.cleanupDelay, function()
        launchingApps[identifier] = nil
        -- Remove timer from tracking after it fires
        for i, t in ipairs(activeTimers) do
            if t == cleanupTimer then
                table.remove(activeTimers, i)
                break
            end
        end
    end)
    table.insert(activeTimers, cleanupTimer)

    if app then
        logger:i("Successfully launched via " .. attemptedMethod)
        return app, nil  -- ✓ Return app object
    else
        launchingApps[identifier] = nil
        local errorMsg = "Failed to launch via " .. attemptedMethod
        logger:e(errorMsg)
        return nil, errorMsg  -- ✓ Return detailed error
    end
end

--- Focus an existing application or launch it if not running
--- Provides toggle behavior: hides app if already focused
--- @param appData table Configuration with name, bundleID, or path
--- @return application|nil The application, or nil on failure
--- @return string|nil Error message or status ("Hidden", "Activated", etc.)
function launcher.launchOrFocus(appData)
    if not appData then
        return nil, "No app data provided"
    end

    -- Get identifier for debouncing
    local appIdentifier = appData.bundleID or appData.app or appData.name or "unknown"

    -- FASTEST check: use hs.application.applicationsForBundleID()
    -- This is instant and only checks running apps, no Spotlight queries
    local app = nil
    if appData.bundleID then
        local apps = hs.application.applicationsForBundleID(appData.bundleID)
        if apps and #apps > 0 then
            app = apps[1]
        end
    end

    -- Fallback to find() only if no bundleID (rare case)
    if not app and (appData.app or appData.name) then
        app = hs.application.find(appData.app or appData.name)
    end

    if app then
        logger:i("App is already running: " .. appIdentifier)

        -- App is running, bring to front
        if app:isFrontmost() then
            -- Already focused, hide it (toggle behavior)
            logger:i("App is frontmost, hiding it")
            app:hide()
            return app, nil
        else
            logger:i("App is not frontmost, activating it")

            -- Check if app is hidden
            if app:isHidden() then
                logger:i("App is hidden, unhiding it")
                app:unhide()
            end

            -- Activate the app (brings to front)
            app:activate()

            -- Check if app has fullscreen windows
            local windows = app:allWindows()
            local hasFullscreen = false
            for _, win in ipairs(windows) do
                if win:isFullScreen() then
                    hasFullscreen = true
                    break
                end
            end

            if hasFullscreen then
                -- Fullscreen apps need to wait for space transition
                -- Poll for window visibility with reduced timeout
                logger:i("App has fullscreen windows, polling for visibility")
                pollForWindowVisibility(app, function(mainWin)
                    if mainWin then
                        mainWin:focus()
                        logger:i("Focused fullscreen window")
                    else
                        logger:w("Could not focus fullscreen window after polling")
                    end
                end, 10, 0.1)  -- 1.0 second timeout for fullscreen transitions (reduced from 2.0s)
            else
                -- Normal activation with parallel relaunch strategy
                -- Strategy: Start polling AND schedule a quick relaunch in parallel
                -- If window appears during polling, cancel the relaunch
                -- If no window appears, relaunch fires automatically
                logger:i("Polling for window visibility with parallel relaunch strategy")

                local relaunchTimer = nil
                local poller = nil
                local windowFound = false

                -- Schedule a relaunch timer that fires if window doesn't appear quickly
                if appData.path then
                    relaunchTimer = hs.timer.doAfter(timing.quickRelaunchDelay, function()
                        if not windowFound then
                            logger:i("Quick relaunch triggered for " .. appIdentifier)
                            local escapedPath = appData.path:gsub("'", "'\\''")
                            local command = "/usr/bin/open '" .. escapedPath .. "'"
                            hs.execute(command, true)
                            if poller then poller.cancel() end  -- Stop polling, relaunch is handling it
                        end
                    end)
                    table.insert(activeTimers, relaunchTimer)
                end

                -- Start polling for window (reduced timeout: 4 attempts × 0.025s = 0.1s)
                poller = pollForWindowVisibility(app, function(mainWin)
                    if mainWin then
                        windowFound = true
                        -- Window appeared! Cancel the relaunch timer
                        if relaunchTimer then
                            relaunchTimer:stop()
                            logger:d("Window found, cancelled relaunch timer")
                        end
                        logger:i("Focusing main window")
                        mainWin:focus()
                    else
                        -- Polling timed out, but relaunch timer should handle it
                        -- Only warn if we don't have a path to relaunch
                        if not appData.path then
                            logger:w("No main window found for " .. appIdentifier .. " and no path configured")
                        end
                    end
                end, 4, 0.025)  -- 0.1 second timeout for normal windows (reduced from 0.5s)
            end

            return app, nil
        end
    else
        -- App not running - check if we recently tried to launch it (debouncing)
        cleanupLaunchTracking()
        local now = hs.timer.secondsSinceEpoch()

        if recentlyLaunched[appIdentifier] then
            local timeSinceLaunch = now - recentlyLaunched[appIdentifier]
            if timeSinceLaunch < timing.debounceWindow then
                -- App is currently launching, don't trigger another launch
                logger:i("App already launching: " .. appIdentifier)
                return nil, "Already launching"
            end
        end

        -- Mark app as being launched
        recentlyLaunched[appIdentifier] = now

        -- Launch the app
        return launcher.launchApp(appData)
    end
end

--- Get all visible, standard windows for an application
--- Uses hs.window.filter API for efficient window filtering
--- Filters out minimized and non-standard windows
--- @param app application The application to get windows from
--- @return table Array of window objects
function launcher.getAppWindows(app)
    if not app then return {} end

    -- Use hs.window.filter API for efficient filtering
    -- Creates a filter that only matches:
    -- - Windows belonging to this app
    -- - Standard windows (excludes utility panels, etc.)
    -- - Visible windows (excludes minimized)
    local appFilter = hs.window.filter.new(false)
        :setAppFilter(app:name(), {visible = true, currentSpace = nil})

    -- Get filtered windows
    local windows = appFilter:getWindows()

    -- Further filter to only standard windows
    local standardWindows = {}
    for _, win in ipairs(windows) do
        if win:isStandard() then
            table.insert(standardWindows, win)
        end
    end

    return standardWindows
end

--- Cycle focus through all windows of an application
--- @param appData table Configuration for the app
--- @return boolean True if successful, false if no windows
function launcher.cycleAppWindows(appData)
    local app = launcher.findApp(appData)
    if not app then
        return false
    end

    local windows = launcher.getAppWindows(app)
    if #windows == 0 then
        return false
    end

    if #windows == 1 then
        -- Only one window, just focus it
        windows[1]:focus()
        return true
    end

    -- Multiple windows, cycle to next
    local focusedWindow = hs.window.focusedWindow()
    local currentIndex = nil

    -- Find current window index (only if we have a focused window)
    if focusedWindow then
        for i, win in ipairs(windows) do
            if win:id() == focusedWindow:id() then
                currentIndex = i
                break
            end
        end
    end

    -- Focus next window
    local nextIndex
    if currentIndex then
        nextIndex = (currentIndex % #windows) + 1
    else
        nextIndex = 1
    end

    windows[nextIndex]:focus()
    return true
end

--- Validate app configuration data
--- @param appData table Configuration to validate
--- @return boolean True if valid
--- @return table Array of error messages (empty if valid)
function launcher.validateAppData(appData)
    local errors = {}

    if not appData then
        table.insert(errors, "App data is nil")
        return false, errors
    end

    -- Must have at least one identifier (support both 'app' and 'name' fields)
    if not (appData.app or appData.name or appData.bundleID or appData.path) then
        table.insert(errors, "App data must have app, name, bundleID, or path")
    end

    -- Validate browser preference if specified
    if appData.preferredBrowser then
        local validBrowsers = {chrome = true, firefox = true, safari = true}
        if not validBrowsers[appData.preferredBrowser:lower()] then
            table.insert(errors, "Invalid browser: " .. appData.preferredBrowser)
        end
    end

    return #errors == 0, errors
end

-- Cleanup function for module reload
function launcher.cleanup()
    -- Stop all active timers (Issue #11.2)
    for _, timer in ipairs(activeTimers) do
        if timer then
            timer:stop()
        end
    end
    activeTimers = {}

    -- Clear launch tracking
    launchingApps = {}
    recentlyLaunched = {}

    -- Stop application watcher
    if appWatcher then
        appWatcher:stop()
        appWatcher = nil
        logger:d("Application watcher stopped")
    end
end

-- Initialize application watcher to track app lifecycle
local function initializeAppWatcher()
    if appWatcher then
        logger:w("Application watcher already initialized")
        return
    end

    appWatcher = hs.application.watcher.new(onAppEvent)
    appWatcher:start()
    logger:i("Application watcher started - tracking app launches and terminations")
end

-- Start the application watcher when module loads
initializeAppWatcher()

return launcher
