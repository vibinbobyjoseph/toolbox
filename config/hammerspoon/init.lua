-- Init.lua: Main entry point for your Hammerspoon configuration

-- Show a message to indicate Hammerspoon config has been loaded
hs.notify.new({title="Hammerspoon", informativeText="Configuration loaded successfully!"}):send()

-- Include separate Lua files for different functionality
-- require("config.hyper_key")
require("config.hyperkey_app_launch")
require("config.singlekey_app_launch")
require("config.window_move")
require("config.window_resize")
require("config.mouse")
require("config.fn_keys")
require("config.mute")