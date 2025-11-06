-- ==============================================
-- Resize a window
-- Define the hyper-key
local hyperWR = {"ctrl", "alt"}

-- Move window to the left half of the screen
hs.hotkey.bind(hyperWR, "left", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
    else
        hs.alert.show("No focused window")
    end
end)

-- Move window to the right half of the screen
hs.hotkey.bind(hyperWR, "right", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x + screen.w / 2,
            y = screen.y,
            w = screen.w / 2,
            h = screen.h
        })
    else
        hs.alert.show("No focused window")
    end
end)

-- Move window to the top half of the screen
hs.hotkey.bind(hyperWR, "up", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y,
            w = screen.w,
            h = screen.h / 2
        })
    else
        hs.alert.show("No focused window")
    end
end)

-- Move window to the bottom half of the screen
hs.hotkey.bind(hyperWR, "down", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame({
            x = screen.x,
            y = screen.y + screen.h / 2,
            w = screen.w,
            h = screen.h / 2
        })
    else
        hs.alert.show("No focused window")
    end
end)

-- Make the window full screen
hs.hotkey.bind(hyperWR, "return", function()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen():frame()
        win:setFrame(screen)
    else
        hs.alert.show("No focused window")
    end
end)

-- ==============================================