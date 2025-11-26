local hyperKey = {"ctrl", "alt", "cmd", "shift"}
local utils = require("config.utils")
local moveInterval = utils.mouseConfig.moveInterval

-- Mouse acceleration state
local mouseState = {
    timers = {up = nil, down = nil, left = nil, right = nil},
    holdDuration = {},
    baseSpeed = utils.settings.mouse.movement.baseSpeed,
    maxSpeed = utils.settings.mouse.movement.maxSpeed,
    accelerationRate = utils.settings.mouse.movement.accelerationRate
}

local function calculateSpeed(direction)
    local duration = mouseState.holdDuration[direction] or 0
    local speed

    -- Two-phase acceleration for best of both worlds:
    -- Phase 1 (0.0-0.1s): Precision mode at 1 pixel/tick
    -- Phase 2 (0.1s+): Aggressive quadratic acceleration
    local precisionDelay = 0.1  -- Reduced from 0.3s for faster response

    if duration < precisionDelay then
        speed = 1  -- Ultra-precise movement for small adjustments
    else
        -- After brief precision window, accelerate rapidly
        -- Subtract precision delay and use aggressive multiplier
        local accelDuration = duration - precisionDelay
        -- Using higher multiplier (30) for faster acceleration
        local acceleration = 30 * accelDuration * accelDuration
        speed = 1 + acceleration
    end

    return math.min(speed, mouseState.maxSpeed)
end

-- Helper: Clamp mouse position within all screens bounds (allows cross-monitor movement)
local function clampPosition(pos)
    if not pos then return pos end

    -- Calculate the total desktop bounds across all screens
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge

    for _, screen in ipairs(hs.screen.allScreens()) do
        local frame = screen:fullFrame()
        minX = math.min(minX, frame.x)
        minY = math.min(minY, frame.y)
        maxX = math.max(maxX, frame.x + frame.w)
        maxY = math.max(maxY, frame.y + frame.h)
    end

    -- Clamp to total desktop bounds (with 1px margin to avoid edge issues)
    pos.x = math.max(minX + 1, math.min(pos.x, maxX - 1))
    pos.y = math.max(minY + 1, math.min(pos.y, maxY - 1))

    return pos
end

local function startMouseMove(direction)
    if mouseState.timers[direction] then return end

    mouseState.holdDuration[direction] = 0
    local startTime = hs.timer.secondsSinceEpoch()

    mouseState.timers[direction] = hs.timer.doEvery(moveInterval, function()
        mouseState.holdDuration[direction] = hs.timer.secondsSinceEpoch() - startTime
        local speed = calculateSpeed(direction)

        -- Use absolute position for cross-monitor support
        local pos = hs.mouse.absolutePosition()
        if direction == "up" then
            pos.y = pos.y - speed
        elseif direction == "down" then
            pos.y = pos.y + speed
        elseif direction == "left" then
            pos.x = pos.x - speed
        elseif direction == "right" then
            pos.x = pos.x + speed
        end

        -- Clamp position to total desktop bounds
        pos = clampPosition(pos)
        hs.mouse.absolutePosition(pos)
    end)
end

local function stopMouseMove(direction)
    if mouseState.timers[direction] then
        mouseState.timers[direction]:stop()
        mouseState.timers[direction] = nil
        mouseState.holdDuration[direction] = 0
    end
end

-- Bind arrow keys for continuous mouse movement
hs.hotkey.bind(hyperKey, "up", function() startMouseMove("up") end, function() stopMouseMove("up") end)
hs.hotkey.bind(hyperKey, "down", function() startMouseMove("down") end, function() stopMouseMove("down") end)
hs.hotkey.bind(hyperKey, "left", function() startMouseMove("left") end, function() stopMouseMove("left") end)
hs.hotkey.bind(hyperKey, "right", function() startMouseMove("right") end, function() stopMouseMove("right") end)

-- Function to simulate mouse clicks
local function mouseClick(button)
    local eventTypeDown, eventTypeUp

    if button == "left" then
        eventTypeDown = hs.eventtap.event.types.leftMouseDown
        eventTypeUp = hs.eventtap.event.types.leftMouseUp
    elseif button == "middle" then
        eventTypeDown = hs.eventtap.event.types.otherMouseDown
        eventTypeUp = hs.eventtap.event.types.otherMouseUp
    elseif button == "right" then
        eventTypeDown = hs.eventtap.event.types.rightMouseDown
        eventTypeUp = hs.eventtap.event.types.rightMouseUp
    else
        return
    end

    local pos = hs.mouse.absolutePosition()
    hs.eventtap.event.newMouseEvent(eventTypeDown, pos):post()
    hs.timer.usleep(20000)  -- 20ms delay between down and up
    hs.eventtap.event.newMouseEvent(eventTypeUp, pos):post()
end

-- Function to send multiple clicks with proper clickCount property
-- This handles single, double, and triple clicks
local function sendMultipleClicks(button, clickCount)
    local eventTypeDown, eventTypeUp

    if button == "left" then
        eventTypeDown = hs.eventtap.event.types.leftMouseDown
        eventTypeUp = hs.eventtap.event.types.leftMouseUp
    elseif button == "middle" then
        eventTypeDown = hs.eventtap.event.types.otherMouseDown
        eventTypeUp = hs.eventtap.event.types.otherMouseUp
    elseif button == "right" then
        eventTypeDown = hs.eventtap.event.types.rightMouseDown
        eventTypeUp = hs.eventtap.event.types.rightMouseUp
    else
        return
    end

    local pos = hs.mouse.absolutePosition()

    -- Send the sequence of clicks
    for i = 1, clickCount do
        -- Send mouse down event
        local downEvent = hs.eventtap.event.newMouseEvent(eventTypeDown, pos)
        downEvent:setProperty(hs.eventtap.event.properties.mouseEventClickState, i)
        downEvent:post()
        hs.timer.usleep(20000)  -- 20ms between down and up

        -- Send mouse up event
        local upEvent = hs.eventtap.event.newMouseEvent(eventTypeUp, pos)
        upEvent:setProperty(hs.eventtap.event.properties.mouseEventClickState, i)
        upEvent:post()

        -- Delay between clicks (except after the last one)
        if i < clickCount then
            hs.timer.usleep(50000)  -- 50ms between clicks
        end
    end
end

-- Convenience functions for specific click types
local function mouseDoubleClick(button)
    sendMultipleClicks(button, 2)
end

local function mouseTripleClick(button)
    sendMultipleClicks(button, 3)
end

-- State management for detecting single/double/triple clicks
local clickState = {
    lastTime = 0,
    threshold = 0.5,  -- 500ms window to detect multiple clicks (matches macOS default)
    clickCount = 0,   -- Track number of clicks in sequence
    singleClickTimer = nil,
    resetTimer = nil
}

-- Bind keys for mouse clicks
-- Note: Using forwarddelete (Fn+Delete on Mac) since many MacBooks don't have End key
hs.hotkey.bind(hyperKey, "forwarddelete", function()
    local currentTime = hs.timer.secondsSinceEpoch()
    local timeSinceLastClick = currentTime - clickState.lastTime

    -- Check if this is part of a multi-click sequence
    if timeSinceLastClick < clickState.threshold and clickState.clickCount > 0 then
        -- This is a continuation of the click sequence
        clickState.clickCount = clickState.clickCount + 1
        clickState.lastTime = currentTime  -- Update lastTime for next click

        -- Cancel any pending single-click timer
        if clickState.singleClickTimer then
            clickState.singleClickTimer:stop()
            clickState.singleClickTimer = nil
        end

        -- Cancel any pending reset timer
        if clickState.resetTimer then
            clickState.resetTimer:stop()
            clickState.resetTimer = nil
        end

        -- Send the appropriate multi-click based on count
        if clickState.clickCount == 2 then
            -- Double-click
            sendMultipleClicks("left", 2)
        elseif clickState.clickCount == 3 then
            -- Triple-click
            sendMultipleClicks("left", 3)
        elseif clickState.clickCount > 3 then
            -- Beyond triple-click, just send single clicks
            mouseClick("left")
        end

        -- Set timer to reset click count after threshold
        clickState.resetTimer = hs.timer.doAfter(clickState.threshold, function()
            clickState.clickCount = 0
            clickState.lastTime = 0
            clickState.resetTimer = nil
        end)
    else
        -- This is the start of a new click sequence
        clickState.clickCount = 1
        clickState.lastTime = currentTime

        -- Cancel any existing timers
        if clickState.singleClickTimer then
            clickState.singleClickTimer:stop()
        end
        if clickState.resetTimer then
            clickState.resetTimer:stop()
        end

        -- Set up delayed single click (in case no second click comes)
        clickState.singleClickTimer = hs.timer.doAfter(clickState.threshold, function()
            -- No second press came, send single click
            mouseClick("left")
            clickState.singleClickTimer = nil
            -- Reset the click sequence (but keep lastTime for potential future sequence)
            clickState.clickCount = 0
        end)
    end
end)

hs.hotkey.bind(hyperKey, "end", function()
    mouseClick("right")
end)

-- Scroll wheel emulation
local scrollTimers = {up = nil, down = nil, left = nil, right = nil}
local scrollAmount = 3

local function startScrolling(direction)
    if scrollTimers[direction] then return end

    scrollTimers[direction] = hs.timer.doEvery(0.1, function()  -- Optimized from 0.05 to 0.1
        local scrollValues = {x = 0, y = 0}

        if direction == "up" then
            scrollValues.y = scrollAmount
        elseif direction == "down" then
            scrollValues.y = -scrollAmount
        elseif direction == "left" then
            scrollValues.x = scrollAmount
        elseif direction == "right" then
            scrollValues.x = -scrollAmount
        end

        hs.eventtap.scrollWheel(scrollValues, {}, "line")
    end)
end

local function stopScrolling(direction)
    if scrollTimers[direction] then
        scrollTimers[direction]:stop()
        scrollTimers[direction] = nil
    end
end

-- Use different modifier to avoid conflict with mouse movement
local scrollMod = {"ctrl", "shift", "cmd"}
hs.hotkey.bind(scrollMod, "up",
    function() startScrolling("up") end,
    function() stopScrolling("up") end)
hs.hotkey.bind(scrollMod, "down",
    function() startScrolling("down") end,
    function() stopScrolling("down") end)
hs.hotkey.bind(scrollMod, "left",
    function() startScrolling("left") end,
    function() stopScrolling("left") end)
hs.hotkey.bind(scrollMod, "right",
    function() startScrolling("right") end,
    function() stopScrolling("right") end)

-- Cleanup function for module reload
local function cleanup()
    -- Stop all movement timers
    for direction, timer in pairs(mouseState.timers) do
        if timer then
            timer:stop()
        end
    end
    mouseState.timers = {}

    -- Stop all scroll timers
    for direction, timer in pairs(scrollTimers) do
        if timer then
            timer:stop()
        end
    end
    scrollTimers = {}

    -- Stop pending single-click timer
    if clickState.singleClickTimer then
        clickState.singleClickTimer:stop()
        clickState.singleClickTimer = nil
    end

    -- Stop pending reset timer
    if clickState.resetTimer then
        clickState.resetTimer:stop()
        clickState.resetTimer = nil
    end
end

-- Call cleanup on module load to prevent leaks from previous loads
cleanup()

-- Module export
local module = {
    cleanup = cleanup
}
return module