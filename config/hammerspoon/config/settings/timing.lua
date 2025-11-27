-- Timing Configuration
-- Centralized timing constants for all modules

local timing = {}

-- App launcher timings
timing.launcher = {
    cleanupDelay = 2.0,        -- Seconds to wait before clearing launch state
    focusDelay = 0.1,          -- Delay before focusing window
    fullscreenDelay = 0.2,     -- Delay for fullscreen transitions
    debounceWindow = 1.0,      -- Time window for detecting rapid launches
    quickRelaunchDelay = 0.15  -- Fast relaunch delay for slow-window apps
}

-- Mouse click timings
timing.mouse = {
    clickDelay = 0.020,        -- Seconds between mouseDown and mouseUp (20ms)
    doubleClickWindow = 0.5,   -- Time window for double-click detection
    tripleClickWindow = 0.5,   -- Time window for triple-click detection
    clickInterval = 0.050      -- Time between clicks in multi-click (50ms)
}

-- Visual feedback timings
timing.feedback = {
    highlightFadeSteps = 10,   -- Number of fade animation steps
    highlightStepDelay = 0.03, -- Seconds per fade step
    statusFadeDelay = 0.1,     -- Delay before status overlay fades
    statusFadeSteps = 5        -- Number of steps for status fade
}

return timing
