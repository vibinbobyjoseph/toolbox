-- Visual Feedback Configuration
-- Centralized settings for window highlights, status overlays, and sounds

local visual = {}

-- Window highlight settings
visual.highlight = {
    color = {red = 0.2, green = 0.6, blue = 1.0, alpha = 0.8},
    duration = 0.5,
    width = 4,
    borderRadius = 8
}

-- Status overlay settings
visual.overlay = {
    duration = 1.5,
    width = 400,
    height = 80,
    position = 150, -- pixels from bottom
    backgroundColor = {alpha = 0.85},
    textColor = {white = 1.0},
    textSize = 18,
    borderRadius = 10
}

-- Sound settings
visual.sound = {
    enabled = true,
    -- Available sounds: "Tink", "Pop", "Basso", "Blow", "Bottle", "Frog", "Funk", "Glass", "Hero", "Morse", "Ping", "Purr", "Sosumi", "Submarine"
    success = "Tink",
    move = "Pop",
    error = "Basso"
}

return visual
