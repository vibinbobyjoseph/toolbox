local hyperKey = {"ctrl", "alt", "cmd", "shift"}
local utils = require("config.utils")
local moveInterval = utils.mouseConfig.moveInterval

-- Mouse acceleration state
local mouseState = {
    timers = {up = nil, down = nil, left = nil, right = nil},
    holdDuration = {},
    baseSpeed = utils.mouseConfig.moveAmount,
    maxSpeed = 80,
    accelerationRate = 3
}

local function calculateSpeed(direction)
    local duration = mouseState.holdDuration[direction] or 0
    local speed = mouseState.baseSpeed + (duration * mouseState.accelerationRate)
    return math.min(speed, mouseState.maxSpeed)
end

local function startMouseMove(direction)
    if mouseState.timers[direction] then return end

    mouseState.holdDuration[direction] = 0
    local startTime = hs.timer.secondsSinceEpoch()

    mouseState.timers[direction] = hs.timer.doEvery(moveInterval, function()
        mouseState.holdDuration[direction] = hs.timer.secondsSinceEpoch() - startTime
        local speed = calculateSpeed(direction)

        local pos = hs.mouse.getRelativePosition()
        if direction == "up" then
            pos.y = pos.y - speed
        elseif direction == "down" then
            pos.y = pos.y + speed
        elseif direction == "left" then
            pos.x = pos.x - speed
        elseif direction == "right" then
            pos.x = pos.x + speed
        end
        hs.mouse.setRelativePosition(pos)
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

-- Function to simulate double-click by sending two clicks in rapid succession
local function mouseDoubleClick(button)
    -- First click
    mouseClick(button)
    -- Wait 150ms then send second click
    hs.timer.doAfter(0.15, function()
        mouseClick(button)
    end)
end

-- Track for double-click detection
local lastClickTime = 0
local doubleClickThreshold = 0.5  -- 500ms

-- Bind keys for mouse clicks
-- Note: Using forwarddelete (Fn+Delete on Mac) since many MacBooks don't have End key
hs.hotkey.bind(hyperKey, "forwarddelete", function()
    local now = hs.timer.secondsSinceEpoch()

    if (now - lastClickTime) < doubleClickThreshold then
        -- Double click detected - send two clicks in rapid succession
        mouseDoubleClick("left")
        lastClickTime = 0  -- Reset to prevent triple-click
    else
        -- Single click
        mouseClick("left")
        lastClickTime = now
    end
end)

hs.hotkey.bind(hyperKey, "pagedown", function()
    mouseClick("right")
end)

-- Scroll wheel emulation
local scrollTimers = {up = nil, down = nil, left = nil, right = nil}
local scrollAmount = 3

local function startScrolling(direction)
    if scrollTimers[direction] then return end

    scrollTimers[direction] = hs.timer.doEvery(0.05, function()
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