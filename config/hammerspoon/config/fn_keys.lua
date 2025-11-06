-- Hyper key setup (⌘ + ⌥ + ⌃ + ⇧)
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Volume Down
hs.hotkey.bind(hyper, "f11", function()
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_DOWN", false):post()
end)

-- Volume Up
hs.hotkey.bind(hyper, "f12", function()  -- "=" is the unshifted "+" key
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", true):post()
    hs.eventtap.event.newSystemKeyEvent("SOUND_UP", false):post()
end)

-- Mute/Unmute (No Sound)
hs.hotkey.bind(hyper, "f10", function()
    hs.eventtap.event.newSystemKeyEvent("MUTE", true):post()
    hs.eventtap.event.newSystemKeyEvent("MUTE", false):post()
end)