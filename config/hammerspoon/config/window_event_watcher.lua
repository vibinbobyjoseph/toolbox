-- Window Event Watcher
-- Watches for window creation events and applies smart positioning rules
-- This is an OPTIONAL feature - controlled by window_rules.enabled

local windowEventWatcher = {}
local logger = hs.logger.new('window_event_watcher', 'info')

-- Load window rules
local windowRules = require('config.window_rules')

-- Track recently positioned windows to avoid repositioning loops
local recentlyPositioned = {}
local POSITION_COOLDOWN = 2.0  -- Seconds before allowing re-positioning

-- Window filter for watching window events
local windowFilter = nil

-- Clean up old entries from recentlyPositioned
local function cleanupPositionTracking()
    local now = hs.timer.secondsSinceEpoch()
    for winId, timestamp in pairs(recentlyPositioned) do
        if now - timestamp > POSITION_COOLDOWN then
            recentlyPositioned[winId] = nil
        end
    end
end

-- Handle window created event
local function onWindowCreated(win, appName, event)
    if not windowRules.isEnabled() then
        return
    end

    if not win or not win:isStandard() then
        return
    end

    local winId = win:id()

    -- Check if we recently positioned this window
    if recentlyPositioned[winId] then
        local timeSincePosition = hs.timer.secondsSinceEpoch() - recentlyPositioned[winId]
        if timeSincePosition < POSITION_COOLDOWN then
            logger:d("Window " .. winId .. " recently positioned, skipping")
            return
        end
    end

    -- Clean up old tracking entries
    cleanupPositionTracking()

    -- Small delay to let window fully initialize
    hs.timer.doAfter(0.1, function()
        -- Verify window still exists
        if not win or not win:isValid() then
            return
        end

        -- Apply positioning rule
        local applied = windowRules.applyRule(win)
        if applied then
            logger:i("Applied positioning rule to: " .. appName .. " (window " .. winId .. ")")
            recentlyPositioned[winId] = hs.timer.secondsSinceEpoch()
        end
    end)
end

-- Handle window focused event (optional, for delayed positioning)
local function onWindowFocused(win, appName, event)
    if not windowRules.isEnabled() then
        return
    end

    if not win or not win:isStandard() then
        return
    end

    -- You can add additional logic here for windows that need
    -- positioning only when they gain focus (not on creation)
end

-- Start watching window events
function windowEventWatcher.start()
    if windowFilter then
        logger:w("Window event watcher already started")
        return
    end

    -- Create window filter that watches all windows
    windowFilter = hs.window.filter.new(true)
        :setDefaultFilter{}  -- Watch all windows

    -- Subscribe to window created event
    windowFilter:subscribe(hs.window.filter.windowCreated, onWindowCreated)

    -- Optionally subscribe to other events
    -- windowFilter:subscribe(hs.window.filter.windowFocused, onWindowFocused)

    if windowRules.isEnabled() then
        logger:i("Window event watcher started (rules enabled)")
    else
        logger:i("Window event watcher started (rules disabled - no auto-positioning will occur)")
    end
end

-- Stop watching window events
function windowEventWatcher.stop()
    if windowFilter then
        windowFilter:unsubscribeAll()
        windowFilter = nil
        logger:i("Window event watcher stopped")
    end
end

-- Cleanup function
function windowEventWatcher.cleanup()
    windowEventWatcher.stop()
    recentlyPositioned = {}
end

-- Auto-start the watcher when module is loaded
windowEventWatcher.start()

return windowEventWatcher
