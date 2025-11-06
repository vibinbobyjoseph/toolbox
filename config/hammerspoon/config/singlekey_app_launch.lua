-- ==============================================
-- Launch Apps with Single Keys (no modifiers)
-- For apps you want to access quickly without hyper key combinations

-- Define single-key app mappings
local singleKeyApps = {
    -- § key (keycode 10) for iTerm
    [10] = {
        app = "iTerm",
        alternateNames = {"iTerm2"}, -- Alternative app names to check
        description = "iTerm"
    },
    
    -- F13 key for Notion
    ["f13"] = {
        app = "Notion",
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
    local app = hs.application.find(appConfig.app)
    
    -- If app not found, try alternate names
    if not app and appConfig.alternateNames then
        for _, altName in ipairs(appConfig.alternateNames) do
            app = hs.application.find(altName)
            if app then break end
        end
    end
    
    if app then
        -- If app is already running, handle focus/hide toggle
        if app:isFrontmost() then
            -- If app is already focused, hide it (toggle behavior)
            app:hide()
            hs.alert.show(appConfig.description .. " hidden")
        else
            -- Bring app to front
            app:activate()
            hs.alert.show(appConfig.description .. " activated")
        end
    else
        -- Launch app if it's not running
        hs.application.launchOrFocus(appConfig.app)
        hs.alert.show(appConfig.description .. " launched")
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