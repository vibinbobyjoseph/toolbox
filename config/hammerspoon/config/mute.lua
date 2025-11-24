-- Function to toggle microphone mute/unmute
local function toggleMic()
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

    local success, output, rawTable = hs.osascript.applescript(script)

    if success then
        hs.alert.show(output)  -- Show feedback alert
    else
        -- Provide more detailed error message
        local errorMsg = "Error toggling mic"
        if rawTable and rawTable.NSLocalizedFailureReason then
            errorMsg = errorMsg .. ": " .. rawTable.NSLocalizedFailureReason
        end
        hs.alert.show(errorMsg)
        -- Log the error for debugging
        hs.logger.new('mute', 'debug'):e("AppleScript error: " .. (output or "unknown error"))
    end
end

-- Bind F14 to toggle microphone
hs.hotkey.bind({}, "F14", toggleMic)