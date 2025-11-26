-- Centralized Configuration Module
-- Loads all configuration settings for Hammerspoon
--
-- DEPENDENCY LEVEL: 2 (Settings Aggregator)
-- Dependencies: Level 1 only (settings/*)
-- Required by: Level 3+ (utils, visual_feedback, feature modules)
--
-- IMPORTANT: This module MUST NOT require any modules outside of config/settings/*
-- to prevent circular dependencies. See DEPENDENCY_HIERARCHY.md for details.

local settings = {}

-- Load all configuration modules
settings.visual = require('config.settings.visual')
settings.mouse = require('config.settings.mouse')
settings.window = require('config.settings.window')
settings.timing = require('config.settings.timing')

-- Legacy compatibility: maintain mouseConfig for backward compatibility
settings.mouseConfig = {
    moveAmount = settings.mouse.movement.baseSpeed,
    moveInterval = settings.mouse.movement.moveInterval
}

return settings
