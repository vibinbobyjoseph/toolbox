-- Init.lua: Main entry point for your Hammerspoon configuration

-- Preload commonly used extensions to avoid lazy-loading delays on first keypress
-- This prevents the 10-second delay when launching apps for the first time
local _ = hs.application  -- Force load application extension
local _ = hs.window       -- Force load window extension
local _ = hs.alert        -- Force load alert extension
local _ = hs.keycodes     -- Force load keycodes extension
local _ = hs.fnutils      -- Force load fnutils extension

-- Show a message to indicate Hammerspoon config has been loaded
hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded successfully!"}):send()

-- Include separate Lua files for different functionality
require("config.utils")
require("config.hyperkey_app_launch")
require("config.singlekey_app_launch")
require("config.window_move")
require("config.window_resize")
require("config.mouse")
require("config.fn_keys")
require("config.mute")