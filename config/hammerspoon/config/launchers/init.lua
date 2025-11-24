-- Shared App Launcher Module
-- Provides common functionality for launching and managing applications

local launcher = {}

-- Create module-level logger (fixes Issue #8)
local logger = hs.logger.new('launcher', 'info')

-- Find an application by name, bundle ID, or path
-- Returns: application object or nil
function launcher.findApp(appData)
    if not appData then return nil end

    local app = nil

    -- Try by bundle ID first (most reliable)
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

    -- Try by path (least common)
    if appData.path then
        local info = hs.application.infoForBundlePath(appData.path)
        if info and info.CFBundleIdentifier then
            app = hs.application.get(info.CFBundleIdentifier)
        end
    end

    return app
end

-- Launch an application using the most reliable method
-- Returns: success (boolean), message (string)
function launcher.launchApp(appData)
    if not appData then
        return false, "No app data provided"
    end

    -- Get display name for logging
    local displayName = appData.app or appData.name or "unknown"

    -- Use the fastest, most reliable method: launchOrFocus with app name
    -- This is what the original Phase 1 code effectively did
    local appName = appData.app or appData.name or appData.bundleID
    if appName then
        local success = hs.application.launchOrFocus(appName)
        if success then
            return true, "Launched successfully"
        end
    end

    -- Fallback failed
    logger:e("Failed to launch app: " .. tostring(displayName))
    return false, "Failed to launch"
end

-- Focus an existing application or launch it if not running
-- Returns: success (boolean), message (string)
function launcher.launchOrFocus(appData)
    if not appData then
        return false, "No app data provided"
    end

    -- Check if app is already running
    local app = launcher.findApp(appData)

    if app then
        -- App is running, bring to front
        if app:isFrontmost() then
            -- Already focused, hide it (toggle behavior)
            app:hide()
            return true, "Hidden"
        else
            -- Bring to front
            app:activate()
            return true, "Activated"
        end
    else
        -- App not running, launch it
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

    -- Find current window index
    for i, win in ipairs(windows) do
        if win:id() == focusedWindow:id() then
            currentIndex = i
            break
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

return launcher
