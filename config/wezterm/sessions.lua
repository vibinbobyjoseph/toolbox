local wezterm = require 'wezterm'

local M = {}

-- ========================================
-- SESSION DEFINITIONS
-- ========================================
-- Define your workspace sessions here
-- Each session can have:
--   - name: Display name for the session
--   - cwd: Working directory for all tabs (can be overridden per tab)
--   - tabs: Array of tab configurations
--     - title: Tab title (optional)
--     - cwd: Working directory for this tab (optional, overrides session cwd)
--     - panes: Array of pane configurations (can be strings or tables)
--       String format: Just the command to run
--       Table format: { command = "cmd", cwd = "/path", split = "horizontal"|"vertical" }

M.sessions = {

  -- System Monitor: Docker services + network monitoring
  system_monitor = {
    name = "System Monitor",
    cwd = wezterm.home_dir,
    tabs = {
      {
        title = "Monitor",
        panes = {
          -- Pane 1 (top-left): LocalStack and ActiveMQ
          "docker run -d --rm -p 4566:4566 localstack/localstack:latest && docker run -d --rm -p 61616:61616 -p 8162:8161 symptoma/activemq:latest",

          -- Pane 2 (bottom-full): Docker stats - split DOWN from pane 1 first
          {
            command = "docker stats",
            split = "horizontal",
            split_from = 1
          },

          -- Pane 3 (top-right): Network connectivity monitor - split RIGHT from pane 1
          {
            command = [[while :; do
  if ping -c1 -W1 1.1.1.1 >/dev/null 2>&1 || ping -c1 -W1 8.8.8.8 >/dev/null 2>&1; then
    printf '%s  OK\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  else
    printf '%s  DOWN\n' "$(date '+%Y-%m-%d %H:%M:%S')"
    osascript -e 'display notification "Internet appears DOWN" with title "Connectivity Watch"'
    afplay /System/Library/Sounds/Basso.aiff
    say "Internet connection lost"
  fi
  sleep 5
done]],
            split = "vertical",
            split_from = 1
          },
        }
      },
      {
        title = "Shell",
        panes = {
          "echo 'Ready for commands'",
        }
      },
    }
  },

  -- Investrack project workspace
  investrack = {
    name = "Investrack",
    tabs = {
      {
        title = "Workspace",
        panes = {
          -- Pane 1 (Top-Left): investrack root (runs ll -a)
          {
            command = "ll -a",
            cwd = "/Users/vibin.joseph/Code/jcl/investrack"
          },

          -- Pane 2 (Top-Right): UI directory - split RIGHT from pane 1
          {
            command = "",
            cwd = "/Users/vibin.joseph/Code/jcl/investrack/ui/investrack-ui",
            split = "vertical",
            split_from = 1
          },

          -- Pane 3 (Bottom-Left): investrack root - split DOWN from pane 1
          {
            command = "",
            cwd = "/Users/vibin.joseph/Code/jcl/investrack",
            split = "horizontal",
            split_from = 1
          },

          -- Pane 4 (Bottom-Right): API directory - split DOWN from pane 2
          {
            command = "",
            cwd = "/Users/vibin.joseph/Code/jcl/investrack/api",
            split = "horizontal",
            split_from = 2
          },
        }
      },
    }
  },

  -- Elevate Dev: Billing components workspace
  elevate_dev = {
    name = "Elevate Dev",
    tabs = {
      {
        title = "Billing",
        cwd = "/Users/vibin.joseph/Code/si/elevate/billing",
        panes = { "" }
      },
      {
        title = "Billing UI",
        cwd = "/Users/vibin.joseph/Code/si/elevate/billing/billing-ui",
        panes = { "" }
      },
      {
        title = "Billing WS",
        cwd = "/Users/vibin.joseph/Code/si/elevate/billing/billing-ws",
        panes = { "" }
      },
      {
        title = "Auth",
        cwd = "/Users/vibin.joseph/Code/si/elevate/billing-rest-authentication",
        panes = { "" }
      },
    }
  },

}

-- ========================================
-- CORE SESSION FUNCTIONS
-- ========================================

-- Create a new window with the session layout
function M.create_session_window(session_key)
  local session = M.sessions[session_key]
  if not session then
    wezterm.log_error("Session not found: " .. session_key)
    return
  end

  local mux = wezterm.mux
  local base_cwd = session.cwd or wezterm.home_dir

  -- Configure the first tab
  if session.tabs and #session.tabs > 0 then
    local first_tab = session.tabs[1]
    local first_tab_cwd = first_tab.cwd or base_cwd

    -- Create the first tab with the correct directory
    local tab, pane, window = mux.spawn_window({ cwd = first_tab_cwd })
    local first_pane = pane  -- Save reference to first tab's pane

    if first_tab.title then
      tab:set_title(first_tab.title)
    end

    M.create_panes(tab, first_tab, base_cwd)

    -- Create remaining tabs
    for i = 2, #session.tabs do
      local tab_config = session.tabs[i]
      local tab_cwd = tab_config.cwd or base_cwd

      tab, pane, window = window:spawn_tab({ cwd = tab_cwd })

      if tab_config.title then
        tab:set_title(tab_config.title)
      end

      M.create_panes(tab, tab_config, base_cwd)
    end

    -- Activate the first tab
    window:gui_window():perform_action(wezterm.action.ActivateTab(0), first_pane)
  end
end

-- Create panes within a tab
function M.create_panes(tab, tab_config, base_cwd)
  if not tab_config.panes or #tab_config.panes == 0 then
    return
  end

  local panes = tab_config.panes
  local tab_cwd = tab_config.cwd or base_cwd
  local pane_list = {}

  -- First pane is the initial tab pane
  pane_list[1] = tab:active_pane()

  -- Get the cwd for the first pane
  local first_pane_cwd = nil
  if type(panes[1]) == "table" and panes[1].cwd then
    first_pane_cwd = panes[1].cwd
  end

  M.send_command_to_pane(pane_list[1], panes[1], first_pane_cwd)

  -- Create additional panes
  for i = 2, #panes do
    local pane_config = panes[i]
    local command, split_direction, pane_cwd, split_from = M.parse_pane_config(pane_config, tab_cwd)

    if command ~= nil then
      -- Determine which pane to split from
      local source_pane_index = split_from or (i - 1)
      local source_pane = pane_list[source_pane_index] or pane_list[#pane_list]

      -- Split the pane (horizontal = left/right, vertical = top/bottom)
      local direction = split_direction == "vertical" and "Right" or "Bottom"
      local new_pane = source_pane:split({
        direction = direction,
        cwd = pane_cwd,
      })

      M.send_command_to_pane(new_pane, command, pane_cwd)
      pane_list[i] = new_pane
    end
  end
end

-- Parse pane configuration (string or table)
function M.parse_pane_config(pane_config, default_cwd)
  if type(pane_config) == "string" then
    return pane_config, "horizontal", default_cwd, nil
  elseif type(pane_config) == "table" then
    return pane_config.command or "",
           pane_config.split or "horizontal",
           pane_config.cwd or default_cwd,
           pane_config.split_from
  end
  return nil, nil, nil, nil
end

-- Send command to a pane
function M.send_command_to_pane(pane, config, pane_cwd)
  local command = type(config) == "string" and config or (config.command or "")

  -- If a cwd is specified and there's a command, cd first then run the command
  if pane_cwd and command ~= "" then
    pane:send_text("cd " .. wezterm.shell_quote_arg(pane_cwd) .. " && " .. command .. "\n")
  elseif command ~= "" then
    pane:send_text(command .. "\n")
  end
end

-- ========================================
-- SESSION LAUNCHER UI
-- ========================================

-- Create the session launcher action (for key binding)
function M.create_launcher_action()
  return wezterm.action_callback(function(window, pane)
    local choices = {}

    -- Build choices from sessions
    for key, session in pairs(M.sessions) do
      table.insert(choices, {
        id = key,
        label = session.name or key,
      })
    end

    -- Sort alphabetically by label
    table.sort(choices, function(a, b)
      return a.label < b.label
    end)

    -- Show input selector
    window:perform_action(
      wezterm.action.InputSelector({
        action = wezterm.action_callback(function(window, pane, id, label)
          if id then
            M.create_session_window(id)
          end
        end),
        title = 'Launch Session',
        choices = choices,
        fuzzy = true,
      }),
      pane
    )
  end)
end

return M
