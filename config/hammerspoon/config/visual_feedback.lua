-- Visual Feedback: Highlights, sounds, and overlays
local feedback = {}

-- Configuration
feedback.config = {
    highlightColor = {red = 0.2, green = 0.6, blue = 1.0, alpha = 0.8},
    highlightDuration = 0.5,
    highlightWidth = 4,
    soundEnabled = true,
    overlayDuration = 1.5
}

-- System sounds
local sounds = {
    success = hs.sound.getByName("Tink"),
    move = hs.sound.getByName("Pop"),
    error = hs.sound.getByName("Basso")
}

-- Window highlight overlay
local highlightCanvas = nil

function feedback.highlightWindow(win, duration)
    if not win then return end

    local frame = win:frame()
    duration = duration or feedback.config.highlightDuration

    if highlightCanvas then
        highlightCanvas:delete()
    end

    highlightCanvas = hs.canvas.new(frame)
    highlightCanvas[1] = {
        type = "rectangle",
        frame = {x = 0, y = 0, w = "100%", h = "100%"},
        strokeColor = feedback.config.highlightColor,
        strokeWidth = feedback.config.highlightWidth,
        action = "stroke",
        roundedRectRadii = {xRadius = 8, yRadius = 8}
    }
    highlightCanvas:show(0.2)

    hs.timer.doAfter(duration, function()
        if highlightCanvas then
            highlightCanvas:hide(0.2)
            hs.timer.doAfter(0.3, function()
                if highlightCanvas then
                    highlightCanvas:delete()
                    highlightCanvas = nil
                end
            end)
        end
    end)
end

-- Status overlay (replaces hs.alert for less intrusion)
local statusOverlay = nil

function feedback.showStatus(message, duration)
    local screen = hs.screen.mainScreen():frame()
    local width = 400
    local height = 80
    duration = duration or feedback.config.overlayDuration

    if statusOverlay then
        statusOverlay:delete()
    end

    statusOverlay = hs.canvas.new({
        x = (screen.w - width) / 2,
        y = screen.h - 150,
        w = width,
        h = height
    })

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

    hs.timer.doAfter(duration, function()
        if statusOverlay then
            statusOverlay:hide(0.2)
            hs.timer.doAfter(0.3, function()
                if statusOverlay then
                    statusOverlay:delete()
                    statusOverlay = nil
                end
            end)
        end
    end)
end

-- Play sound feedback
function feedback.playSound(soundType)
    if not feedback.config.soundEnabled then return end

    if sounds[soundType] then
        sounds[soundType]:play()
    end
end

return feedback
