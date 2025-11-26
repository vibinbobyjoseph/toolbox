-- Mouse Configuration
-- Centralized settings for mouse control and indicator

local mouse = {}

-- Mouse movement settings
mouse.movement = {
    baseSpeed = 5,           -- Pixels per interval (starting speed)
    maxSpeed = 80,           -- Maximum speed with acceleration
    accelerationRate = 15,   -- Acceleration multiplier (used with duration²)
    moveInterval = 0.02      -- Update frequency in seconds (50 FPS)
}

-- Scroll settings
mouse.scroll = {
    amount = 3,              -- Scroll distance per tick
    interval = 0.1           -- Scroll frequency in seconds (10 FPS)
}

-- Mouse click settings
mouse.click = {
    doubleClickThreshold = 0.5,  -- Time window for double-click (seconds)
    clickDelay = 0.02            -- Delay between mouseDown and mouseUp (seconds)
}

-- Mouse indicator (crosshairs) settings
mouse.indicator = {
    updateInterval = 0.05,   -- Update frequency in seconds (20 FPS)
    lineColor = {red = 1, green = 0, blue = 0, alpha = 0.7},
    lineWidth = 2,
    circleRadius = 20
}

return mouse
