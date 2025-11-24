-- ==============================================
-- Launch Apps with Single Keys (no modifiers)
-- For apps you want to access quickly without hyper key combinations

local launcher = require('config.launchers.init')
local utils = require('config.utils')

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
        utils.feedback.showStatus("Failed: " .. (appConfig.app or appConfig.name or "unknown app"))
    end
end

-- Validate configuration at startup
local function validateConfig()
    local errors = {}
    for key, appConfig in pairs(singleKeyApps) do
        if not appConfig then
            table.insert(errors, "Key '" .. tostring(key) .. "' has nil configuration")
        else
            -- Validate app configuration
            if not (appConfig.app or appConfig.name or appConfig.bundleID or appConfig.path) then
                table.insert(errors, "Key '" .. tostring(key) .. "' missing app identifier (app/name/bundleID/path)")
            end
        end
    end

    if #errors > 0 then
        local errorMsg = "Single-key launcher config errors:\n" .. table.concat(errors, "\n")
        hs.notify.new({title="Config Error", informativeText=errorMsg}):send()
        return false
    end
    return true
end

-- Validate before binding hotkeys
if validateConfig() then
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
end

-- Optional: Show notification when script loads (commented to reduce notification spam)
-- hs.notify.new({
--     title="Hammerspoon",
--     informativeText="Single-key app launcher is active!"
-- }):send()