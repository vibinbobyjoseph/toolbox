-- Menubar Status Indicator
local menubarItem = hs.menubar.new()

function updateMenubarStatus(text, duration)
    if menubarItem then
        menubarItem:setTitle(text)

        if duration then
            hs.timer.doAfter(duration, function()
                menubarItem:setTitle("")
            end)
        end
    end
end

-- Set permanent icon
menubarItem:setTitle("HS")
menubarItem:setClickCallback(function()
    hs.reload()
end)

return {
    update = updateMenubarStatus
}
