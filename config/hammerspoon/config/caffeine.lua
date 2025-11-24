-- Caffeine: Prevent system sleep
local caffeine = {
    menubar = nil,
    active = false
}

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
        hs.alert.show("Caffeine: System will stay awake")
    else
        hs.caffeinate.set("displayIdle", false, true)
        hs.caffeinate.set("systemIdle", false, true)
        hs.alert.show("Caffeine: Normal sleep behavior")
    end

    updateMenubar()
end

caffeine.menubar = hs.menubar.new()
caffeine.menubar:setClickCallback(toggleCaffeine)
caffeine.menubar:setMenu({
    {title = "Toggle Caffeine", fn = toggleCaffeine},
    {title = "-"},
    {title = "Prevents system from sleeping", disabled = true}
})
updateMenubar()

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "c", toggleCaffeine)

return caffeine
