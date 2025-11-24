-- ==============================================
-- Resize a window
-- Define the hyper-key
local hyperWR = {"ctrl", "alt"}
local utils = require("config.utils")

-- Quarter-screen positioning using arrow key combinations
-- Hold Ctrl+Alt, then press Left+Up for top-left, etc.

-- Track last arrow pressed for compound operations
local lastArrow = nil
local arrowTimer = nil

local function resetArrowState()
    lastArrow = nil
    if arrowTimer then
        arrowTimer:stop()
        arrowTimer = nil
    end
end

-- Helper: Check if two arrows form a quarter-screen combination
local function isQuarterScreenCombo(first, second)
    local validCombos = {
        up = {left = true, right = true},
        down = {left = true, right = true},
        left = {up = true, down = true},
        right = {up = true, down = true}
    }

    return validCombos[first] and validCombos[first][second]
end

-- Helper: Calculate quarter screen frame
local function getQuarterScreenFrame(screen, vertical, horizontal)
    local max = screen:frame()
    local width = max.w / 2
    local height = max.h / 2

    local frame = {
        w = width,
        h = height,
        x = max.x,
        y = max.y
    }

    -- Adjust X position for left/right
    if horizontal == "right" then
        frame.x = max.x + width
    end

    -- Adjust Y position for up/down
    if vertical == "down" then
        frame.y = max.y + height
    end

    return frame
end

local function handleQuarterScreen(firstArrow, secondArrow)
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    -- Check if this is a valid quarter-screen combo
    if not isQuarterScreenCombo(firstArrow, secondArrow) then
        return
    end

    -- Determine vertical and horizontal positions
    local vertical, horizontal
    if firstArrow == "up" or firstArrow == "down" then
        vertical = firstArrow
        horizontal = secondArrow
    else
        vertical = secondArrow
        horizontal = firstArrow
    end

    -- Calculate and set the frame
    local frame = getQuarterScreenFrame(win:screen(), vertical, horizontal)
    win:setFrame(frame)

    utils.feedback.highlightWindow(win, 0.5)
    utils.feedback.playSound("move")
    resetArrowState()
end

-- Modified left arrow with quarter-screen support
hs.hotkey.bind(hyperWR, "left", function()
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    if lastArrow and (lastArrow == "up" or lastArrow == "down") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "left")
    else
        -- Normal left half operation
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "left"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(0.5, resetArrowState)
    end
end)

-- Modified right arrow with quarter-screen support
hs.hotkey.bind(hyperWR, "right", function()
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    if lastArrow and (lastArrow == "up" or lastArrow == "down") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "right")
    else
        -- Normal right half operation
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x + screen.w / 2,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "right"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(0.5, resetArrowState)
    end
end)

-- Modified up arrow with quarter-screen support
hs.hotkey.bind(hyperWR, "up", function()
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    if lastArrow and (lastArrow == "left" or lastArrow == "right") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "up")
    else
        -- Normal top half operation
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y,
            w = screen.w,
            h = screen.h / 2
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "up"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(0.5, resetArrowState)
    end
end)

-- Modified down arrow with quarter-screen support
hs.hotkey.bind(hyperWR, "down", function()
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    if lastArrow and (lastArrow == "left" or lastArrow == "right") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "down")
    else
        -- Normal bottom half operation
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y + screen.h / 2,
            w = screen.w,
            h = screen.h / 2
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "down"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(0.5, resetArrowState)
    end
end)

-- Toggle between center and maximize
hs.hotkey.bind(hyperWR, "return", function()
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    local screen = win:screen():frame()
    local currentFrame = win:frame()

    -- Check if window is currently maximized (within 10 pixels tolerance)
    local isMaximized = math.abs(currentFrame.x - screen.x) < 10 and
                       math.abs(currentFrame.y - screen.y) < 10 and
                       math.abs(currentFrame.w - screen.w) < 10 and
                       math.abs(currentFrame.h - screen.h) < 10

    if isMaximized then
        -- Currently maximized, center it at 60% width, 70% height
        local w = screen.w * 0.6
        local h = screen.h * 0.7
        win:setFrame({
            x = screen.x + (screen.w - w) / 2,
            y = screen.y + (screen.h - h) / 2,
            w = w,
            h = h
        })
    else
        -- Not maximized, maximize it
        win:setFrame(screen)
    end
    utils.feedback.highlightWindow(win, 0.5)
    utils.feedback.playSound("move")
end)

-- ==============================================