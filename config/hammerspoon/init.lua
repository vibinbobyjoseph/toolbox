-- Init.lua: Main entry point for your Hammerspoon configuration
--
-- DEPENDENCY LEVEL: 7 (Main Entry Point)
-- This is the top-level loader - it requires all modules but is never required by them
-- Module load order follows the dependency hierarchy (see DEPENDENCY_HIERARCHY.md):
--   1. Settings (pure data)
--   2. Core utilities (utils, visual_feedback)
--   3. Feature modules (window, mouse, launchers, etc.)
--   4. Watchers and system integration

-- Check for required macOS accessibility permissions
-- Without these, window management and hotkeys won't work
if not hs.accessibilityState() then
    hs.notify.new({
        title = "Hammerspoon Needs Permissions",
        informativeText = "Please grant Accessibility access in System Settings → Privacy & Security → Accessibility",
        actionButtonTitle = "Open Settings",
        hasActionButton = true
    }, function(notification)
        if notification:activationType() == hs.notify.activationTypes.actionButtonClicked then
            hs.execute("open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'")
        end
    end):send()

    -- Log the issue
    hs.logger.new('init', 'warning'):w("Accessibility permissions not granted")
end

-- Modules are loaded on-demand, no preloading needed

-- Show a message to indicate Hammerspoon config has been loaded (commented to reduce notification spam)
-- hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded successfully!"}):send()

-- Manual reload hotkey
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "r", function()
    hs.reload()
end)

-- Include separate Lua files for different functionality
require("config.utils")
require("config.visual_feedback")
require("config.menubar_status")
require("config.caffeine")
require("config.hyperkey_app_launch")
require("config.singlekey_app_launch")
require("config.window_move")
require("config.window_resize")
require("config.mouse")
-- require("config.mouse_indicator")  -- Disabled: crosshairs not needed
require("config.fn_keys")
require("config.mute")

-- Screen configuration watcher (repositions windows on monitor changes)
local screenWatcher = require('config.screen_watcher')

-- Window event watcher (optional auto-tiling on app launch - disabled by default)
-- To enable: Edit config/window_rules.lua and set enabled = true
local windowEventWatcher = require('config.window_event_watcher')

-- Periodically check if permissions are still granted (track timer for cleanup - Issue #11.2)
local permissionsCheckTimer = hs.timer.doEvery(300, function()  -- Check every 5 minutes
    if not hs.accessibilityState() then
        hs.notify.new({
            title = "Hammerspoon Permissions Lost",
            informativeText = "Accessibility access was revoked. Features disabled."
        }):send()
    end
end)