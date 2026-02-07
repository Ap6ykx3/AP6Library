local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(4, 4, 6),
        Accent = Color3.fromRGB(0, 255, 130),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 80, 80),
        Outline = Color3.fromRGB(30, 30, 40),
        Text = Color3.fromRGB(220, 220, 220),
        NotifBG = Color3.fromRGB(8, 8, 12)
    },
    IsMinimized = false
}

function AP6:ApplyTween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

-- SISTEMA DE NOTIFICACIONES ESTILO EDEX
function AP6:Notify(title, text, duration)
    duration = duration or 3
    local gui = PlayerGui:FindFirstChild("AP6_NOTIF_GUI") or Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_NOTIF_GUI"
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 300, 1, -20)
    holder.Position = UDim2.new(1, -310, 0, 10)
    holder.BackgroundTransparency = 1
    if not holder:FindFirstChild("UIListLayout") then
        local l = Instance.new("UIListLayout", holder)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
        l.Padding = UDim.new(0, 8)
    end

    local notif = Instance.new("CanvasGroup", holder)
    notif.Size = UDim2.new(1, 0, 0, 65)
    notif.BackgroundColor3 = self.Theme.NotifBG
    notif.GroupTransparency = 1
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 4)
    
    -- FIX STROKE BUG: ApplyStrokeMode = Contextual
    local s = Instance.new("UIStroke", notif)
    s.Color = self.Theme.Cyan
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

    local tLabel = Instance.new("TextLabel", notif)
    tLabel.Size = UDim2.new(1, -20, 0, 25)
    tLabel.Position = UDim2.new(0, 12, 0, 5)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = "[ " .. title:upper() .. " ]"
    tLabel.TextColor3 = self.Theme.Cyan
    tLabel.Font = Enum.Font.Code
    tLabel.TextSize = 13
    tLabel.TextXAlignment = Enum.TextXAlignment.Left

    local dLabel = Instance.new("TextLabel", notif)
    dLabel.Size = UDim2.new(1, -20, 0, 30)
    dLabel.Position = UDim2.new(0, 12, 0, 28)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = text
    dLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dLabel.Font = Enum.Font.Code
    dLabel.TextSize = 11
    dLabel.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", notif)
    bar.Size = UDim2.new(1, 0, 0, 1)
    bar.Position = UDim2.new(0, 0, 1, -1)
    bar.BackgroundColor3 = self.Theme.Cyan
    bar.BorderSizePixel = 0

    self:ApplyTween(notif, {0.4}, {GroupTransparency = 0})
    self:ApplyTween(bar, {duration, Enum.EasingStyle.Linear}, {Size = UDim2.new(0, 0, 0, 1)})

    task.delay(duration, function()
        self:ApplyTween(notif, {0.4}, {GroupTransparency = 1})
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- PANTALLA DE CARGA ESTILO eDex-UI
function AP6:BootSequence(callback)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_BOOT"
    gui.IgnoreGuiInset = true

    local canvas = Instance.new("CanvasGroup", gui)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundColor3 = Color3.fromRGB(2, 2, 4)
    canvas.GroupTransparency = 1

    -- Efecto de Scanlines (opcional pero pro)
    local lines = Instance.new("Frame", canvas)
    lines.Size = UDim2.new(1, 0, 1, 0)
    lines.BackgroundTransparency = 0.95
    lines.BackgroundColor3 = Color3.new(1,1,1)
    lines.ZIndex = 2

    local logo = Instance.new("TextLabel", canvas)
    logo.Size = UDim2.new(0, 600, 0, 100)
    logo.Position = UDim2.new(0.5, -300, 0.4, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6_SYSTEMS"
    logo.TextColor3 = self.Theme.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 60
    
    local console = Instance.new("TextLabel", canvas)
    console.Size = UDim2.new(0, 500, 0, 200)
    console.Position = UDim2.new(0.5, -250, 0.5, 20)
    console.BackgroundTransparency = 1
    console.TextColor3 = self.Theme.Accent
    console.Font = Enum.Font.Code
    console.TextSize = 14
    console.TextXAlignment = Enum.TextXAlignment.Left
    console.TextYAlignment = Enum.TextYAlignment.Top
    console.Text = ""

    self:ApplyTween(canvas, {0.8}, {GroupTransparency = 0})
    
    local sequence = {
        "> INITIALIZING AP6 KERNEL...",
        "> LOADING DYNAMIC LIBRARIES...",
        "> SPOOFING HARDWARE ID...",
        "> BYPASSING HYPERION LAYERS...",
        "> DECOMPILING V-TABLE ENTRIES...",
        "> SUCCESS: SYSTEM_STABLE_V4"
    }

    local currentText = ""
    for _, line in ipairs(sequence) do
        currentText = currentText .. line .. "\n"
        console.Text = currentText
        task.wait(0.3)
    end
    task.wait(0.5)

    self:ApplyTween(canvas, {1, Enum.EasingStyle.Quart}, {GroupTransparency = 1})
    task.wait(1.1)
    gui:Destroy()
    callback()
end

function AP6:CreateMainUI(games)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_HUB"
    gui.ResetOnSpawn = false
    
    local main = Instance.new("CanvasGroup", gui)
    main.Size = UDim2.new(0, 550, 0, 350)
    main.Position = UDim2.new(0.5, -275, 0.5, -175)
    main.BackgroundColor3 = self.Theme.Main
    main.GroupTransparency = 1

    local s = Instance.new("UIStroke", main)
    s.Color = self.Theme.Outline
    s.Thickness = 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    topBar.BorderSizePixel = 0

    local title = Instance.new("TextLabel", topBar)
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Text = "AP6 TERMINAL // USER: " .. Player.Name:upper()
    title.Font = Enum.Font.Code
    title.TextColor3 = self.Theme.Cyan
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local close = Instance.new("TextButton", topBar)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -30, 0, 0)
    close.Text = "X"
    close.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    close.TextColor3 = self.Theme.Red
    close.Font = Enum.Font.Code
    close.BorderSizePixel = 0

    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1, -20, 1, -50)
    scroll.Position = UDim2.new(0, 10, 0, 40)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 1
    scroll.ScrollBarImageColor3 = self.Theme.Cyan

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 5)

    for id, data in pairs(games) do
        local active = (id == game.PlaceId)
        local item = Instance.new("Frame", scroll)
        item.Size = UDim2.new(1, -10, 0, 40)
        item.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        
        local is = Instance.new("UIStroke", item)
        is.Color = active and self.Theme.Accent or self.Theme.Outline
        is.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        local label = Instance.new("TextLabel", item)
        label.Size = UDim2.new(1, -120, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = "> " .. data.name:upper()
        label.Font = Enum.Font.Code
        label.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(80, 80, 80)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1

        local btn = Instance.new("TextButton", item)
        btn.Size = UDim2.new(0, 90, 0, 24)
        btn.Position = UDim2.new(1, -100, 0.5, -12)
        btn.BackgroundColor3 = active and self.Theme.Accent or Color3.fromRGB(20, 20, 25)
        btn.Text = active and "EXECUTE" or "LOCKED"
        btn.Font = Enum.Font.Code
        btn.TextSize = 10
        btn.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(60, 60, 60)

        btn.MouseButton1Click:Connect(function()
            if active then
                -- Lógica Pro: Ejecuta la función personalizada del juego
                if data.onExecute then
                    data.onExecute()
                else
                    self:Notify("SYSTEM", "Injected: " .. data.name, 3)
                end
            else
                self:Notify("ERROR", "Invalid Environment for " .. data.name, 4)
            end
        end)
    end

    close.MouseButton1Click:Connect(function()
        self:ApplyTween(main, {0.5}, {GroupTransparency = 1})
        task.wait(0.5)
        gui:Destroy()
    end)

    -- Draggable
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

    self:ApplyTween(main, {0.8}, {GroupTransparency = 0})
end

function AP6:Init(games)
    self:BootSequence(function()
        self:Notify("WELCOME", "Back online, " .. Player.Name, 4)
        self:CreateMainUI(games)
    end)
end

return AP6
