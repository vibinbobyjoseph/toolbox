-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyperWM-key
local hyperWM = {"ctrl", "alt", "shift"}
local utils = require("config.utils")

-- Move the focused window to the next screen (strict right)
hs.hotkey.bind(hyperWM, "right", function()
    local win = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local nextScreen = currentScreen:toEast() -- Strictly get the screen to the right
        if nextScreen then
            win:moveToScreen(nextScreen)
            utils.feedback.highlightWindow(win, 0.5)
            utils.feedback.playSound("move")
        else
            utils.feedback.showStatus("No screen to the right")
        end
    else
        utils.feedback.showStatus("No window available")
    end
end)

-- Move the focused window to the previous screen (strict left)
hs.hotkey.bind(hyperWM, "left", function()
    local win = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local prevScreen = currentScreen:toWest() -- Strictly get the screen to the left
        if prevScreen then
            win:moveToScreen(prevScreen)
            utils.feedback.highlightWindow(win, 0.5)
            utils.feedback.playSound("move")
        else
            utils.feedback.showStatus("No screen to the left")
        end
    else
        utils.feedback.showStatus("No window available")
    end
end)
-- ==============================================