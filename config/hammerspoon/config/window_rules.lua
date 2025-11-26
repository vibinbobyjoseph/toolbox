-- Window Positioning Rules
-- Define smart positioning rules for automatically managing windows when they launch
-- This is an OPTIONAL feature - disabled by default

local windowRules = {}

-- Enable/disable automatic window positioning
windowRules.enabled = false  -- Set to true to enable auto-positioning

-- Window positioning rules by application
-- Each rule can specify:
--   - position: "maximize", "left", "right", "center", "top-left", "top-right", "bottom-left", "bottom-right"
--   - screen: screen number (1 = primary, 2 = secondary, etc.) or "main", "primary"
--   - size: {w = 0.5, h = 1.0} (percentage of screen dimensions)
--   - callback: custom function(win) to handle positioning
windowRules.rules = {
    -- Example: Terminal always on left half
    ["Terminal"] = {
        position = "left",
        screen = "main"
    },

    -- Example: Browser maximized on main screen
    ["Google Chrome"] = {
        position = "maximize",
        screen = "main"
    },

    -- Example: Slack on right side of secondary screen
    ["Slack"] = {
        position = "right",
        screen = 2  -- Second screen
    },

    -- Example: Custom positioning with callback
    ["Custom App"] = {
        callback = function(win)
            -- Custom logic here
            local screen = hs.screen.mainScreen()
            local frame = screen:frame()
            win:setFrame({
                x = frame.x + 100,
                y = frame.y + 100,
                w = frame.w - 200,
                h = frame.h - 200
            })
        end
    }
}

--- Apply positioning to a window based on its application name
--- @param win window The window to position
--- @return boolean True if a rule was applied
function windowRules.applyRule(win)
    if not windowRules.enabled then
        return false
    end

    if not win or not win:isStandard() then
        return false
    end

    local app = win:application()
    if not app then
        return false
    end

    local appName = app:name()
    local rule = windowRules.rules[appName]

    if not rule then
        return false
    end

    -- Handle custom callback
    if rule.callback then
        rule.callback(win)
        return true
    end

    -- Get target screen
    local targetScreen
    if rule.screen == "main" or rule.screen == "primary" or not rule.screen then
        targetScreen = hs.screen.mainScreen()
    elseif type(rule.screen) == "number" then
        local screens = hs.screen.allScreens()
        targetScreen = screens[rule.screen] or hs.screen.mainScreen()
    else
        targetScreen = hs.screen.mainScreen()
    end

    local screenFrame = targetScreen:frame()
    local newFrame = {}

    -- Apply position
    if rule.position == "maximize" then
        newFrame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w,
            h = screenFrame.h
        }
    elseif rule.position == "left" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 1.0
        newFrame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "right" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 1.0
        newFrame = {
            x = screenFrame.x + screenFrame.w * (1 - width),
            y = screenFrame.y,
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "center" then
        local width = rule.size and rule.size.w or 0.6
        local height = rule.size and rule.size.h or 0.7
        newFrame = {
            x = screenFrame.x + (screenFrame.w - screenFrame.w * width) / 2,
            y = screenFrame.y + (screenFrame.h - screenFrame.h * height) / 2,
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "top-left" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 0.5
        newFrame = {
            x = screenFrame.x,
            y = screenFrame.y,
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "top-right" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 0.5
        newFrame = {
            x = screenFrame.x + screenFrame.w * (1 - width),
            y = screenFrame.y,
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "bottom-left" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 0.5
        newFrame = {
            x = screenFrame.x,
            y = screenFrame.y + screenFrame.h * (1 - height),
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    elseif rule.position == "bottom-right" then
        local width = rule.size and rule.size.w or 0.5
        local height = rule.size and rule.size.h or 0.5
        newFrame = {
            x = screenFrame.x + screenFrame.w * (1 - width),
            y = screenFrame.y + screenFrame.h * (1 - height),
            w = screenFrame.w * width,
            h = screenFrame.h * height
        }
    else
        -- Unknown position, skip
        return false
    end

    -- Apply the new frame
    win:setFrame(newFrame)
    return true
end

--- Check if rules are enabled
--- @return boolean True if window rules are active
function windowRules.isEnabled()
    return windowRules.enabled
end

--- Enable window rules
function windowRules.enable()
    windowRules.enabled = true
end

--- Disable window rules
function windowRules.disable()
    windowRules.enabled = false
end

return windowRules
