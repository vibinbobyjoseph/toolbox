# Hammerspoon Configuration

A comprehensive Hammerspoon configuration for macOS automation, providing powerful window management, application launching, and system control capabilities.

## Features

### 🚀 Application Launching
- **Hyper Key Combinations**: Launch apps instantly with `⌘+⌥+⌃+⇧ + key`
- **Toggle Behavior**: Press the same combo to hide a focused app or bring it to front
- **Single Key Access**: Quick app toggling with special keys (§, F13)
- **URL Support**: Open specific URLs in designated browsers (Firefox, Chrome, Safari, Edge)
- **Custom App Paths**: Support for non-standard application locations
- **Bundle ID Support**: Fast app detection using bundle IDs

### 🪟 Window Management
- **Screen Movement**: Move windows between displays with `⌃+⌥+⇧ + arrows`
- **Window Resizing**: Snap windows to halves/quarters with `⌃+⌥ + arrows`
- **Full Screen Toggle**: Maximize windows with `⌃+⌥ + return`

### 🖱️ Mouse Control
- **Keyboard Navigation**: Control mouse cursor with `⌘+⌥+⌃+⇧ + arrows`
- **Click Simulation**: Left/middle/right click via keyboard shortcuts
- **Precision Movement**: Configurable movement speed and intervals (see utils.lua)

### 🔊 System Controls
- **Volume Management**: System volume controls with hyper key + F10-F12
- **Microphone Toggle**: Quick mic mute/unmute with F14
- **Visual Feedback**: On-screen alerts for all actions

## Quick Start

1. **Install Hammerspoon**: Download from [hammerspoon.org](https://www.hammerspoon.org/)
2. **Clone this config**:
   ```bash
   git clone https://github.com/vibinbobyjoseph/.hammerspoon.git ~/.hammerspoon
   ```
3. **Reload Hammerspoon**: Use menu bar icon → "Reload Config"

## Key Bindings

### Application Launching (Hyper Key: ⌘+⌥+⌃+⇧)
All apps support toggle behavior: Press once to launch/focus, press again to hide.

| Key | Application | Key | Application |
|-----|-------------|-----|-------------|
| `1` | Microsoft Edge | `i` | IntelliJ IDEA |
| `2` | Firefox | `t` | TablePlus |
| `3` | Microsoft Teams | `v` | VS Code |
| `c` | Claude | `x` | TextMate |
| `g` | ChatGPT | `p` | 1Password |
| `n` | Notion | `m` | Mail |
| `o` | Microsoft Outlook | `s` | Sourcetree |
| `w` | WhatsApp | `f4` | WezTerm |

### Single Key Access
| Key | Application | Behavior |
|-----|-------------|----------|
| `§` | WezTerm | Toggle show/hide |
| `F13` | Notion | Toggle show/hide |
| `F14` | Mic Toggle | Mute/unmute microphone |

### Window Management
| Combination | Action |
|-------------|--------|
| `⌃+⌥+⇧ + ←/→` | Move window between screens |
| `⌃+⌥ + ←` | Snap window to left half |
| `⌃+⌥ + →` | Snap window to right half |
| `⌃+⌥ + ↑` | Snap window to top half |
| `⌃+⌥ + ↓` | Snap window to bottom half |
| `⌃+⌥ + return` | Maximize window |

### Mouse Control

| Combination | Action |
|-------------|--------|
| `⌘+⌥+⌃+⇧ + ↑↓←→` | Move mouse cursor |
| `⌘+⌥+⌃+⇧ + End` | Left click |
| `⌘+⌥+⌃+⇧ + Home` | Middle click |
| `⌘+⌥+⌃+⇧ + PgDn` | Right click |

### System Controls
| Combination | Action |
|-------------|--------|
| `⌘+⌥+⌃+⇧ + F10` | Mute/unmute system |
| `⌘+⌥+⌃+⇧ + F11` | Volume down |
| `⌘+⌥+⌃+⇧ + F12` | Volume up |
| `F14` | Toggle microphone mute |

## File Structure

```
.hammerspoon/
├── init.lua                          # Main configuration loader
├── README.md                         # This file
├── CLAUDE.md                         # Claude Code documentation
└── config/
    ├── utils.lua                     # Shared utility functions
    ├── hyperkey_app_launch.lua       # Hyper key app launching (with toggle)
    ├── singlekey_app_launch.lua      # Single key app launching
    ├── window_move.lua               # Inter-screen window movement
    ├── window_resize.lua             # Window positioning/resizing
    ├── mouse.lua                     # Mouse cursor control
    ├── fn_keys.lua                   # Volume controls
    └── mute.lua                      # Microphone toggle
```

## Customization

### Adding New Applications
Edit `config/hyperkey_app_launch.lua` and add entries to the `appList` table:

```lua
["key"] = {
    app = "AppName",
    path = "/Applications/AppName.app",
    bundleID = "com.company.appname"  -- Optional but recommended for toggle
}
```

For web URLs:
```lua
["key"] = {
    type = "url",
    url = "https://example.com",
    browser = "Firefox",  -- Supports: Firefox, Chrome, Safari, Edge
    description = "Example Site"
}
```

### Configuring Mouse Speed

Edit `config/utils.lua` to adjust mouse movement parameters:

```lua
utils.mouseConfig = {
    moveAmount = 5,        -- Pixels per interval (increase for faster movement)
    moveInterval = 0.01    -- Time in seconds (decrease for smoother movement)
}
```

### Modifying Key Bindings
Each module uses different modifier key combinations:
- **Hyper Key**: `{"ctrl", "shift", "option", "command"}`
- **Window Move**: `{"ctrl", "alt", "shift"}`
- **Window Resize**: `{"ctrl", "alt"}`
- **Mouse Control**: `{"ctrl", "alt", "cmd", "shift"}`

## Requirements

- macOS 10.10 or later
- Hammerspoon 0.9.76 or later
- Accessibility permissions for Hammerspoon

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License

This configuration is open source and available under the [MIT License](LICENSE).