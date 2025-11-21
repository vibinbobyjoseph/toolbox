-- ==============================================
-- Launch Applications hyperKey + key
-- Define the hyper key (ctrl + shift + option + command)
local hyperKey = {"ctrl", "shift", "option", "command"}

-- Define a table of applications and their corresponding keys
-- You can now specify custom paths for apps not in the default Applications directory
-- OR specify URLs to open in specific browsers
local appList = {
	["1"] = {app = "Chrome", path = "/Applications/Microsoft Edge.app"},
	["2"] = {app = "Firefox", path = "/Applications/Firefox.app"},
    ["3"] = {app = "Teams", path = "/Applications/Microsoft Teams.app"},
	["c"] = {app = "Claude", path = "/Applications/Claude.app"},
    ["g"] = {app = "ChatGPT", path = "/Applications/ChatGPT.app"},
	["i"] = {app = "IntelliJ", path = "/Applications/IntelliJ IDEA.app"},
	["n"] = {app = "Notion", path = "/Applications/Notion.app"},
    ["o"] = {app = "Outlook", path = "/Applications/Microsoft Outlook.app"},
	["m"] = {app = "Mail", path = "/System/Applications/Mail.app"},
	["p"] = {app = "1Password", path = "/Applications/1Password.app"},
	["s"] = {app = "Sourcetree", path = "/Applications/Sourcetree.app"},
	["t"] = {app = "TablePlus", path = "/Applications/TablePlus.app"},
	["v"] = {app = "VS Code", path = "/Applications/Visual Studio Code.app"},
	["x"] = {app = "TextMate", path = "/Applications/TextMate.app"},
	["w"] = {app = "WhatsApp", path = "/Applications/WhatsApp.app"},
}

-- Function to launch a URL in a specific browser
local function launchURL(url, browser, key, description)
    local browserBundle = {
        ["Firefox"] = "org.mozilla.firefox",
        ["Chrome"] = "com.google.Chrome",
        ["Safari"] = "com.apple.Safari"
    }

    local bundleID = browserBundle[browser]
    if not bundleID then
        hs.alert.show("Unsupported browser: " .. browser .. " (Key: " .. key .. ")")
        return
    end

    -- Use hs.urlevent.openURLWithBundle to open URL in specific browser
    local success = hs.urlevent.openURLWithBundle(url, bundleID)
    if success then
        hs.alert.show("Opened: " .. (description or url) .. " in " .. browser .. " (Key: " .. key .. ")")
    else
        hs.alert.show("Failed to open URL in " .. browser .. " (Key: " .. key .. ")")
    end
end

-- Function to launch an app by its name or custom path
local function launchApp(appName, key, customPath)
    -- Safety check for appName
    if not appName then
        hs.alert.show("Error: No app name specified (Key: " .. key .. ")")
        return
    end

    local app
    if customPath then
        -- Try to launch the app from the specified custom path
        local success, output, _ = hs.execute('open "' .. customPath .. '"')
        if success then
            -- If the app was launched successfully, no further action needed
            hs.alert.show("Launched: " .. appName .. " (Key: " .. key .. ")")
        else
            -- If the app is not found at the custom path, show an alert
            hs.alert.show("Application not found at path: " .. customPath .. " (Key: " .. key .. ")")
        end
    else
        -- Try to launch the app normally
        app = hs.application.find(appName)
        if app then
            app:activate()
        else
            -- If the app is not running, show an alert
            hs.alert.show("Application not found: " .. appName .. " (Key: " .. key .. ")")
        end
    end
end

-- Enhanced function to handle both apps and URLs
local function handleLaunch(key, itemData)
    if itemData.type == "url" then
        -- Handle URL launch
        launchURL(itemData.url, itemData.browser, key, itemData.description)
    elseif itemData.app then
        -- Handle regular app launch
        launchApp(itemData.app, key, itemData.path)
    else
        -- Handle error case
        hs.alert.show("Invalid configuration for key: " .. key)
    end
end

-- Bind the hotkeys to launch apps/URLs based on the list
for key, itemData in pairs(appList) do
    hs.hotkey.bind(hyperKey, key, function()
        handleLaunch(key, itemData)
    end)
end

-- Catch all key presses with the hyper key and check for unmapped keys
hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local keyPressed = hs.keycodes.map[event:getKeyCode()]

    -- Only handle the case if a hyper key is held down
    if hs.fnutils.contains(hyperKey, keyPressed) == false and appList[keyPressed] == nil then
        -- Show an alert if no mapping is found
        hs.alert.show("No mapping found for key: " .. keyPressed)
    end
end):start()

-- Show a notification when Hammerspoon loads, to let you know the script is active
hs.notify.new({title="Hammerspoon", informativeText="App launcher script is active!"}):send()
