-- Shared App Launcher Module
-- Provides common functionality for launching and managing applications

local launcher = {}

-- Create module-level logger (fixes Issue #8)
local logger = hs.logger.new('launcher', 'info')

-- Track apps currently being launched to prevent duplicates
local launchingApps = {}

-- Track recently launched apps to prevent duplicate launches (debouncing)
local recentlyLaunched = {}

-- Cleanup old launch tracking entries (older than 2 seconds)
local function cleanupLaunchTracking()
    local now = hs.timer.secondsSinceEpoch()
    for appName, timestamp in pairs(recentlyLaunched) do
        if now - timestamp > 2.0 then
            recentlyLaunched[appName] = nil
        end
    end
end

-- Find an application by name, bundle ID, or path
-- Returns: application object or nil
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

--- Launch an application
--- @param appData table Configuration with bundleID, path, or name
--- @return application|nil The launched app, or nil on failure
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

    launchingApps[identifier] = true
    local app = hs.application.open(identifier)

    hs.timer.doAfter(2.0, function()
        launchingApps[identifier] = nil
    end)

    if app then
        return app, nil  -- ✓ Return app object
    else
        launchingApps[identifier] = nil
        logger:e("Failed to launch: " .. identifier)
        return nil, "Failed to launch"  -- ✓ Return error
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
                -- Fullscreen apps need delayed focus after space transition
                logger:i("App has fullscreen windows, using delayed focus")
                hs.timer.doAfter(0.2, function()
                    local mainWin = app:mainWindow()
                    if mainWin then
                        mainWin:focus()
                    end
                end)
            else
                -- Normal activation with brief delay for window to appear
                hs.timer.doAfter(0.05, function()
                    local mainWin = app:mainWindow()
                    if mainWin then
                        logger:i("Focusing main window")
                        mainWin:focus()
                    else
                        logger:w("No main window found for " .. appIdentifier .. ", relaunching via path")

                        -- Some apps (like WhatsApp) run hidden without windows
                        -- The most reliable fix: just relaunch the app via its path
                        if appData.path then
                            local escapedPath = appData.path:gsub("'", "'\\''")
                            local command = "/usr/bin/open '" .. escapedPath .. "'"
                            hs.execute(command, true)
                            logger:i("Relaunched " .. appIdentifier .. " to open window")
                        end
                    end
                end)
            end

            return app, nil
        end
    else
        -- App not running - check if we recently tried to launch it (debouncing)
        cleanupLaunchTracking()
        local now = hs.timer.secondsSinceEpoch()

        if recentlyLaunched[appIdentifier] then
            local timeSinceLaunch = now - recentlyLaunched[appIdentifier]
            if timeSinceLaunch < 1.0 then
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

-- Get all windows for an application
-- Returns: array of window objects
function launcher.getAppWindows(app)
    if not app then return {} end

    local windows = app:allWindows()
    local visibleWindows = {}

    -- Filter to visible, standard windows
    for _, win in ipairs(windows) do
        if win:isStandard() and win:isVisible() then
            table.insert(visibleWindows, win)
        end
    end

    return visibleWindows
end

-- Cycle through windows of the same application
-- Returns: success (boolean)
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

-- Validate app configuration data
-- Returns: valid (boolean), errors (array of strings)
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
    launchingApps = {}
end

return launcher
