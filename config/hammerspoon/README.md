# Hammerspoon Configuration

A comprehensive Hammerspoon configuration for macOS automation, providing powerful window management, application launching, mouse control, and system control capabilities.

## Features

### 🚀 Application Launching

- **Hyper Key Combinations**: Launch apps instantly with `Hyper + key` (Ctrl+Alt+Cmd+Shift)
- **Toggle Behavior**: Press the same combo to hide a focused app or bring it to front
- **Single Key Access**: Quick app toggling with special keys (§, F13)
- **URL Support**: Open specific URLs in designated browsers (Firefox, Chrome, Safari, Edge)
- **Custom App Paths**: Support for non-standard application locations
- **Bundle ID Support**: Fast app detection using bundle IDs for reliable toggle behavior

### 🪟 Window Management

- **Screen Movement**: Move windows between displays with `Ctrl+Alt+Shift + arrows`
- **Window Resizing**: Snap windows to halves/quarters with `Ctrl+Alt + arrows`
- **Full Screen Toggle**: Maximize windows with `Ctrl+Alt + return`
- **Auto-Positioning**: Optional rule-based window positioning (disabled by default)
- **Screen Watcher**: Automatic window repositioning when displays change

### 🖱️ Mouse Control

- **Keyboard Navigation**: Control mouse cursor with `Hyper + arrows`
- **Acceleration**: Precision mode (1px) for first 0.1s, then quadratic acceleration
- **Multi-Screen Support**: Seamless cursor movement across multiple displays
- **Click Simulation**:
  - Left click with `Hyper + ForwardDelete` (supports double/triple click)
  - Right click with `Hyper + End`
- **Scroll Control**: Smooth scrolling with `Hyper + PageUp/PageDown`
- **Configurable Speed**: Adjustable movement and scroll parameters

### ☕ System Controls

- **Caffeine Mode**: Prevent system sleep with menubar toggle (☕/💤 icon)
- **Volume Management**: System volume controls with `Hyper + F10-F12`
- **Microphone Toggle**: Quick mic mute/unmute with F14
- **Visual Feedback**: On-screen alerts for all actions
- **Menubar Status**: Quick-reload button and status indicator

## Quick Start

1. **Install Hammerspoon**: Download from [hammerspoon.org](https://www.hammerspoon.org/)
2. **Link or Copy this config**:

   ```bash
   # Option 1: Symlink (recommended for development)
   ln -s ~/Code/jcl/toolbox/config/hammerspoon ~/.hammerspoon

   # Option 2: Copy
   cp -r config/hammerspoon ~/.hammerspoon
   ```

3. **Grant Accessibility Permissions**:
   - System Settings → Privacy & Security → Accessibility
   - Add Hammerspoon to the list and enable it

4. **Reload Hammerspoon**: Click the "HS" menubar icon or press `Cmd+Alt+Ctrl+R`

5. **Test the Setup**:
   - Try `Hyper + V` to launch VS Code
   - Try `Hyper + Arrow Keys` to move mouse cursor
   - Try `Hyper + PageUp` to scroll (use `Fn+Up` on MacBook)

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
| `Hyper + ↑↓←→` | Move mouse cursor (with acceleration) |
| `Hyper + ForwardDelete` | Left click (rapid presses = double/triple click) |
| `Hyper + End` | Right click |
| `Hyper + PageUp` | Scroll up |
| `Hyper + PageDown` | Scroll down |

**Note**: Hyper = `Ctrl+Alt+Cmd+Shift`. On MacBooks, use `Fn+Up/Down` for PageUp/PageDown.

### System Controls

| Combination | Action |
|-------------|--------|
| `Hyper + F10` | Mute/unmute system volume |
| `Hyper + F11` | Volume down |
| `Hyper + F12` | Volume up |
| `F14` | Toggle microphone mute |
| `☕/💤 (menubar)` | Toggle caffeine mode (click to prevent sleep) |
| `HS (menubar)` | Quick reload Hammerspoon config (click) |

## File Structure

```text
config/hammerspoon/
├── init.lua                          # Main configuration loader
├── README.md                         # This file
├── CLAUDE.md                         # Claude Code documentation
└── config/
    ├── utils.lua                     # Shared utility functions and settings
    ├── visual_feedback.lua           # On-screen alerts and notifications
    ├── menubar_status.lua            # Menubar status indicator
    ├── caffeine.lua                  # Prevent system sleep mode
    ├── hyperkey_app_launch.lua       # Hyper key app launching (with toggle)
    ├── singlekey_app_launch.lua      # Single key app launching
    ├── window_move.lua               # Inter-screen window movement
    ├── window_resize.lua             # Window positioning/resizing
    ├── window_rules.lua              # Auto-positioning rules (optional)
    ├── window_event_watcher.lua      # Window event monitoring
    ├── screen_watcher.lua            # Monitor configuration changes
    ├── mouse.lua                     # Mouse cursor control and scrolling
    ├── fn_keys.lua                   # Volume controls
    ├── mute.lua                      # Microphone toggle
    ├── launchers/
    │   └── init.lua                  # App launcher core logic
    └── settings/
        ├── init.lua                  # Settings loader
        ├── mouse.lua                 # Mouse configuration
        ├── timing.lua                # Timing constants
        ├── visual.lua                # Visual feedback settings
        └── window.lua                # Window management settings
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

### Configuring Mouse Movement and Scrolling

Edit `config/settings/mouse.lua` to adjust mouse parameters:

```lua
-- Mouse movement settings
movement = {
    baseSpeed = 1,           -- Starting speed (pixels per tick)
    maxSpeed = 100,          -- Maximum speed with acceleration
    accelerationRate = 30    -- How quickly speed increases
}

-- Scroll settings (in config/mouse.lua)
scrollAmount = 2             -- Pixels to scroll per update
scrollInterval = 0.03        -- Time between scroll updates (30ms)
```

**Customization Tips**:

- For **faster scrolling**: Increase `scrollAmount` or decrease `scrollInterval`
- For **smoother scrolling**: Decrease `scrollAmount` and `scrollInterval`
- For **faster mouse**: Increase `accelerationRate` or `maxSpeed`
- For **more precision**: Increase the precision delay in `mouse.lua` (currently 0.1s)

### Modifying Key Bindings

Each module uses different modifier key combinations:

- **Hyper Key** (App Launcher, Mouse, Volume): `{"ctrl", "alt", "cmd", "shift"}`
- **Window Move** (Between Screens): `{"ctrl", "alt", "shift"}`
- **Window Resize** (Snap to Half/Quarter): `{"ctrl", "alt"}`

To change bindings, edit the respective module files in `config/` directory.

### Enabling Auto-Window Positioning

Window auto-positioning is disabled by default. To enable:

1. Edit `config/window_rules.lua`
2. Set `enabled = true`
3. Configure rules for specific applications
4. Reload Hammerspoon

### Configuring Caffeine Mode

The caffeine menubar icon (☕/💤) allows you to prevent system sleep:

- Click the icon to toggle between active (☕) and inactive (💤)
- When active, the display and system will not go to sleep
- Useful for presentations, long-running tasks, or watching videos

## Requirements

- macOS 10.10 or later (tested on macOS Sequoia 15.1)
- Hammerspoon 0.9.76 or later
- Accessibility permissions for Hammerspoon (required for window management and hotkeys)

## Troubleshooting

### Hotkeys Not Working

- Check Accessibility permissions in System Settings → Privacy & Security → Accessibility
- Verify Hammerspoon is in the list and enabled
- Try reloading the config (click "HS" menubar icon)
- Check Hammerspoon Console (menubar → Console) for errors

### Scroll Not Working

- On MacBooks without dedicated PageUp/PageDown keys, use `Fn+Up` and `Fn+Down`
- Ensure you're holding all Hyper key modifiers (`Ctrl+Alt+Cmd+Shift`)
- Check Hammerspoon Console for any error messages

### App Toggle Not Working

- Ensure the app has a `bundleID` defined in `hyperkey_app_launch.lua`
- Run `hs.application.applicationsForBundleID("bundle.id")` in Console to verify
- Some apps may not support programmatic hiding

### Mouse Movement Feels Wrong

- Adjust `accelerationRate` and `maxSpeed` in `config/settings/mouse.lua`
- Precision mode lasts 0.1s - modify this in `config/mouse.lua` if needed
- Lower `moveInterval` for smoother movement (at cost of CPU)

### Performance Issues

- Reduce scroll update frequency by increasing `scrollInterval`
- Disable window event watcher if not using auto-positioning
- Check Console for excessive logging or errors

## Architecture

This configuration follows a modular architecture with dependency levels:

- **Level 1**: Settings (pure data)
- **Level 2**: Core utilities (`utils`, `visual_feedback`)
- **Level 3**: Feature modules (`window`, `mouse`, `launchers`)
- **Level 4**: Watchers and system integration

See `DEPENDENCY_HIERARCHY.md` (if exists) for detailed dependency graph.

## Contributing

Contributions are welcome! Feel free to:

- Submit issues for bugs or feature requests
- Fork the repository and create pull requests
- Share your custom configurations and improvements

## License

This configuration is open source and available under the MIT License.
