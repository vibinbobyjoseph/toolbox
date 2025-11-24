-- Mouse Position Indicator (Crosshairs)
local mouseIndicator = nil
local updateTimer = nil

function toggleMouseIndicator()
    if mouseIndicator then
        if updateTimer then
            updateTimer:stop()
            updateTimer = nil
        end
        mouseIndicator:delete()
        mouseIndicator = nil
        return
    end

    local allScreens = hs.screen.allScreens()
    local totalFrame = allScreens[1]:fullFrame()

    for _, screen in ipairs(allScreens) do
        local frame = screen:fullFrame()
        totalFrame = totalFrame:union(frame)
    end

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

    updateTimer = hs.timer.doEvery(0.02, function()
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

hs.hotkey.bind({"ctrl", "alt", "cmd", "shift"}, "m", toggleMouseIndicator)

return {
    toggle = toggleMouseIndicator
}
