-- Create module-level logger
local logger = hs.logger.new('mute', 'info')
local feedback = require('config.visual_feedback')

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

    if success and output then
        feedback.showStatus(output)  -- Show feedback overlay
    else
        -- Provide more detailed error message
        local errorMsg = "Error toggling mic"
        if rawTable and rawTable.NSLocalizedFailureReason then
            errorMsg = errorMsg .. ": " .. tostring(rawTable.NSLocalizedFailureReason)
        elseif output then
            errorMsg = errorMsg .. ": " .. tostring(output)
        end
        feedback.showStatus(errorMsg)
        -- Log the error for debugging
        logger:e("AppleScript error: " .. (output and tostring(output) or "unknown error"))
    end
end

-- Bind F14 to toggle microphone
hs.hotkey.bind({}, "F14", toggleMic)

-- Module export
local muteModule = {
    cleanup = function()
        -- No cleanup needed
    end
}

return muteModule