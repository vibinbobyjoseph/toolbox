-- Function to toggle microphone mute/unmute
function toggleMic()
    local script = [[
        set inputVolume to input volume of (get volume settings)
        if inputVolume > 0 then
            set volume input volume 0
            return "Microphone Muted"
        else
            set volume input volume 100
            return "Microphone Unmuted"
        end if
    ]]
    
    local success, output = hs.osascript.applescript(script)

    if success then
        hs.alert.show(output)  -- Show feedback alert
    else
        hs.alert.show("Error toggling mic")
    end
end

-- Bind F14 to toggle microphone
hs.hotkey.bind({}, "F14", toggleMic)