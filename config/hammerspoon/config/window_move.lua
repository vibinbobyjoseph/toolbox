-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyper-key
local hyper = {"ctrl", "alt", "shift"}
local utils = require("config.utils")
local feedback = require("config.visual_feedback")

-- Move the focused window to the next screen (strict right, no wrapping)
hs.hotkey.bind(hyper, "right", function()
    local win, err = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local nextScreen = currentScreen:toEast() -- Strictly get the screen to the right

        if nextScreen then
            win:moveToScreen(nextScreen)
            feedback.highlightWindow(win, 0.5)
        else
            feedback.showStatus("No screen to the right")
            feedback.playSound("error")
        end
    else
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
            feedback.highlightWindow(win, 0.5)
        else
            feedback.showStatus("No screen to the left")
            feedback.playSound("error")
        end
    else
        feedback.showStatus(err or "No window available")
    end
end)
-- ==============================================

-- Module export
local module = {}
return module