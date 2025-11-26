-- Visual Feedback: Highlights, sounds, and overlays
--
-- DEPENDENCY LEVEL: 3 (Core Utilities)
-- Dependencies: Level 2 (config.settings.init)
-- Required by: Level 4+ (feature modules)
--
-- IMPORTANT: This module MUST NOT require:
-- - config.utils (same level, would cause coupling)
-- - Any feature modules (Level 4+)
-- See DEPENDENCY_HIERARCHY.md for details.

local feedback = {}

-- Load centralized settings
local settings = require('config.settings.init')
local visualConfig = settings.visual

-- Track active canvases for cleanup
local activeCanvases = {
    highlight = nil,
    status = nil
}

-- Track active timers for cleanup (Issue #11.2)
local activeTimers = {
    highlight = {},  -- Array of timers for highlight fade animations
    status = {}      -- Array of timers for status overlay animations
}

-- Add canvas pool for reuse
local canvasPool = {
    highlight = {},
    status = {}
}

-- Helper: Get canvas from pool or create new one
local function getCanvas(type, frame)
    local pool = canvasPool[type]
    local canvas = nil

    -- Try to reuse from pool
    if #pool > 0 then
        canvas = table.remove(pool)
        canvas:frame(frame)
        canvas:show()
    else
        -- Create new if pool is empty
        canvas = hs.canvas.new(frame)
    end

    return canvas
end

-- Helper: Return canvas to pool
local function returnCanvas(type, canvas)
    if not canvas then return end

    canvas:hide()
    canvas:delete()  -- Still delete for now to avoid complexity
    -- In future, could keep in pool: table.insert(canvasPool[type], canvas)
end

-- System sounds (using centralized config)
local sounds = {
    success = hs.sound.getByName(visualConfig.sound.success),
    move = hs.sound.getByName(visualConfig.sound.move),
    error = hs.sound.getByName(visualConfig.sound.error)
}

-- Window highlight overlay
local highlightCanvas = nil

--- Highlight a window with animated border
--- @param win window The window to highlight
--- @param duration number|nil Duration in seconds (default from settings)
--- @return boolean|nil True on success, nil on failure
--- @return string|nil Error message if failed
function feedback.highlightWindow(win, duration)
    if not win then
        return nil, "Window required"
    end

    -- Clean up previous highlight if it exists
    if activeCanvases.highlight then
        activeCanvases.highlight:delete()
        activeCanvases.highlight = nil
    end

    local frame = win:frame()
    duration = duration or visualConfig.highlight.duration

    if highlightCanvas then
        highlightCanvas:delete()
    end

    highlightCanvas = hs.canvas.new(frame)
    activeCanvases.highlight = highlightCanvas
    highlightCanvas[1] = {
        type = "rectangle",
        frame = {x = 0, y = 0, w = "100%", h = "100%"},
        strokeColor = visualConfig.highlight.color,
        strokeWidth = visualConfig.highlight.width,
        action = "stroke",
        roundedRectRadii = {xRadius = 8, yRadius = 8}
    }
    highlightCanvas:show(0.2)

    -- Track timers for cleanup (Issue #11.2)
    local timer1 = hs.timer.doAfter(duration, function()
        if highlightCanvas then
            highlightCanvas:hide(0.2)
            local timer2 = hs.timer.doAfter(0.3, function()
                if highlightCanvas then
                    highlightCanvas:delete()
                    highlightCanvas = nil
                end
                if activeCanvases.highlight == highlightCanvas then
                    activeCanvases.highlight = nil
                end
                -- Remove timer2 from tracking
                for i, t in ipairs(activeTimers.highlight) do
                    if t == timer2 then
                        table.remove(activeTimers.highlight, i)
                        break
                    end
                end
            end)
            table.insert(activeTimers.highlight, timer2)
        end
        -- Remove timer1 from tracking
        for i, t in ipairs(activeTimers.highlight) do
            if t == timer1 then
                table.remove(activeTimers.highlight, i)
                break
            end
        end
    end)
    table.insert(activeTimers.highlight, timer1)

    return true, nil
end

-- Status overlay (replaces hs.alert for less intrusion)
local statusOverlay = nil

--- Show a status message overlay on screen
--- Displays centered text that fades after a short time
--- @param message string The message to display
--- @param duration number|nil Display duration in seconds
--- @return boolean|nil True on success, nil on failure
--- @return string|nil Error message if failed
function feedback.showStatus(message, duration)
    -- Validate input
    if not message or message == "" then
        return false, "No message provided"
    end

    -- Clean up previous status if it exists
    if activeCanvases.status then
        activeCanvases.status:delete()
        activeCanvases.status = nil
    end

    local screen = hs.screen.mainScreen():frame()
    local width = 400
    local height = 80
    duration = duration or visualConfig.overlay.duration

    if statusOverlay then
        statusOverlay:delete()
    end

    statusOverlay = hs.canvas.new({
        x = (screen.w - width) / 2,
        y = screen.h - 150,
        w = width,
        h = height
    })
    activeCanvases.status = statusOverlay

    statusOverlay[1] = {
        type = "rectangle",
        action = "fill",
        fillColor = {alpha = 0.85},
        roundedRectRadii = {xRadius = 10, yRadius = 10}
    }

    statusOverlay[2] = {
        type = "text",
        text = message,
        textColor = {white = 1.0},
        textSize = 18,
        textAlignment = "center",
        frame = {x = "10%", y = "25%", w = "80%", h = "50%"}
    }

    statusOverlay:show(0.2)

    -- Track timers for cleanup (Issue #11.2)
    local timer1 = hs.timer.doAfter(duration, function()
        if statusOverlay then
            statusOverlay:hide(0.2)
            local timer2 = hs.timer.doAfter(0.3, function()
                if statusOverlay then
                    statusOverlay:delete()
                    statusOverlay = nil
                end
                if activeCanvases.status == statusOverlay then
                    activeCanvases.status = nil
                end
                -- Remove timer2 from tracking
                for i, t in ipairs(activeTimers.status) do
                    if t == timer2 then
                        table.remove(activeTimers.status, i)
                        break
                    end
                end
            end)
            table.insert(activeTimers.status, timer2)
        end
        -- Remove timer1 from tracking
        for i, t in ipairs(activeTimers.status) do
            if t == timer1 then
                table.remove(activeTimers.status, i)
                break
            end
        end
    end)
    table.insert(activeTimers.status, timer1)

    return true, nil
end

-- Play sound feedback
function feedback.playSound(soundType)
    -- Validate sound is enabled
    if not visualConfig.sound.enabled then
        return false, "Sound feedback disabled"
    end

    -- Validate sound type exists
    if not sounds[soundType] then
        return false, "Unknown sound type: " .. tostring(soundType)
    end

    sounds[soundType]:play()
    return true, nil
end

-- Cleanup function for module reload
function feedback.cleanup()
    -- Stop all active timers (Issue #11.2)
    for _, timer in ipairs(activeTimers.highlight) do
        if timer then
            timer:stop()
        end
    end
    activeTimers.highlight = {}

    for _, timer in ipairs(activeTimers.status) do
        if timer then
            timer:stop()
        end
    end
    activeTimers.status = {}

    -- Clean up canvases
    if activeCanvases.highlight then
        activeCanvases.highlight:delete()
        activeCanvases.highlight = nil
    end
    if activeCanvases.status then
        activeCanvases.status:delete()
        activeCanvases.status = nil
    end
end

return feedback
