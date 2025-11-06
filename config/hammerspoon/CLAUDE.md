# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Hammerspoon configuration for macOS window management, application launching, and system control. Hammerspoon is a macOS automation tool that uses Lua scripting to provide powerful desktop automation capabilities.

## Architecture

The configuration is organized into modular Lua files in the `config/` directory:

- `init.lua` - Main entry point that loads all configuration modules
- `config/hyperkey_app_launch.lua` - Hyper key (⌘+⌥+⌃+⇧) + key combinations for launching applications and URLs
- `config/singlekey_app_launch.lua` - Single key bindings (§, F13-F15) for quick app access with toggle behavior
- `config/window_move.lua` - Window movement between screens using ⌃+⌥+⇧ + arrow keys
- `config/window_resize.lua` - Window resizing and positioning using ⌃+⌥ + arrow keys/return
- `config/mouse.lua` - Mouse cursor control using hyper key + arrow keys and clicking
- `config/fn_keys.lua` - System volume controls using hyper key + F10-F12
- `config/mute.lua` - Microphone mute toggle using F14

## Key Binding Patterns

### Modifier Key Combinations
- **Hyper Key**: `{"ctrl", "shift", "option", "command"}` - Used for app launching
- **Window Move**: `{"ctrl", "alt", "shift"}` - Used for moving windows between screens
- **Window Resize**: `{"ctrl", "alt"}` - Used for window resizing and positioning
- **Mouse Control**: `{"ctrl", "alt", "cmd", "shift"}` - Used for mouse movement and clicking
- **Volume Control**: `{"cmd", "alt", "ctrl", "shift"}` - Used for system volume controls

### Application Launch Configuration
Applications are defined in tables with:
- `app` - Application name
- `path` - Custom application path (optional)
- `type` - Set to "url" for web URLs
- `url` - URL to open (for URL type)
- `browser` - Browser to use for URLs
- `description` - Display name for alerts

## Development Commands

### Testing Changes
```bash
# Reload Hammerspoon configuration
# Use Hammerspoon menu bar icon > Reload Config
# Or programmatically: hs.reload()
```

### Debugging
- Hammerspoon provides built-in console for debugging Lua scripts
- Use `hs.alert.show("message")` for user notifications
- Use `hs.notify.new({title="Title", informativeText="Message"}):send()` for system notifications

## Common Customizations

### Adding New Applications
Edit `config/hyperkey_app_launch.lua` and add entries to the `appList` table:
```lua
["key"] = {app = "AppName", path = "/Applications/AppName.app"}
```

### Adding Single-Key Apps
Edit `config/singlekey_app_launch.lua` and add entries to the `singleKeyApps` table:
```lua
["f15"] = {app = "AppName", description = "Display Name"}
```

### Modifying Window Management
- Window positioning logic is in `config/window_resize.lua`
- Screen movement logic is in `config/window_move.lua`
- Both use Hammerspoon's window and screen APIs

## File Structure
```
.hammerspoon/
├── init.lua                          # Main configuration loader
└── config/
    ├── hyperkey_app_launch.lua       # Hyper key app launching
    ├── singlekey_app_launch.lua      # Single key app launching
    ├── window_move.lua               # Inter-screen window movement
    ├── window_resize.lua             # Window positioning/resizing
    ├── mouse.lua                     # Mouse cursor control
    ├── fn_keys.lua                   # Volume controls
    └── mute.lua                      # Microphone toggle
```