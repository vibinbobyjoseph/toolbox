local wezterm = require 'wezterm'
local config = {}

-- Use the newer config builder if available
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Set your font size (default is usually 12)
config.font_size = 14.0

return config