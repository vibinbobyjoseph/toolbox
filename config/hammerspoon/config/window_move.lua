-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyper-key
local hyper = {"ctrl", "alt", "shift"}
local utils = require("config.utils")

-- Move the focused window to the next screen (strict right)
hs.hotkey.bind(hyper, "right", function()
    local win, err = utils.getActiveWindow()
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
        utils.feedback.showStatus(err or "No window available")
    end
end)

-- Move the focused window to the previous screen (strict left)
hs.hotkey.bind(hyper, "left", function()
    local win, err = utils.getActiveWindow()
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
        utils.feedback.showStatus(err or "No window available")
    end
end)
-- ==============================================

-- Module export
local module = {}
return module