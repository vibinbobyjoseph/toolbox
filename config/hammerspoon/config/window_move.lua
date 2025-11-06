-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyperWM-key
local hyperWM = {"ctrl", "alt", "shift"}

-- Helper function to get active window with fallback methods
local function getActiveWindow()
    return hs.window.focusedWindow()
        or hs.window.frontmostWindow()
        or hs.window.orderedWindows()[1]
end

-- Move the focused window to the next screen (strict right)
hs.hotkey.bind(hyperWM, "right", function()
    local win = getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local nextScreen = currentScreen:toEast() -- Strictly get the screen to the right
        if nextScreen then
            win:moveToScreen(nextScreen)
        else
            hs.alert.show("No screen to the right")
        end
    else
        hs.alert.show("No window available")
    end
end)

-- Move the focused window to the previous screen (strict left)
hs.hotkey.bind(hyperWM, "left", function()
    local win = getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local prevScreen = currentScreen:toWest() -- Strictly get the screen to the left
        if prevScreen then
            win:moveToScreen(prevScreen)
        else
            hs.alert.show("No screen to the left")
        end
    else
        hs.alert.show("No window available")
    end
end)
-- ==============================================