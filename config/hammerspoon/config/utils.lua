-- ==============================================
-- Shared utility functions for Hammerspoon config
-- ==============================================

local utils = {}

-- Helper function to get active window with fallback methods
function utils.getActiveWindow()
    return hs.window.focusedWindow()
        or hs.window.frontmostWindow()
        or hs.window.orderedWindows()[1]
end

-- Configuration for mouse movement
utils.mouseConfig = {
    moveAmount = 5,        -- Number of pixels to move per interval
    moveInterval = 0.01    -- Time interval for continuous movement (in seconds)
}

-- Load visual feedback module
local feedback = require("config.visual_feedback")

-- Export modules
return {
    getActiveWindow = utils.getActiveWindow,
    mouseConfig = utils.mouseConfig,
    feedback = feedback
}
