-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyper-key
local hyper = {"ctrl", "alt", "shift"}
local utils = require("config.utils")
local feedback = require("config.visual_feedback")
local logger = hs.logger.new('window_move', 'info')

-- Move the focused window to the next screen (strict right, no wrapping)
hs.hotkey.bind(hyper, "right", function()
    local win, err = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local nextScreen = currentScreen:toEast() -- Strictly get the screen to the right

        if nextScreen then
            win:moveToScreen(nextScreen)
            logger:d("Moved window to screen on the right")
            feedback.highlightWindow(win, 0.5)
        else
            logger:d("No screen to the right")
            feedback.showStatus("No screen to the right")
            feedback.playSound("error")
        end
    else
        logger:w("No active window found for move right")
        feedback.showStatus(err or "No window available")
    end
end)

-- Move the focused window to the previous screen (strict left, no wrapping)
hs.hotkey.bind(hyper, "left", function()
    local win, err = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local prevScreen = currentScreen:toWest() -- Strictly get the screen to the left

        if prevScreen then
            win:moveToScreen(prevScreen)
            logger:d("Moved window to screen on the left")
            feedback.highlightWindow(win, 0.5)
        else
            logger:d("No screen to the left")
            feedback.showStatus("No screen to the left")
            feedback.playSound("error")
        end
    else
        logger:w("No active window found for move left")
        feedback.showStatus(err or "No window available")
    end
end)
-- ==============================================

-- Module export
local windowMove = {
    cleanup = function()
        -- No cleanup needed currently
    end
}

return windowMove