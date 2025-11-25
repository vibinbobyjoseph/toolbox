-- ==============================================
-- Move a window from one screen to another (strict direction)
-- Define the hyper-key
local hyper = {"ctrl", "alt", "shift"}
local utils = require("config.utils")
local feedback = require("config.visual_feedback")

-- Move the focused window to the next screen (strict right with wrapping)
hs.hotkey.bind(hyper, "right", function()
    local win, err = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local nextScreen = currentScreen:toEast() -- Strictly get the screen to the right

        -- Edge case: No screen to the right, try wrapping around
        if not nextScreen then
            local allScreens = hs.screen.allScreens()
            if #allScreens > 1 then
                -- Find current screen index and wrap to first screen
                for i, s in ipairs(allScreens) do
                    if s:id() == currentScreen:id() then
                        nextScreen = allScreens[1] -- Wrap to first screen
                        break
                    end
                end
            end
        end

        if nextScreen then
            win:moveToScreen(nextScreen)
            feedback.highlightWindow(win, 0.5)
            feedback.playSound("move")
        else
            feedback.showStatus("No additional screens available")
        end
    else
        feedback.showStatus(err or "No window available")
    end
end)

-- Move the focused window to the previous screen (strict left with wrapping)
hs.hotkey.bind(hyper, "left", function()
    local win, err = utils.getActiveWindow()
    if win then
        local currentScreen = win:screen()
        local prevScreen = currentScreen:toWest() -- Strictly get the screen to the left

        -- Edge case: No screen to the left, try wrapping around
        if not prevScreen then
            local allScreens = hs.screen.allScreens()
            if #allScreens > 1 then
                -- Find current screen index and wrap to last screen
                for i, s in ipairs(allScreens) do
                    if s:id() == currentScreen:id() then
                        prevScreen = allScreens[#allScreens] -- Wrap to last screen
                        break
                    end
                end
            end
        end

        if prevScreen then
            win:moveToScreen(prevScreen)
            feedback.highlightWindow(win, 0.5)
            feedback.playSound("move")
        else
            feedback.showStatus("No additional screens available")
        end
    else
        feedback.showStatus(err or "No window available")
    end
end)
-- ==============================================

-- Module export
local module = {}
return module