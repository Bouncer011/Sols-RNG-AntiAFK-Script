-- Roblox Discord Webhook Notifier
-- This script connects to Roblox and sends notifications to a Discord webhook
-- when certain events occur. It includes details like boost changes, server link,
-- ping information, and a chat log.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

-- Configuration for the Discord webhook
local webhookUrl = "YOUR_DISCORD_WEBHOOK_URL" -- Replace with your Discord webhook URL

-- Function to send a message to the Discord webhook
-- @param content: The content of the message to send.
-- @param embed: The embed data to send.
local function sendToWebhook(content, embed)
    local data = {
        content = content,
        embeds = {embed}
    }
    
    local jsonData = HttpService:JSONEncode(data)
    
    -- Send the POST request to the Discord webhook
    local response = HttpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    return response
end

-- Function to send initial game load embed
local function sendInitialNotification()
    local ping = Players.LocalPlayer:GetNetworkPing()
    local players = #Players:GetPlayers()
    local maxPlayers = game:GetService("Players").MaxPlayers
    
    local embed = {
        title = "Sol's RNG Stay AFK Webhook",
        description = "```\nMindset 2024 ©\nThis is free and unencumbered software released into the public domain.\n\nAnyone is free to copy, modify, publish, use, compile, sell, or\ndistribute this software, either in source code form or as a compiled\nbinary, for any purpose, commercial or non-commercial, and by any\nmeans.\n\nIn jurisdictions that recognize copyright laws, the author or authors\nof this software dedicate any and all copyright interest in the\nsoftware to the public domain. We make this dedication for the benefit\nof the public at large and to the detriment of our heirs and\nsuccessors. We intend this dedication to be an overt act of\nrelinquishment in perpetuity of all present and future rights to this\nsoftware under copyright law.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,\nEXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\nMERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\nIN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR\nOTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,\nARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR\nOTHER DEALINGS IN THE SOFTWARE.\n\nFor more information, please refer to <https://unlicense.org>\n```",
        color = 0x00FF00, -- Green color for the embed
        fields = {
            {name = "`Server`", value = "[`Sol's RNG`](https://robloxlive.com)", inline = true},
            {name = "`Ping`", value = "**" .. tostring(ping) .. " ms**", inline = true},
            {name = "`Current amount of players`", value = "**" .. tostring(players) .. "/" .. tostring(maxPlayers) .. "**", inline = true}
        }
    }
    
    sendToWebhook(nil, embed)
end

-- Function to capture a screenshot of the game
-- @return: Returns the URL of the screenshot.
local function captureScreenshot()
    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local screenshot = Instance.new("ScreenGui", player.PlayerGui)
    local frame = Instance.new("Frame", screenshot)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    
    -- Capture the screenshot
    local image = camera:CaptureScreenshot()
    screenshot:Destroy()
    
    return image
end

-- may not work..
-- Function to check for boost changes and send notifications
local function checkBoostChanges()
    local currentLuckAmt = 1 -- Placeholder, replace with actual logic
    local currentSpeedAmt = 1 -- Placeholder, replace with actual logic
    
    local luckAmtToUse = 1
    local speedAmtToUse = 1

    local boostChanged = false -- Placeholder for actual detection logic

    if boostChanged then
        local embed = {
            title = "Boost Change Detected!",
            description = "A boost has been changed.",
            fields = {
                {name = "Luck Amount", value = tostring(luckAmtToUse), inline = true},
                {name = "Speed Amount", value = tostring(speedAmtToUse), inline = true}
            },
            color = 0xFF0000 -- Red color for the embed
        }
        
        sendToWebhook("Boost change detected!", embed)
    end
end

-- Function to log chat messages
local function logChat()
    game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
        local embed = {
            title = "Chat Log",
            description = "A new chat message was detected.",
            fields = {
                {name = "Message", value = message, inline = false}
            },
            color = 0x0000FF -- Blue color for the embed
        }
        
        sendToWebhook(nil, embed)
    end)
end

-- Function to check player ping hourly
local function checkPingHourly()
    while true do
        local ping = Players.LocalPlayer:GetNetworkPing()
        local embed = {
            title = "Hourly Ping Check",
            description = "Ping has been checked.",
            fields = {
                {name = "Ping", value = tostring(ping) .. " ms", inline = true}
            },
            color = 0xFFFF00 -- Yellow color for the embed
        }
        
        sendToWebhook(nil, embed)
        task.wait(3600) -- Wait for 1 hour
    end
end

-- Main logic
sendInitialNotification()
logChat()
RunService.Heartbeat:Connect(function()
    checkBoostChanges()
end)

-- Capture a screenshot every 20 minutes
task.spawn(function()
    while true do
        local screenshotUrl = captureScreenshot()
        local embed = {
            title = "Scheduled Screenshot",
            description = "A screenshot has been captured.",
            fields = {
                {name = "Screenshot", value = screenshotUrl, inline = false}
            },
            color = 0x00FFFF -- Cyan color for the embed
        }
        
        sendToWebhook("Scheduled screenshot", embed)
        task.wait(1200) -- Wait for 20 minutes
    end
end)

-- Simulate clicking to avoid disconnection
task.spawn(function()
    while true do
        UserInputService:SendInputObject(InputObject.new(Enum.InputType.MouseButton1, Vector2.new(), Enum.UserInputType.MouseButton1))
        task.wait(600) -- Wait for 10 minutes
    end
end)

-- Start hourly ping checks
task.spawn(checkPingHourly)
