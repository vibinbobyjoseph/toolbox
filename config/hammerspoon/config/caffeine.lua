-- Caffeine: Prevent system sleep
local caffeine = {
    menubar = nil,
    active = false
}

local feedback = require("config.visual_feedback")

local function updateMenubar()
    if caffeine.active then
        caffeine.menubar:setTitle("☕")
    else
        caffeine.menubar:setTitle("💤")
    end
end

local function toggleCaffeine()
    caffeine.active = not caffeine.active

    if caffeine.active then
        hs.caffeinate.set("displayIdle", true, true)
        hs.caffeinate.set("systemIdle", true, true)
        feedback.showStatus("Caffeine: System will stay awake")
    else
        hs.caffeinate.set("displayIdle", false, true)
        hs.caffeinate.set("systemIdle", false, true)
        feedback.showStatus("Caffeine: Normal sleep behavior")
    end

    updateMenubar()
end

caffeine.menubar = hs.menubar.new()
caffeine.menubar:setClickCallback(toggleCaffeine)
updateMenubar()

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c", toggleCaffeine)

-- Module export
local caffeineModule = {
    cleanup = function()
        -- Could stop caffeine if active, but not needed on reload
    end
}

return caffeineModule
