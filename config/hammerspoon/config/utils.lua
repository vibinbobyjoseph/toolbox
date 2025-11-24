-- ==============================================
-- Shared utility functions for Hammerspoon config
-- ==============================================

local utils = {}

-- Load centralized settings
local settings = require('config.settings.init')

-- Get the currently focused window
-- Returns: window object or nil, error message
function utils.getActiveWindow()
    local win = hs.window.focusedWindow()
        or hs.window.frontmostWindow()
        or hs.window.orderedWindows()[1]

    if not win then
        return nil, "No focused window"
    end
    return win, nil
end

-- Load visual feedback module
local feedback = require("config.visual_feedback")

-- Export modules
return {
    getActiveWindow = utils.getActiveWindow,
    mouseConfig = settings.mouseConfig,  -- Use centralized config
    settings = settings,                  -- Export all settings
    feedback = feedback
}
