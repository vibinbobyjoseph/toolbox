local hyperKey = {"ctrl", "alt", "cmd", "shift"}
local moveAmount = 5 -- Number of pixels to move per interval
local moveInterval = 0.01 -- Time interval for continuous movement (in seconds)

local mouseTimers = {
    up = nil,
    down = nil,
    left = nil,
    right = nil
}

-- Function to start moving the mouse
local function startMouseMove(direction)
    if mouseTimers[direction] then return end
    mouseTimers[direction] = hs.timer.doEvery(moveInterval, function()
        local pos = hs.mouse.getRelativePosition()
        if direction == "up" then
            pos.y = pos.y - moveAmount
        elseif direction == "down" then
            pos.y = pos.y + moveAmount
        elseif direction == "left" then
            pos.x = pos.x - moveAmount
        elseif direction == "right" then
            pos.x = pos.x + moveAmount
        end
        hs.mouse.setRelativePosition(pos)
    end)
end

-- Function to stop moving the mouse
local function stopMouseMove(direction)
    if mouseTimers[direction] then
        mouseTimers[direction]:stop()
        mouseTimers[direction] = nil
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

    local pos = hs.mouse.getAbsolutePosition()
    hs.eventtap.event.newMouseEvent(eventTypeDown, pos):post()
    hs.timer.usleep(10000) -- Small delay to simulate a real click
    hs.eventtap.event.newMouseEvent(eventTypeUp, pos):post()
end

-- Bind keys for mouse clicks
hs.hotkey.bind(hyperKey, "end", function() mouseClick("left") end) -- Left click
-- hs.hotkey.bind(hyperKey, "end", function() mouseClick("middle") end) -- Middle click
hs.hotkey.bind(hyperKey, "pageDown", function() mouseClick("right") end) -- Right click