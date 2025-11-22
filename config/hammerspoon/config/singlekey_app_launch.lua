-- ==============================================
-- Launch Apps with Single Keys (no modifiers)
-- For apps you want to access quickly without hyper key combinations

-- Define single-key app mappings
local singleKeyApps = {
    -- § key (keycode 10) for WezTerm
    [10] = {
        app = "WezTerm",
        path = "/Applications/WezTerm.app",
        bundleID = "com.github.wez.wezterm",
        description = "WezTerm"
    },

    -- F13 key for Notion
    ["f13"] = {
        app = "Notion",
        path = "/Applications/Notion.app",
        description = "Notion"
    },
    
    -- Add more single-key mappings as needed
    -- ["f14"] = {
    --     app = "Slack",
    --     description = "Slack"
    -- },
    -- ["f15"] = {
    --     app = "Spotify",
    --     description = "Spotify"
    -- }
}

-- Function to find app by bundle ID or name
local function findApp(appConfig)
    local app = nil

    -- Try bundle ID first (most reliable)
    if appConfig.bundleID then
        app = hs.application.get(appConfig.bundleID)
    end

    -- Fall back to app name
    if not app then
        app = hs.application.find(appConfig.app)
    end

    -- Try alternate names
    if not app and appConfig.alternateNames then
        for _, altName in ipairs(appConfig.alternateNames) do
            app = hs.application.find(altName)
            if app then break end
        end
    end

    return app
end

-- Function to launch or focus an app with toggle behavior
local function launchOrFocusApp(appConfig)
    -- Quick check using bundle ID (fast, no Spotlight search)
    local app = nil
    if appConfig.bundleID then
        app = hs.application.get(appConfig.bundleID)
    end

    if app then
        -- App is running - handle toggle behavior
        if app:isFrontmost() then
            -- If app is focused, hide it
            app:hide()
        else
            -- If app is hidden/background, bring it to front
            app:activate()
        end
    else
        -- App not running - launch using path (same as hyperkey method)
        if appConfig.path then
            hs.execute('open "' .. appConfig.path .. '"')
        elseif appConfig.bundleID then
            hs.execute('open -b "' .. appConfig.bundleID .. '"')
        else
            hs.execute('open -a "' .. appConfig.app .. '"')
        end
    end
end

-- Bind all single-key apps
for key, appConfig in pairs(singleKeyApps) do
    if type(key) == "number" then
        -- Handle keycode (like § key)
        hs.hotkey.bind({}, key, function()
            launchOrFocusApp(appConfig)
        end)
    else
        -- Handle key name (like f13)
        hs.hotkey.bind({}, key, function()
            launchOrFocusApp(appConfig)
        end)
    end
end

-- Optional: Show notification when script loads
hs.notify.new({
    title="Hammerspoon", 
    informativeText="Single-key app launcher is active!"
}):send()