-- ==============================================
-- Shared utility functions for Hammerspoon config
-- ==============================================
--
-- DEPENDENCY LEVEL: 3 (Core Utilities)
-- Dependencies: Level 2 (config.settings.init)
-- Required by: Level 4+ (feature modules)
--
-- IMPORTANT: This module MUST NOT require:
-- - config.visual_feedback (same level, would cause coupling)
-- - Any feature modules (Level 4+)
-- See DEPENDENCY_HIERARCHY.md for details.

local utils = {}

-- Load centralized settings
local settings = require('config.settings.init')

--- Get the currently focused window
--- Falls back to frontmost window, then first ordered window
--- @return window|nil The focused window, or nil if none found
--- @return string|nil Error message if no window available
function utils.getActiveWindow()
    local win = hs.window.focusedWindow()
        or hs.window.frontmostWindow()
        or hs.window.orderedWindows()[1]

    if not win then
        return nil, "No focused window"
    end
    return win, nil
end

-- Export modules (removed feedback to break circular dependency)
-- Note: Modules should require 'config.visual_feedback' directly if needed
return {
    getActiveWindow = utils.getActiveWindow,
    mouseConfig = settings.mouseConfig,  -- Use centralized config
    settings = settings                   -- Export all settings
}
