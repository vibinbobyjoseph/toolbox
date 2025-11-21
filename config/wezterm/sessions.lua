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
  -- Example: Network investigation workspace
  network = {
    name = "Network Investigation",
    cwd = wezterm.home_dir .. "/Code/network",
    tabs = {
      {
        title = "Logs",
        panes = {
          "tail -f /var/log/network.log",
          { command = "tail -f /var/log/service.log", split = "horizontal" },
        }
      },
      {
        title = "Debug",
        panes = {
          "echo 'Ready for debugging'",
        }
      },
      {
        title = "SSH",
        panes = {
          "echo 'ssh server1'",
          { command = "echo 'ssh server2'", split = "vertical" },
        }
      },
    }
  },

  -- Example: Docker services
  docker = {
    name = "Docker Services",
    cwd = wezterm.home_dir,
    tabs = {
      {
        title = "LocalStack",
        panes = {
          "echo 'Start LocalStack: docker-compose up localstack'",
        }
      },
      {
        title = "ActiveMQ",
        panes = {
          "echo 'Start ActiveMQ: docker-compose up activemq'",
        }
      },
      {
        title = "Monitoring",
        panes = {
          "docker ps",
          { command = "docker stats", split = "horizontal" },
        }
      },
    }
  },

  -- Example: Investrack project
  investrack = {
    name = "Investrack",
    cwd = wezterm.home_dir .. "/Code/investrack",
    tabs = {
      {
        title = "Backend",
        panes = {
          "echo 'Run: mvn spring-boot:run'",
        }
      },
      {
        title = "Frontend",
        panes = {
          "echo 'Run: npm run dev'",
        }
      },
      {
        title = "Git",
        panes = {
          "git status",
        }
      },
      {
        title = "Logs",
        panes = {
          "tail -f logs/app.log",
          { command = "tail -f logs/error.log", split = "horizontal" },
        }
      },
    }
  },

  -- Example: Elevate project
  elevate = {
    name = "Elevate",
    cwd = wezterm.home_dir .. "/Code/elevate",
    tabs = {
      {
        title = "Development",
        panes = {
          "echo 'Dev environment'",
        }
      },
      {
        title = "Investigation",
        panes = {
          "git log --oneline -10",
        }
      },
    }
  },

  -- Example: Elevate INT deployment
  elevate_int = {
    name = "Elevate INT",
    cwd = wezterm.home_dir .. "/Code/elevate",
    tabs = {
      {
        title = "Deploy",
        panes = {
          "echo 'Ready for INT deployment'",
        }
      },
      {
        title = "Logs",
        panes = {
          "echo 'kubectl logs -f pod-name'",
        }
      },
      {
        title = "Monitor",
        panes = {
          "echo 'kubectl get pods -w'",
          { command = "echo 'kubectl top pods'", split = "horizontal" },
        }
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

  -- Create the first tab
  local tab, pane, window = mux.spawn_window({ cwd = base_cwd })

  -- Configure the first tab
  if session.tabs and #session.tabs > 0 then
    local first_tab = session.tabs[1]
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
  end

  -- Activate the first tab
  window:gui_window():perform_action(wezterm.action.ActivateTab(0), pane)
end

-- Create panes within a tab
function M.create_panes(tab, tab_config, base_cwd)
  if not tab_config.panes or #tab_config.panes == 0 then
    return
  end

  local panes = tab_config.panes
  local tab_cwd = tab_config.cwd or base_cwd
  local current_pane = tab:active_pane()

  -- Send command to the first pane
  M.send_command_to_pane(current_pane, panes[1])

  -- Create and configure additional panes
  for i = 2, #panes do
    local pane_config = panes[i]
    local command, split_direction, pane_cwd = M.parse_pane_config(pane_config, tab_cwd)

    if command then
      -- Split the pane (horizontal = left/right, vertical = top/bottom)
      local direction = split_direction == "vertical" and "Right" or "Bottom"
      local new_pane = current_pane:split({
        direction = direction,
        cwd = pane_cwd,
      })

      M.send_command_to_pane(new_pane, command)
      current_pane = new_pane
    end
  end
end

-- Parse pane configuration (string or table)
function M.parse_pane_config(pane_config, default_cwd)
  if type(pane_config) == "string" then
    return pane_config, "horizontal", default_cwd
  elseif type(pane_config) == "table" then
    return pane_config.command,
           pane_config.split or "horizontal",
           pane_config.cwd or default_cwd
  end
  return nil, nil, nil
end

-- Send command to a pane
function M.send_command_to_pane(pane, config)
  local command = type(config) == "string" and config or (config.command or "")
  if command ~= "" then
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
