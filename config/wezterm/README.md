# Wezterm Session Manager

A modular session management system for Wezterm that lets you define and launch predefined window/tab/pane layouts.

## Quick Start

**Launch a session:** Press `Cmd+Shift+S`

This opens a fuzzy-searchable menu with all your defined sessions.

## Defining Sessions

Edit [sessions.lua](sessions.lua) and add your sessions to the `M.sessions` table:

```lua
M.sessions = {
  my_project = {
    name = "My Project",
    cwd = wezterm.home_dir .. "/Code/my-project",
    tabs = {
      {
        title = "Editor",
        panes = {
          "nvim .",
        }
      },
      {
        title = "Server",
        panes = {
          "npm run dev",
          { command = "npm run test:watch", split = "horizontal" },
        }
      },
    }
  },
}
```

## Session Configuration

### Session Structure

```lua
session_key = {
  name = "Display Name",           -- Shown in launcher menu
  cwd = "/default/directory",      -- Base directory for all tabs
  tabs = {                         -- Array of tab configs
    {
      title = "Tab Title",         -- Optional
      cwd = "/tab/directory",      -- Optional, overrides session cwd
      panes = {                    -- Array of pane configs
        "command",                 -- Simple string
        {                          -- Or table with options
          command = "command",
          split = "horizontal",    -- "horizontal" (left/right) or "vertical" (top/bottom)
          cwd = "/pane/directory"  -- Optional, overrides tab cwd
        }
      }
    }
  }
}
```

### Pane Splitting

- **First pane** - Uses the initial tab pane
- **Additional panes** - Split from the previous pane
- **`split = "horizontal"`** - Splits left/right (default)
- **`split = "vertical"`** - Splits top/bottom

### Example: 3-Pane Layout

```lua
panes = {
  "echo 'Top'",                                    -- Initial pane (top)
  { command = "echo 'Bottom Left'", split = "vertical" },   -- Splits top → bottom
  { command = "echo 'Bottom Right'", split = "horizontal" } -- Splits bottom-left → right
}
```

Result:
```
┌──────────────┐
│     Top      │
├──────┬───────┤
│ Left │ Right │
└──────┴───────┘
```

## Key Bindings

| Key                | Action                    |
|--------------------|---------------------------|
| `Cmd+Shift+S`      | Open session launcher     |

## File Structure

- [wezterm.lua](wezterm.lua) - Main Wezterm config
- [sessions.lua](sessions.lua) - Session definitions and launcher
- Both files are symlinked to `~/.config/wezterm/`

## Tips

1. **Use `echo` for testing** - Start with echo commands to test your layout before adding real commands
2. **Working directories** - Set `cwd` at session, tab, or pane level for flexibility
3. **Alphabetical sorting** - Sessions appear alphabetically in the launcher
4. **Keep it simple** - Start with basic layouts and add complexity as needed

## Extending

To add direct hotkey access to a specific session, edit [wezterm.lua](wezterm.lua):

```lua
config.keys = {
  -- ... existing keys ...
  {
    key = '1',
    mods = 'CMD|SHIFT|OPT',
    action = wezterm.action_callback(function(window, pane)
      sessions.create_session_window('my_project')
    end),
  },
}
```
