-- Window Management Configuration
-- Centralized settings for window operations

local window = {}

-- Window positioning settings
window.positioning = {
    -- Maximize tolerance (pixels) - within this range is considered "maximized"
    maximizeTolerance = 10,

    -- Center window size (percentage of screen)
    centerWidth = 0.6,
    centerHeight = 0.7,

    -- Screen edge margins (pixels) - reserved space at screen edges
    edgeMargin = 0
}

-- Quarter-screen timing
window.quarterScreen = {
    comboTimeout = 0.5  -- Time window to press second arrow for quarter-screen (seconds)
}

-- Window animation settings
window.animation = {
    enabled = false,     -- Enable smooth animations
    duration = 0.2       -- Animation duration in seconds
}

return window
