-- ==============================================
-- Resize a window
-- Define the hyper-key
local hyper = {"ctrl", "alt"}
local utils = require("config.utils")
local windowConfig = utils.settings.window

-- Quarter-screen positioning using arrow key combinations
-- Hold Ctrl+Alt, then press Left+Up for top-left, etc.

-- Track last arrow pressed for compound operations
local lastArrow = nil
local arrowTimer = nil

-- Helper: Validate window screen
local function validateScreen(win)
    if not win then return nil, "No window provided" end

    local screen = win:screen()
    if not screen then
        return nil, "No screen available for window"
    end

    local frame = screen:frame()
    if not frame or frame.w <= 0 or frame.h <= 0 then
        return nil, "Invalid screen dimensions"
    end

    return screen, nil
end

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
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    -- Validate screen
    local screen, screenErr = validateScreen(win)
    if not screen then
        utils.feedback.showStatus(screenErr or "Screen validation failed")
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
    local frame = getQuarterScreenFrame(screen, vertical, horizontal)
    win:setFrame(frame)

    utils.feedback.highlightWindow(win, 0.5)
    utils.feedback.playSound("move")
    resetArrowState()
end

-- Modified left arrow with quarter-screen support
hs.hotkey.bind(hyper, "left", function()
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    if lastArrow and (lastArrow == "up" or lastArrow == "down") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "left")
    else
        -- Validate screen
        local screen, screenErr = validateScreen(win)
        if not screen then
            utils.feedback.showStatus(screenErr or "Screen validation failed")
            return
        end

        -- Normal left half operation
        local screenFrame = screen:frame()
        win:setFrame({
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "left"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(windowConfig.quarterScreen.comboTimeout, resetArrowState)
    end
end)

-- Modified right arrow with quarter-screen support
hs.hotkey.bind(hyper, "right", function()
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    if lastArrow and (lastArrow == "up" or lastArrow == "down") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "right")
    else
        -- Validate screen
        local screen, screenErr = validateScreen(win)
        if not screen then
            utils.feedback.showStatus(screenErr or "Screen validation failed")
            return
        end

        -- Normal right half operation
        local screenFrame = screen:frame()
        win:setFrame({
            x = screenFrame.x + screenFrame.w / 2,
            y = screenFrame.y,
            w = screenFrame.w / 2,
            h = screenFrame.h
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "right"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(windowConfig.quarterScreen.comboTimeout, resetArrowState)
    end
end)

-- Modified up arrow with quarter-screen support
hs.hotkey.bind(hyper, "up", function()
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    if lastArrow and (lastArrow == "left" or lastArrow == "right") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "up")
    else
        -- Validate screen
        local screen, screenErr = validateScreen(win)
        if not screen then
            utils.feedback.showStatus(screenErr or "Screen validation failed")
            return
        end

        -- Normal top half operation
        local screenFrame = screen:frame()
        win:setFrame({
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w,
            h = screenFrame.h / 2
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "up"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(windowConfig.quarterScreen.comboTimeout, resetArrowState)
    end
end)

-- Modified down arrow with quarter-screen support
hs.hotkey.bind(hyper, "down", function()
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    if lastArrow and (lastArrow == "left" or lastArrow == "right") then
        -- Quarter screen operation
        handleQuarterScreen(lastArrow, "down")
    else
        -- Validate screen
        local screen, screenErr = validateScreen(win)
        if not screen then
            utils.feedback.showStatus(screenErr or "Screen validation failed")
            return
        end

        -- Normal bottom half operation
        local screenFrame = screen:frame()
        win:setFrame({
            x = screenFrame.x,
            y = screenFrame.y + screenFrame.h / 2,
            w = screenFrame.w,
            h = screenFrame.h / 2
        })
        utils.feedback.highlightWindow(win, 0.5)
        utils.feedback.playSound("move")

        -- Set state for potential quarter screen
        lastArrow = "down"
        if arrowTimer then
            arrowTimer:stop()
            arrowTimer = nil
        end
        arrowTimer = hs.timer.doAfter(windowConfig.quarterScreen.comboTimeout, resetArrowState)
    end
end)

-- Toggle between center and maximize
hs.hotkey.bind(hyper, "return", function()
    local win, err = utils.getActiveWindow()
    if not win then
        utils.feedback.showStatus(err or "No window available")
        return
    end

    -- Validate screen
    local screen, screenErr = validateScreen(win)
    if not screen then
        utils.feedback.showStatus(screenErr or "Screen validation failed")
        return
    end

    local screenFrame = screen:frame()
    local currentFrame = win:frame()

    -- Check if window is currently maximized (using centralized tolerance)
    local tolerance = windowConfig.positioning.maximizeTolerance
    local isMaximized = math.abs(currentFrame.x - screenFrame.x) < tolerance and
                       math.abs(currentFrame.y - screenFrame.y) < tolerance and
                       math.abs(currentFrame.w - screenFrame.w) < tolerance and
                       math.abs(currentFrame.h - screenFrame.h) < tolerance

    if isMaximized then
        -- Currently maximized, center it (using centralized config)
        local w = screenFrame.w * windowConfig.positioning.centerWidth
        local h = screenFrame.h * windowConfig.positioning.centerHeight
        win:setFrame({
            x = screenFrame.x + (screenFrame.w - w) / 2,
            y = screenFrame.y + (screenFrame.h - h) / 2,
            w = w,
            h = h
        })
    else
        -- Not maximized, maximize it
        win:setFrame(screenFrame)
    end
    utils.feedback.highlightWindow(win, 0.5)
    utils.feedback.playSound("move")
end)

-- ==============================================
-- Module export with cleanup function
local module = {}

-- Cleanup function for module reload
function module.cleanup()
    if arrowTimer then
        arrowTimer:stop()
        arrowTimer = nil
    end
    lastArrow = nil
end

return module