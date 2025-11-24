-- ==============================================
-- Launch Applications hyperKey + key
-- Define the hyper key (ctrl + shift + option + command)
local hyperKey = {"ctrl", "shift", "option", "command"}

-- Define a table of applications and their corresponding keys
-- You can now specify custom paths for apps not in the default Applications directory
-- OR specify URLs to open in specific browsers
-- Optional: Add bundleID for toggle functionality
local appList = {
    ["f4"] = {app = "WezTerm", path = "/Applications/WezTerm.app", bundleID = "com.github.wez.wezterm"},
	["1"] = {app = "Edge", path = "/Applications/Microsoft Edge.app", bundleID = "com.microsoft.edgemac"},
	["2"] = {app = "Firefox", path = "/Applications/Firefox.app", bundleID = "org.mozilla.firefox"},
    ["3"] = {app = "Teams", path = "/Applications/Microsoft Teams.app", bundleID = "com.microsoft.teams2"},
	["c"] = {app = "Claude", path = "/Applications/Claude.app", bundleID = "com.anthropic.claude"},
    ["g"] = {app = "ChatGPT", path = "/Applications/ChatGPT.app", bundleID = "com.openai.chat"},
	["i"] = {app = "IntelliJ", path = "/Applications/IntelliJ IDEA.app", bundleID = "com.jetbrains.intellij"},
	["n"] = {app = "Notion", path = "/Applications/Notion.app", bundleID = "notion.id"},
    ["o"] = {app = "Outlook", path = "/Applications/Microsoft Outlook.app", bundleID = "com.microsoft.Outlook"},
	["m"] = {app = "Mail", path = "/System/Applications/Mail.app", bundleID = "com.apple.mail"},
	["p"] = {app = "1Password", path = "/Applications/1Password.app", bundleID = "com.1password.1password"},
	["s"] = {app = "Sourcetree", path = "/Applications/Sourcetree.app", bundleID = "com.torusknot.SourceTreeNotMAS"},
	["t"] = {app = "TablePlus", path = "/Applications/TablePlus.app", bundleID = "com.tinyapp.TablePlus"},
	["v"] = {app = "VS Code", path = "/Applications/Visual Studio Code.app", bundleID = "com.microsoft.VSCode"},
	["x"] = {app = "TextMate", path = "/Applications/TextMate.app", bundleID = "com.macromates.TextMate"},
	["w"] = {app = "WhatsApp", path = "/Applications/WhatsApp.app", bundleID = "net.whatsapp.WhatsApp"},
}

-- Function to launch a URL in a specific browser
local function launchURL(url, browser, key, description)
    local browserBundle = {
        ["Firefox"] = "org.mozilla.firefox",
        ["Chrome"] = "com.google.Chrome",
        ["Safari"] = "com.apple.Safari",
        ["Edge"] = "com.microsoft.edgemac"
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

-- Function to cycle through multiple windows of an app
local function cycleAppWindows(app)
    local windows = app:visibleWindows()

    if #windows == 0 then
        app:activate()
        return
    end

    if #windows == 1 then
        if app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
        return
    end

    local focusedWin = hs.window.focusedWindow()
    local currentIndex = nil

    for i, win in ipairs(windows) do
        if win == focusedWin then
            currentIndex = i
            break
        end
    end

    if currentIndex then
        local nextIndex = (currentIndex % #windows) + 1
        windows[nextIndex]:focus()
    else
        windows[1]:focus()
    end
end

-- Function to launch an app with toggle functionality
local function launchApp(appName, key, itemData)
    -- Safety check for appName
    if not appName then
        hs.alert.show("Error: No app name specified (Key: " .. key .. ")")
        return
    end

    -- Try to find running app using bundle ID first (fastest)
    local app = nil
    if itemData.bundleID then
        app = hs.application.get(itemData.bundleID)
    end

    -- If app is running, handle multi-window cycling
    if app then
        cycleAppWindows(app)
        return
    end

    -- App is not running, launch it
    if itemData.path then
        -- Try to launch from specified custom path (SAFE - no command injection)
        local app = hs.application.open(itemData.path)
        local success = (app ~= nil)
        local output = success and "Launched via path" or "Failed to launch"
        if success then
            hs.alert.show("Launched: " .. appName .. " (Key: " .. key .. ")")
        else
            -- If the app is not found at the custom path, show an alert with error
            hs.alert.show("Failed to launch: " .. appName .. " (Key: " .. key .. ")")
            -- Log the error for debugging
            hs.logger.new('hyperkey', 'debug'):e("Launch error for " .. appName .. ": " .. (output or "unknown error"))
        end
    elseif itemData.bundleID then
        -- Try to launch by bundle ID (SAFE - no command injection)
        local app = hs.application.open(itemData.bundleID)
        local success = (app ~= nil)
        local output = success and "Launched via bundle ID" or "Failed to launch"
        if not success then
            hs.alert.show("Failed to launch: " .. appName .. " (Key: " .. key .. ")")
            hs.logger.new('hyperkey', 'debug'):e("Launch error for " .. appName .. ": " .. (output or "unknown error"))
        else
            hs.alert.show("Launched: " .. appName .. " (Key: " .. key .. ")")
        end
    else
        -- Try to launch the app by name (fallback)
        app = hs.application.find(appName)
        if app then
            app:activate()
        else
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
        -- Handle regular app launch with toggle functionality
        launchApp(itemData.app, key, itemData)
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
    local keyCode = event:getKeyCode()
    local keyPressed = hs.keycodes.map[keyCode]
    local flags = event:getFlags()

    -- Check if ALL hyper key modifiers are pressed
    local hyperKeyPressed = flags.ctrl and flags.shift and flags.alt and flags.cmd

    -- Only show alert if hyper key combo is pressed AND the key is not in our appList
    if hyperKeyPressed and keyPressed and appList[keyPressed] == nil then
        -- Show an alert if no mapping is found for this hyper key combination
        hs.alert.show("No mapping found for Hyper+" .. keyPressed)
    end
end):start()

-- Show a notification when Hammerspoon loads, to let you know the script is active
hs.notify.new({title="Hammerspoon", informativeText="App launcher script is active!"}):send()
