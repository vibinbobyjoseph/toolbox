local wezterm = require 'wezterm'
local config = {}

-- Use the newer config builder if available
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ========================================
-- APPEARANCE
-- ========================================

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
config.font_size = 14.0

-- Color scheme
config.color_scheme = 'Gruvbox Dark'

-- Transparency & blur
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- Window padding
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Keep title bar (removed the window_decorations line)

-- ========================================
-- TAB BAR
-- ========================================

config.use_fancy_tab_bar = true  -- Use macOS native-style tabs (integrates with title bar)
config.tab_bar_at_bottom = false  -- Keep at top with title bar
config.tab_max_width = 32  -- Limit tab width so you can see more tabs

-- Show tab index numbers for easy navigation
config.show_tab_index_in_tab_bar = true

-- ========================================
-- TITLE BAR - Show current directory & process
-- ========================================

-- Format the window title
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local zoomed = ''
  if tab.active_pane.is_zoomed then
    zoomed = '[Z] '
  end

  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

-- Format individual tab titles
-- Format individual tab titles
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = pane.title
  
  -- Get the current working directory
  local cwd = pane.current_working_dir
  if cwd then
    local cwd_uri = cwd
    -- Extract just the directory name
    cwd = cwd_uri.file_path or cwd_uri.path or cwd
    -- Get just the last part of the path
    local dir = cwd:match("([^/]+)/?$")
    if dir then
      title = dir
    end
  end
  
  -- Get the running process
  local process = pane.foreground_process_name
  if process then
    -- Extract just the process name (not full path)
    process = process:match("([^/]+)$")
    -- Only show if it's not the shell
    if process and process ~= "zsh" and process ~= "bash" and process ~= "fish" then
      title = string.format("%s: %s", process, title)
    end
  end
  
  -- Let Wezterm use the theme's colors automatically
  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

-- ========================================
-- KEY BINDINGS
-- ========================================

config.keys = {
  -- Split panes
  { key = '|', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  
  -- Navigate panes (vim-style hjkl)
  { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
  
  -- Close pane
  { key = 'x', mods = 'CMD|SHIFT', action = wezterm.action.CloseCurrentPane { confirm = true } },
  
  -- Resize panes
  { key = 'LeftArrow', mods = 'CMD|SHIFT|OPT', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CMD|SHIFT|OPT', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'CMD|SHIFT|OPT', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'CMD|SHIFT|OPT', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  
  -- Zoom pane (toggle fullscreen for current pane)
  { key = 'z', mods = 'CMD|SHIFT', action = wezterm.action.TogglePaneZoomState },
  
  -- Quick select (URLs, file paths, hashes)
  { key = ' ', mods = 'CMD|SHIFT', action = wezterm.action.QuickSelect },
}

return config