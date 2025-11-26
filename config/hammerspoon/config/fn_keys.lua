-- Hyper key setup (⌘ + ⌥ + ⌃ + ⇧)
local hyper = {"cmd", "alt", "ctrl", "shift"}
local logger = hs.logger.new('fn_keys', 'info')

-- Volume Down
hs.hotkey.bind(hyper, "f11", function()
    logger:d("Volume down triggered")
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", false):post()
end)

-- Volume Up
hs.hotkey.bind(hyper, "f12", function()  -- "=" is the unshifted "+" key
    logger:d("Volume up triggered")
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", false):post()
end)

-- Mute/Unmute (No Sound)
hs.hotkey.bind(hyper, "f10", function()
    logger:d("Mute/unmute triggered")
    hs.eventtap.event.newSystemKeyEvent("MUTE", true):post()
    hs.eventtap.event.newSystemKeyEvent("MUTE", false):post()
end)

-- Module export
local fnKeys = {
    cleanup = function()
        -- No cleanup needed (hotkeys automatically cleaned on reload)
    end
}

return fnKeys