-- AP6Library.lua - Windows CMD Edition (Lag-Free, Clean, Epic)
-- Sube esto a: https://raw.githubusercontent.com/Ap6ykx3/AP6Library/main/AP6Library.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    PlayerGui = PlayerGui,
    Theme = {
        Bg = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(0, 255, 80),
        Prompt = Color3.fromRGB(0, 255, 80),
        Error = Color3.fromRGB(255, 80, 80),
        Accent = Color3.fromRGB(0, 255, 160)
    },
    SupportedGames = {}
}

function AP6:PlaySound(id)
    local s = Instance.new("Sound", workspace)
    s.SoundId = id
    s.Volume = 0.4
    s:Play()
    game.Debris:AddItem(s, 2)
end

-- Simple typing effect
function AP6:Type(label, text, speed, callback)
    label.Text = ""
    local i = 1
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
        if i > #text then conn:Disconnect() if callback then callback() end return end
        label.Text = text:sub(1,i)
        i += 1
    end)
end

-- Boot sequence (fake Windows CMD boot)
function AP6:Boot(callback)
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "AP6Boot"
    gui.IgnoreGuiInset = true

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = AP6.Theme.Bg

    local log = Instance.new("TextLabel", frame)
    log.Size = UDim2.new(0.9,0,0.8,0)
    log.Position = UDim2.new(0.05,0,0.1,0)
    log.BackgroundTransparency = 1
    log.TextColor3 = AP6.Theme.Text
    log.Font = Enum.Font.Code
    log.TextSize = 18
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.TextYAlignment = Enum.TextYAlignment.Top
    log.TextWrapped = true

    local lines = {
        "Microsoft Windows [Version 10.0.19045.4412]",
        "(c) Microsoft Corporation. All rights reserved.",
        "",
        "C:\\AP6\\TERMINATOR> systemcheck",
        "AP6 TERMINATOR v2.1 - ONLINE",
        "Key verified: Ap6S",
        "Scanning universes...",
        "4 targets detected",
        "Ready."
    }

    local fullText = ""
    for _, line in ipairs(lines) do
        AP6:Type(log, fullText .. line .. "\n", 0.015, function() fullText = fullText .. line .. "\n" end)
        task.wait(0.4)
    end

    task.wait(1.5)
    gui:Destroy()
    callback()
end

-- Main Terminal Window
function AP6:OpenTerminal()
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "AP6CMD"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 780, 0, 520)
    main.Position = UDim2.new(0.5, -390, 0.5, -260)
    main.BackgroundColor3 = AP6.Theme.Bg
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = AP6.Theme.Accent
    stroke.Thickness = 2

    -- Title bar (Windows style)
    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1,0,0,32)
    titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,4)

    local title = Instance.new("TextLabel", titleBar)
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Command Prompt - AP6 TERMINATOR"
    title.TextColor3 = Color3.fromRGB(200,200,200)
    title.Font = Enum.Font.Code
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", titleBar)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -38, 0, 1)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(255,100,100)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 22
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Content area
    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, -20, 1, -80)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = AP6.Theme.Text
    content.CanvasSize = UDim2.new(0,0,0,0)

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local function addLine(text, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0,22)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or AP6.Theme.Text
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 18
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = content
        content.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 40)
        content.CanvasPosition = Vector2.new(0, content.CanvasSize.Y.Offset)
    end

    -- Input line
    local inputFrame = Instance.new("Frame", main)
    inputFrame.Size = UDim2.new(1, -20, 0, 36)
    inputFrame.Position = UDim2.new(0, 10, 1, -48)
    inputFrame.BackgroundColor3 = AP6.Theme.Bg

    local prompt = Instance.new("TextLabel", inputFrame)
    prompt.Size = UDim2.new(0, 160, 1, 0)
    prompt.BackgroundTransparency = 1
    prompt.Text = "C:\\AP6\\TERMINATOR> "
    prompt.TextColor3 = AP6.Theme.Prompt
    prompt.Font = Enum.Font.Code
    prompt.TextSize = 18
    prompt.TextXAlignment = Enum.TextXAlignment.Left

    local input = Instance.new("TextBox", inputFrame)
    input.Size = UDim2.new(1, -170, 1, 0)
    input.Position = UDim2.new(0, 165, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.TextColor3 = AP6.Theme.Text
    input.Font = Enum.Font.Code
    input.TextSize = 18
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false

    -- Blinking cursor
    local cursor = Instance.new("TextLabel", inputFrame)
    cursor.Size = UDim2.new(0, 10, 1, 0)
    cursor.Position = UDim2.new(0, 165, 0, 0)
    cursor.BackgroundTransparency = 1
    cursor.Text = "_"
    cursor.TextColor3 = AP6.Theme.Text
    cursor.Font = Enum.Font.Code
    cursor.TextSize = 18
    cursor.TextXAlignment = Enum.TextXAlignment.Left
    TweenService:Create(cursor, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 1}):Play()

    -- Commands
    local commands = {
        help = function()
            addLine("Available commands:", AP6.Theme.Accent)
            addLine("  list          - Show supported games")
            addLine("  inject <name> - Inject into game")
            addLine("  status        - System status")
            addLine("  clear         - Clear screen")
            addLine("  theme <color> - Change color (green/cyan)")
            addLine("  exit          - Close terminal")
        end,
        list = function()
            addLine("Detected targets:", AP6.Theme.Accent)
            for id, info in pairs(AP6.SupportedGames) do
                addLine(string.format("  [%s] %s - %s", id, info.name, info.status), AP6.Theme.Text)
            end
        end,
        status = function()
            addLine("AP6 TERMINATOR v2.1", AP6.Theme.Accent)
            addLine("Connected: YES", AP6.Theme.Text)
            addLine("Current place: " .. game.PlaceId, AP6.Theme.Text)
            addLine("Key: VALID", AP6.Theme.Text)
        end,
        clear = function()
            for _, child in ipairs(content:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
        end,
        inject = function(args)
            local name = table.concat(args, " "):lower()
            local target = nil
            for _, info in pairs(AP6.SupportedGames) do
                if info.name:lower():find(name) then target = info break end
            end
            if target and game.PlaceId == (target.id or 0) then
                addLine("Injecting into " .. target.name .. "...", AP6.Theme.Accent)
                local bar = Instance.new("Frame", content)
                bar.Size = UDim2.new(0.6,0,0,18)
                bar.BackgroundColor3 = AP6.Theme.Accent
                Instance.new("UICorner", bar)
                TweenService:Create(bar, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Size = UDim2.new(0.6,0,0,18)}):Play() -- fake progress
                task.wait(2.8)
                gui:Destroy()
                loadstring(game:HttpGet(target.url))()
            else
                addLine("ERROR: Target not found or not in game.", AP6.Theme.Error)
            end
        end,
        theme = function(args)
            local c = args[1] and args[1]:lower()
            if c == "cyan" then
                AP6.Theme.Text = Color3.fromRGB(0, 255, 255)
                AP6.Theme.Prompt = Color3.fromRGB(0, 255, 255)
                addLine("Theme changed to CYAN", AP6.Theme.Accent)
            else
                AP6.Theme.Text = Color3.fromRGB(0, 255, 80)
                AP6.Theme.Prompt = Color3.fromRGB(0, 255, 80)
                addLine("Theme changed to GREEN", AP6.Theme.Accent)
            end
        end,
        exit = function() gui:Destroy() end
    }

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed and input.Text ~= "" then
            local cmdLine = input.Text
            addLine("C:\\AP6\\TERMINATOR> " .. cmdLine, AP6.Theme.Prompt)
            local parts = cmdLine:split(" ")
            local cmd = parts[1]:lower()
            table.remove(parts, 1)
            if commands[cmd] then
                commands[cmd](parts)
            else
                addLine("Unknown command. Type 'help'", AP6.Theme.Error)
            end
            input.Text = ""
            input:CaptureFocus()
        end
    end)

    -- Draggable
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    input:CaptureFocus()
    addLine("Type 'help' for commands", AP6.Theme.Accent)
end

-- Initialize
function AP6:Init(games)
    AP6.SupportedGames = games
    AP6:Boot(function()
        AP6:OpenTerminal()
    end)
end

return AP6
