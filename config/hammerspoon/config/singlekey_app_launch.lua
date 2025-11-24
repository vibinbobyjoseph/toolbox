-- ==============================================
-- Launch Apps with Single Keys (no modifiers)
-- For apps you want to access quickly without hyper key combinations

local launcher = require('config.launchers.init')

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

-- Function to launch or focus an app with toggle behavior
local function launchOrFocusApp(appConfig)
    if not appConfig then return end

    -- Use shared launcher module
    local success, message = launcher.launchOrFocus(appConfig)

    if not success then
        hs.alert.show("Failed: " .. (appConfig.app or appConfig.name or "unknown app"))
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