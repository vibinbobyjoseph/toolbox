-- Centralized Configuration Module
-- Loads all configuration settings for Hammerspoon

local settings = {}

-- Load all configuration modules
settings.visual = require('config.settings.visual')
settings.mouse = require('config.settings.mouse')
settings.window = require('config.settings.window')

-- Legacy compatibility: maintain mouseConfig for backward compatibility
settings.mouseConfig = {
    moveAmount = settings.mouse.movement.baseSpeed,
    moveInterval = settings.mouse.movement.moveInterval
}

return settings
