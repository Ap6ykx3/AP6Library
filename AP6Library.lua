local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function getExecutor()
    if identifyexecutor then return identifyexecutor().Name end
    if getexecutorname then return getexecutorname() end
    return "Unknown"
end

local AP6 = {
    PlayerGui = PlayerGui,
    NeonGreen = Color3.fromRGB(0, 255, 130),
    Cyan = Color3.fromRGB(0, 255, 255),
    Dark = Color3.fromRGB(6, 6, 10)
}

function AP6:TypeText(label, text, speed)
    label.Text = ""
    for i = 1, #text do
        label.Text = text:sub(1, i)
        task.wait(speed or 0.025)
    end
end

function AP6:BootSequence(callback)
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "NEURONET_BOOT"
    gui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = AP6.Dark

    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0,800,0,120)
    logo.Position = UDim2.new(0.5,-400,0.28,0)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6 NEURONET"
    logo.TextColor3 = AP6.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 80
    logo.TextStrokeTransparency = 0.4
    logo.TextStrokeColor3 = Color3.new(0,0,0)

    local sub = Instance.new("TextLabel", bg)
    sub.Size = UDim2.new(0,800,0,50)
    sub.Position = UDim2.new(0.5,-400,0.42,0)
    sub.BackgroundTransparency = 1
    sub.Text = "TERMINATOR v3.2 — SHADOW PROTOCOL"
    sub.TextColor3 = AP6.NeonGreen
    sub.Font = Enum.Font.Code
    sub.TextSize = 32

    local progBg = Instance.new("Frame", bg)
    progBg.Size = UDim2.new(0,600,0,12)
    progBg.Position = UDim2.new(0.5,-300,0.55,0)
    progBg.BackgroundColor3 = Color3.fromRGB(20,20,25)
    Instance.new("UICorner", progBg).CornerRadius = UDim.new(0,6)

    local prog = Instance.new("Frame", progBg)
    prog.Size = UDim2.new(0,0,1,0)
    prog.BackgroundColor3 = AP6.Cyan
    Instance.new("UICorner", prog).CornerRadius = UDim.new(0,6)
    Instance.new("UIGradient", prog).Color = ColorSequence.new{ColorSequenceKeypoint.new(0, AP6.Cyan), ColorSequenceKeypoint.new(1, AP6.NeonGreen)}

    local console = Instance.new("TextLabel", bg)
    console.Size = UDim2.new(0.7,0,0.3,0)
    console.Position = UDim2.new(0.15,0,0.65,0)
    console.BackgroundTransparency = 1
    console.TextColor3 = AP6.NeonGreen
    console.Font = Enum.Font.Code
    console.TextSize = 20
    console.TextXAlignment = Enum.TextXAlignment.Left
    console.TextYAlignment = Enum.TextYAlignment.Top

    TweenService:Create(prog, TweenInfo.new(4, Enum.EasingStyle.Quart), {Size = UDim2.new(1,0,1,0)}):Play()

    local lines = {
        "[EXEC] Detected: " .. getExecutor(),
        "[NEURONET] Initializing core systems...",
        "[SHADOW] Establishing encrypted tunnel...",
        "[ANTI] Bypassing detection layers...",
        "[PAYLOAD] Loading universal injector...",
        "[TARGET] Scanning supported universes...",
        "[SUCCESS] All modules loaded. Ready."
    }

    local full = ""
    for _, line in ipairs(lines) do
        local toType = full .. line .. "\n"
        task.spawn(function() AP6:TypeText(console, toType, 0.02) end)
        full = toType
        task.wait(0.5)
    end

    task.wait(2)
    TweenService:Create(bg, TweenInfo.new(1, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(console, TweenInfo.new(1), {TextTransparency = 1}):Play()
    task.wait(1.2)
    gui:Destroy()
    callback()
end

function AP6:Notify(title, text, duration)
    local gui = AP6.PlayerGui:FindFirstChild("NEURONET_NOTIFY") or Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "NEURONET_NOTIFY"
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 380, 1, -120)
    holder.Position = UDim2.new(1, -400, 0, 60)
    holder.BackgroundTransparency = 1

    if not holder:FindFirstChild("List") then
        local l = Instance.new("UIListLayout", holder)
        l.Padding = UDim.new(0, 12)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local frame = Instance.new("Frame", holder)
    frame.Size = UDim2.new(1,0,0,82)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,15)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = AP6.Cyan
    stroke.Thickness = 2.5

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(1,-30,0,26)
    t.Position = UDim2.new(0,20,0,14)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = AP6.Cyan
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 17

    local d = Instance.new("TextLabel", frame)
    d.Size = UDim2.new(1,-30,0,40)
    d.Position = UDim2.new(0,20,0,38)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = Color3.new(1,1,1)
    d.Font = Enum.Font.Gotham
    d.TextSize = 15
    d.TextWrapped = true

    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(t, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(d, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.delay(duration or 4, function()
        TweenService:Create(frame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.6), {Transparency = 1}):Play()
        TweenService:Create(t, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
        TweenService:Create(d, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
        task.wait(0.7)
        frame:Destroy()
    end)
end

function AP6:CreateMainUI(games)
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "NEURONET_UI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 960, 0, 580)
    main.Position = UDim2.new(0.5, -480, 0.5, -290)
    main.BackgroundColor3 = AP6.Dark
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = AP6.Cyan
    stroke.Thickness = 3

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,56)
    header.BackgroundColor3 = Color3.fromRGB(12,12,18)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,16)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1,-20,1,0)
    title.Position = UDim2.new(0,25,0,0)
    title.BackgroundTransparency = 1
    title.Text = "AP6 UNIVERSAL  •  TERMINATOR v3.2"
    title.TextColor3 = AP6.Cyan
    title.Font = Enum.Font.Code
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Left

    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -40, 1, -120)
    scroll.Position = UDim2.new(0, 20, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = AP6.Cyan

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 18)

    local currentPlace = game.PlaceId
    for placeId, info in pairs(games) do
        local isCurrent = (placeId == currentPlace)
        local card = Instance.new("Frame", scroll)
        card.Size = UDim2.new(1,0,0,100)
        card.BackgroundColor3 = isCurrent and Color3.fromRGB(15,15,22) or Color3.fromRGB(12,12,18)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,14)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = isCurrent and AP6.NeonGreen or Color3.fromRGB(25,25,30)
        cardStroke.Thickness = 2

        local icon = Instance.new("TextLabel", card)
        icon.Size = UDim2.new(0,70,1,0)
        icon.Text = isCurrent and "✅" or "⛔"
        icon.TextColor3 = isCurrent and AP6.NeonGreen or Color3.fromRGB(200,50,50)
        icon.Font = Enum.Font.Code
        icon.TextSize = 50
        icon.BackgroundTransparency = 1

        local name = Instance.new("TextLabel", card)
        name.Size = UDim2.new(1,-200,0,50)
        name.Position = UDim2.new(0,80,0,10)
        name.BackgroundTransparency = 1
        name.Text = info.name
        name.TextColor3 = isCurrent and Color3.new(1,1,1) or Color3.fromRGB(180,180,180)
        name.Font = Enum.Font.GothamBold
        name.TextSize = 26
        name.TextXAlignment = Enum.TextXAlignment.Left

        local status = Instance.new("TextLabel", card)
        status.Size = UDim2.new(0,120,0,30)
        status.Position = UDim2.new(1,-140,0,15)
        status.BackgroundTransparency = 1
        status.Text = isCurrent and "READY" or "Not in game"
        status.TextColor3 = isCurrent and AP6.NeonGreen or Color3.fromRGB(200,50,50)
        status.Font = Enum.Font.Gotham
        status.TextSize = 16

        local btn = Instance.new("TextButton", card)
        btn.Size = UDim2.new(0,160,0,46)
        btn.Position = UDim2.new(1,-180,0.5,-23)
        btn.BackgroundColor3 = isCurrent and AP6.NeonGreen or Color3.fromRGB(40,40,45)
        btn.Text = isCurrent and "BREACH" or "LOCKED"
        btn.TextColor3 = isCurrent and Color3.new(0,0,0) or Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 18
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

        btn.MouseButton1Click:Connect(function()
            if isCurrent then
                AP6:Notify("BREACHING", info.name, 3)
                task.wait(1.5)
                gui:Destroy()
                loadstring(game:HttpGet(info.url))()
            else
                AP6:Notify("ERROR", "you not are in the game", 4)
            end
        end)

        card.MouseEnter:Connect(function()
            TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = isCurrent and AP6.NeonGreen or AP6.Cyan, Thickness = 3}):Play()
        end)
        card.MouseLeave:Connect(function()
            TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = isCurrent and AP6.NeonGreen or Color3.fromRGB(25,25,30), Thickness = 2}):Play()
        end)
    end

    scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 40)

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

    UserInputService.InputBegan:Connect(function(key)
        if key.KeyCode == Enum.KeyCode.RightShift then
            gui.Enabled = not gui.Enabled
        end
    end)

    AP6:Notify("StudiosHUB", "Welcome back, Ap6ykx3", 3)
end

function AP6:Init(games)
    AP6:BootSequence(function()
        AP6:CreateMainUI(games)
    end)
end

return AP6
