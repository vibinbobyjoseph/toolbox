-- Screen Configuration Watcher
-- Handles monitor add/remove/rearrange events

local screenWatcher = {}
local logger = hs.logger.new('screen_watcher', 'info')

-- Callback function when screens change
local function onScreensChanged()
    logger:i("Screen configuration changed")

    -- Find and reposition any off-screen windows
    local repositionedCount = 0
    for _, win in ipairs(hs.window.allWindows()) do
        if win:isStandard() then
            local screen = win:screen()

            -- If window has no screen, it's off-screen
            if not screen then
                -- Move to main screen
                local mainScreen = hs.screen.mainScreen()
                if mainScreen then
                    win:moveToScreen(mainScreen)
                    repositionedCount = repositionedCount + 1
                    logger:d("Repositioned off-screen window: " .. (win:title() or "unknown"))
                end
            else
                -- Check if window is partially off-screen
                local winFrame = win:frame()
                local screenFrame = screen:frame()

                -- If window extends beyond screen bounds, constrain it
                local needsReposition = false
                if winFrame.x + winFrame.w > screenFrame.x + screenFrame.w then
                    winFrame.x = screenFrame.x + screenFrame.w - winFrame.w
                    needsReposition = true
                end
                if winFrame.y + winFrame.h > screenFrame.y + screenFrame.h then
                    winFrame.y = screenFrame.y + screenFrame.h - winFrame.h
                    needsReposition = true
                end
                if winFrame.x < screenFrame.x then
                    winFrame.x = screenFrame.x
                    needsReposition = true
                end
                if winFrame.y < screenFrame.y then
                    winFrame.y = screenFrame.y
                    needsReposition = true
                end

                if needsReposition then
                    win:setFrame(winFrame)
                    repositionedCount = repositionedCount + 1
                end
            end
        end
    end

    if repositionedCount > 0 then
        logger:i("Repositioned " .. repositionedCount .. " windows")
    end
end

-- Start watching for screen changes
local watcher = hs.screen.watcher.new(onScreensChanged)
watcher:start()

-- Cleanup function
function screenWatcher.cleanup()
    if watcher then
        watcher:stop()
        watcher = nil
    end
end

return screenWatcher
