local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(6, 6, 8),
        Accent = Color3.fromRGB(0, 255, 130),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 80, 80),
        Outline = Color3.fromRGB(25, 25, 35),
        Text = Color3.fromRGB(200, 200, 200),
        NotifBG = Color3.fromRGB(10, 10, 15)
    },
    IsMinimized = false
}

function AP6:ApplyTween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

function AP6:Notify(title, text, duration)
    duration = duration or 4
    local gui = PlayerGui:FindFirstChild("AP6_NOTIFICATIONS") or Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_NOTIFICATIONS"
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 300, 1, 0)
    holder.Position = UDim2.new(1, -310, 0, 0)
    holder.BackgroundTransparency = 1

    local layout = holder:FindFirstChild("Layout") or Instance.new("UIListLayout", holder)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 10)

    local notif = Instance.new("CanvasGroup", holder)
    notif.Size = UDim2.new(1, 0, 0, 75)
    notif.BackgroundColor3 = self.Theme.NotifBG
    notif.GroupTransparency = 1
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", notif)
    stroke.Color = self.Theme.Outline
    stroke.Thickness = 1

    local tLabel = Instance.new("TextLabel", notif)
    tLabel.Size = UDim2.new(1, -20, 0, 25)
    tLabel.Position = UDim2.new(0, 12, 0, 8)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = title:upper()
    tLabel.TextColor3 = self.Theme.Cyan
    tLabel.Font = Enum.Font.Code
    tLabel.TextSize = 14
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dLabel = Instance.new("TextLabel", notif)
    dLabel.Size = UDim2.new(1, -24, 0, 35)
    dLabel.Position = UDim2.new(0, 12, 0, 30)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = text
    dLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    dLabel.Font = Enum.Font.Code
    dLabel.TextSize = 12
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.TextWrapped = true

    local timerBar = Instance.new("Frame", notif)
    timerBar.Size = UDim2.new(1, 0, 0, 2)
    timerBar.Position = UDim2.new(0, 0, 1, -2)
    timerBar.BackgroundColor3 = self.Theme.Accent
    timerBar.BorderSizePixel = 0

    self:ApplyTween(notif, {0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {GroupTransparency = 0})
    self:ApplyTween(timerBar, {duration, Enum.EasingStyle.Linear}, {Size = UDim2.new(0, 0, 0, 2)})

    task.delay(duration, function()
        self:ApplyTween(notif, {0.5}, {GroupTransparency = 1})
        task.wait(0.5)
        notif:Destroy()
    end)
end

function AP6:BootSequence(callback)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_BOOT"
    gui.IgnoreGuiInset = true

    local canvas = Instance.new("CanvasGroup", gui)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundColor3 = self.Theme.Main
    canvas.GroupTransparency = 1

    local logo = Instance.new("TextLabel", canvas)
    logo.Size = UDim2.new(0, 600, 0, 100)
    logo.Position = UDim2.new(0.5, -300, 0.45, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6 HUB"
    logo.TextColor3 = self.Theme.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 85
    
    local barFrame = Instance.new("Frame", canvas)
    barFrame.Size = UDim2.new(0, 400, 0, 2)
    barFrame.Position = UDim2.new(0.5, -200, 0.55, 0)
    barFrame.BackgroundColor3 = self.Theme.Outline
    barFrame.BorderSizePixel = 0

    local bar = Instance.new("Frame", barFrame)
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = self.Theme.Accent
    bar.BorderSizePixel = 0

    self:ApplyTween(canvas, {0.8}, {GroupTransparency = 0})
    
    local logs = {"[CORE] BYPASSING SENTINEL...", "[V-ENV] LOADING MODULES...", "[SUCCESS] AP6 READY."}
    for i, msg in ipairs(logs) do
        self:ApplyTween(bar, {0.7, Enum.EasingStyle.Quart}, {Size = UDim2.new(i/#logs, 0, 1, 0)})
        task.wait(0.8)
    end

    self:ApplyTween(canvas, {0.8}, {GroupTransparency = 1})
    task.wait(0.8)
    gui:Destroy()
    callback()
end

function AP6:CreateConfirmUI(onConfirm)
    local confirmGui = Instance.new("Frame", self.MainCanvas)
    confirmGui.Size = UDim2.new(1, 0, 1, 0)
    confirmGui.BackgroundColor3 = Color3.new(0,0,0)
    confirmGui.BackgroundTransparency = 1
    confirmGui.ZIndex = 100

    local box = Instance.new("Frame", confirmGui)
    box.Size = UDim2.new(0, 320, 0, 160)
    box.Position = UDim2.new(0.5, -160, 0.5, -80)
    box.BackgroundColor3 = self.Theme.Main
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local s = Instance.new("UIStroke", box)
    s.Color = self.Theme.Red
    s.Thickness = 1.5

    local msg = Instance.new("TextLabel", box)
    msg.Size = UDim2.new(1, 0, 0, 80)
    msg.Position = UDim2.new(0, 0, 0.1, 0)
    msg.BackgroundTransparency = 1
    msg.Text = "UNLOADING CORE MODULES...\nARE YOU SURE?"
    msg.TextColor3 = Color3.new(1,1,1)
    msg.Font = Enum.Font.Code
    msg.TextSize = 14

    local yes = Instance.new("TextButton", box)
    yes.Size = UDim2.new(0, 100, 0, 30)
    yes.Position = UDim2.new(0.15, 0, 0.7, 0)
    yes.BackgroundColor3 = self.Theme.Red
    yes.Text = "TERMINATE"
    yes.Font = Enum.Font.Code
    yes.TextSize = 12
    yes.TextColor3 = Color3.new(1,1,1)

    local no = Instance.new("TextButton", box)
    no.Size = UDim2.new(0, 100, 0, 30)
    no.Position = UDim2.new(0.55, 0, 0.7, 0)
    no.BackgroundColor3 = self.Theme.Outline
    no.Text = "ABORT"
    no.Font = Enum.Font.Code
    no.TextSize = 12
    no.TextColor3 = Color3.new(1,1,1)

    self:ApplyTween(confirmGui, {0.3}, {BackgroundTransparency = 0.4})
    
    yes.MouseButton1Click:Connect(onConfirm)
    no.MouseButton1Click:Connect(function() confirmGui:Destroy() end)
end

function AP6:CreateMainUI(games)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_HUB"
    gui.ResetOnSpawn = false
    
    local main = Instance.new("CanvasGroup", gui)
    main.Size = UDim2.new(0, 600, 0, 380)
    main.Position = UDim2.new(0.5, -300, 0.5, -190)
    main.BackgroundColor3 = self.Theme.Main
    main.GroupTransparency = 1
    self.MainCanvas = main

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = self.Theme.Outline
    mainStroke.Thickness = 1
    
    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    topBar.BorderSizePixel = 0

    local title = Instance.new("TextLabel", topBar)
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Text = "AP6 SYSTEM MANAGER // STABLE_BUILD_V4"
    title.Font = Enum.Font.Code
    title.TextColor3 = self.Theme.Cyan
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local close = Instance.new("TextButton", topBar)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.Text = "X"
    close.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
    close.TextColor3 = self.Theme.Red
    close.Font = Enum.Font.Code
    close.BorderSizePixel = 0

    local min = Instance.new("TextButton", topBar)
    min.Size = UDim2.new(0, 30, 0, 30)
    min.Position = UDim2.new(1, -60, 0, 0)
    min.Text = "-"
    min.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    min.TextColor3 = Color3.new(1,1,1)
    min.Font = Enum.Font.Code
    min.BorderSizePixel = 0

    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.new(0, 10, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = self.Theme.Cyan

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 6)

    for id, data in pairs(games) do
        local active = (id == game.PlaceId)
        local item = Instance.new("Frame", scroll)
        item.Size = UDim2.new(1, -10, 0, 45)
        item.BackgroundColor3 = active and Color3.fromRGB(15, 20, 18) or Color3.fromRGB(10, 10, 12)
        Instance.new("UIStroke", item).Color = active and self.Theme.Accent or self.Theme.Outline
        
        local label = Instance.new("TextLabel", item)
        label.Size = UDim2.new(1, -120, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = "> " .. data.name:upper()
        label.Font = Enum.Font.Code
        label.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(100, 100, 100)
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", item)
        btn.Size = UDim2.new(0, 90, 0, 25)
        btn.Position = UDim2.new(1, -100, 0.5, -12)
        btn.BackgroundColor3 = active and self.Theme.Accent or Color3.fromRGB(20, 20, 25)
        btn.Text = active and "BREACH" or "LOCKED"
        btn.Font = Enum.Font.Code
        btn.TextSize = 11
        btn.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(80, 80, 80)

        if active then
            btn.MouseButton1Click:Connect(function()
                self:ApplyTween(main, {0.6}, {GroupTransparency = 1})
                task.wait(0.6)
                gui:Destroy()
                loadstring(game:HttpGet(data.url))()
            end)
        end
    end

    min.MouseButton1Click:Connect(function()
        self.IsMinimized = not self.IsMinimized
        self:ApplyTween(main, {0.4, Enum.EasingStyle.Quart}, {Size = self.IsMinimized and UDim2.new(0, 600, 0, 30) or UDim2.new(0, 600, 0, 380)})
        scroll.Visible = not self.IsMinimized
    end)

    close.MouseButton1Click:Connect(function()
        self:CreateConfirmUI(function()
            self:ApplyTween(main, {0.5}, {GroupTransparency = 1})
            task.wait(0.5)
            gui:Destroy()
        end)
    end)

    
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
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

    self:ApplyTween(main, {1}, {GroupTransparency = 0})
end

function AP6:Init(games)
    self:BootSequence(function()
        self:Notify("SYSTEM ACCESS", "Welcome back, " .. Player.Name, 5)
        self:CreateMainUI(games)
    end)
end

return AP6
