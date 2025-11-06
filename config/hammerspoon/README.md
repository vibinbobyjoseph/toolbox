# Hammerspoon Configuration

A comprehensive Hammerspoon configuration for macOS automation, providing powerful window management, application launching, and system control capabilities.

## Features

### 🚀 Application Launching
- **Hyper Key Combinations**: Launch apps instantly with `⌘+⌥+⌃+⇧ + key`
- **Single Key Access**: Quick app toggling with special keys (§, F13-F15)
- **URL Support**: Open specific URLs in designated browsers
- **Custom App Paths**: Support for non-standard application locations

### 🪟 Window Management
- **Screen Movement**: Move windows between displays with `⌃+⌥+⇧ + arrows`
- **Window Resizing**: Snap windows to halves/quarters with `⌃+⌥ + arrows`
- **Full Screen Toggle**: Maximize windows with `⌃+⌥ + return`

### 🖱️ Mouse Control
- **Keyboard Navigation**: Control mouse cursor with hyper key + arrows
- **Click Simulation**: Left/right click via keyboard shortcuts
- **Precision Movement**: Configurable movement speed and intervals

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
| Key | Application | Key | Application |
|-----|-------------|-----|-------------|
| `1` | Chrome | `j` | IntelliJ IDEA |
| `2` | Firefox | `t` | TablePlus |
| `v` | VS Code | `x` | TextMate |
| `n` | Notion | `p` | 1Password |
| `s` | Slack | `m` | Mail |
| `w` | WhatsApp | `g` | Sourcetree |
| `F1` | ChatGPT | `F2` | Claude |
| `F3` | Deepseek (web) | `F4` | Perplexity (web) |

### Single Key Access
| Key | Application | Behavior |
|-----|-------------|----------|
| `§` | iTerm | Toggle show/hide |
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

### System Controls
| Combination | Action |
|-------------|--------|
| `⌘+⌥+⌃+⇧ + F10` | Mute/unmute system |
| `⌘+⌥+⌃+⇧ + F11` | Volume down |
| `⌘+⌥+⌃+⇧ + F12` | Volume up |

## File Structure

```
.hammerspoon/
├── init.lua                          # Main configuration loader
├── README.md                         # This file
├── CLAUDE.md                         # Claude Code documentation
└── config/
    ├── hyperkey_app_launch.lua       # Hyper key app launching
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
["key"] = {app = "AppName", path = "/Applications/AppName.app"}
```

For web URLs:
```lua
["key"] = {
    type = "url",
    url = "https://example.com",
    browser = "Firefox",
    description = "Example Site"
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