-- Mouse Position Indicator (Crosshairs)
local mouseIndicator = nil
local updateTimer = nil

-- Add screen frame cache
local screenFrameCache = {
    frame = nil,
    lastUpdate = 0,
    screens = {}
}

-- Helper: Get total screen frame with caching
local function getTotalScreenFrame()
    local screens = hs.screen.allScreens()
    local currentScreenCount = #screens

    -- Check if cache is valid
    local screensChanged = false
    if #screenFrameCache.screens ~= currentScreenCount then
        screensChanged = true
    else
        -- Check if screen IDs changed
        for i, screen in ipairs(screens) do
            if not screenFrameCache.screens[i] or
               screenFrameCache.screens[i]:id() ~= screen:id() then
                screensChanged = true
                break
            end
        end
    end

    -- Return cached frame if screens haven't changed
    if not screensChanged and screenFrameCache.frame then
        return screenFrameCache.frame
    end

    -- Recalculate frame
    local totalFrame = screens[1]:fullFrame()
    for i = 2, #screens do
        totalFrame = totalFrame:union(screens[i]:fullFrame())
    end

    -- Update cache
    screenFrameCache.frame = totalFrame
    screenFrameCache.screens = screens
    screenFrameCache.lastUpdate = hs.timer.secondsSinceEpoch()

    return totalFrame
end

local function toggleMouseIndicator()
    if mouseIndicator then
        if updateTimer then
            updateTimer:stop()
            updateTimer = nil
        end
        mouseIndicator:delete()
        mouseIndicator = nil
        return
    end

    -- Use cached screen frame calculation
    local totalFrame = getTotalScreenFrame()

    mouseIndicator = hs.canvas.new(totalFrame)
    mouseIndicator:level("overlay")
    mouseIndicator:clickActivating(false)

    -- Vertical line
    mouseIndicator[1] = {
        type = "segments",
        action = "stroke",
        strokeColor = {red = 1, green = 0, blue = 0, alpha = 0.7},
        strokeWidth = 2,
        coordinates = {}
    }

    -- Horizontal line
    mouseIndicator[2] = {
        type = "segments",
        action = "stroke",
        strokeColor = {red = 1, green = 0, blue = 0, alpha = 0.7},
        strokeWidth = 2,
        coordinates = {}
    }

    -- Circle
    mouseIndicator[3] = {
        type = "circle",
        action = "stroke",
        strokeColor = {red = 1, green = 0, blue = 0, alpha = 0.7},
        strokeWidth = 2,
        radius = 20,
        center = {}
    }

    mouseIndicator:show()

    -- Update canvas position to follow mouse (reduced frequency from 0.02 to 0.05)
    updateTimer = hs.timer.doEvery(0.05, function()
        if not mouseIndicator then return end

        local pos = hs.mouse.absolutePosition()
        local frame = mouseIndicator:frame()

        -- Vertical line
        mouseIndicator[1].coordinates = {
            {x = pos.x, y = 0},
            {x = pos.x, y = frame.h}
        }

        -- Horizontal line
        mouseIndicator[2].coordinates = {
            {x = 0, y = pos.y},
            {x = frame.w, y = pos.y}
        }

        -- Circle center
        mouseIndicator[3].center = {x = pos.x, y = pos.y}
    end)
end

-- Cleanup function for module reload
local function cleanup()
    if mouseIndicator then
        mouseIndicator:delete()
        mouseIndicator = nil
    end
    if updateTimer then
        updateTimer:stop()
        updateTimer = nil
    end
end

-- Watch for screen changes to invalidate cache
local screenWatcher = hs.screen.watcher.new(function()
    screenFrameCache.frame = nil
    screenFrameCache.screens = {}
end)
screenWatcher:start()

hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "m", toggleMouseIndicator)

return {
    toggle = toggleMouseIndicator,
    cleanup = cleanup
}
