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

local function handleQuarterScreen(firstArrow, secondArrow)
    local win = utils.getActiveWindow()
    if not win then
        hs.alert.show("No window available")
        return
    end

    local screen = win:screen():frame()
    local x, y, w, h = screen.x, screen.y, screen.w / 2, screen.h / 2

    -- Determine position based on arrow combination
    if firstArrow == "left" and secondArrow == "up" then
        -- Top-left
        win:setFrame({x = x, y = y, w = w, h = h})
    elseif firstArrow == "right" and secondArrow == "up" then
        -- Top-right
        win:setFrame({x = x + w, y = y, w = w, h = h})
    elseif firstArrow == "left" and secondArrow == "down" then
        -- Bottom-left
        win:setFrame({x = x, y = y + h, w = w, h = h})
    elseif firstArrow == "right" and secondArrow == "down" then
        -- Bottom-right
        win:setFrame({x = x + w, y = y + h, w = w, h = h})
    elseif firstArrow == "up" and secondArrow == "left" then
        -- Top-left (reverse order)
        win:setFrame({x = x, y = y, w = w, h = h})
    elseif firstArrow == "up" and secondArrow == "right" then
        -- Top-right (reverse order)
        win:setFrame({x = x + w, y = y, w = w, h = h})
    elseif firstArrow == "down" and secondArrow == "left" then
        -- Bottom-left (reverse order)
        win:setFrame({x = x, y = y + h, w = w, h = h})
    elseif firstArrow == "down" and secondArrow == "right" then
        -- Bottom-right (reverse order)
        win:setFrame({x = x + w, y = y + h, w = w, h = h})
    end

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

        -- Set state for potential quarter screen
        lastArrow = "left"
        if arrowTimer then arrowTimer:stop() end
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

        -- Set state for potential quarter screen
        lastArrow = "right"
        if arrowTimer then arrowTimer:stop() end
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

        -- Set state for potential quarter screen
        lastArrow = "up"
        if arrowTimer then arrowTimer:stop() end
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

        -- Set state for potential quarter screen
        lastArrow = "down"
        if arrowTimer then arrowTimer:stop() end
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
end)

-- ==============================================