local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    UI = {},
    Theme = {
        Main = Color3.fromRGB(8, 8, 12),
        Accent = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(0, 255, 130),
        DarkText = Color3.fromRGB(150, 150, 150),
        Outline = Color3.fromRGB(25, 25, 35)
    }
}

local function getExecutor()
    if identifyexecutor then return identifyexecutor() end
    return "Generic"
end

function AP6:CreateElement(className, properties, parent)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do inst[k] = v end
    inst.Parent = parent
    return inst
end

function AP6:ApplyTween(obj, info, goal)
    local tween = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    tween:Play()
    return tween
end

function AP6:TypeText(label, text, speed)
    label.Text = ""
    for i = 1, #text do
        label.Text = text:sub(1, i)
        task.wait(speed or 0.015)
    end
end

function AP6:BootSequence(callback)
    local gui = self:CreateElement("ScreenGui", {Name = "AP6_BOOT", IgnoreGuiInset = true}, PlayerGui)
    local canvas = self:CreateElement("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = self.Theme.Main, GroupTransparency = 1}, gui)
    
    local logo = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 400, 0, 100),
        Position = UDim2.new(0.5, -200, 0.45, -50),
        BackgroundTransparency = 1,
        Text = "AP6",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.Code,
        TextSize = 120,
        TextStrokeTransparency = 0.8
    }, canvas)
    
    local barFrame = self:CreateElement("Frame", {
        Size = UDim2.new(0, 300, 0, 2),
        Position = UDim2.new(0.5, -150, 0.55, 0),
        BackgroundColor3 = self.Theme.Outline,
        BorderSizePixel = 0
    }, canvas)
    
    local bar = self:CreateElement("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.Theme.Accent, BorderSizePixel = 0}, barFrame)
    
    local log = self:CreateElement("TextLabel", {
        Size = UDim2.new(0, 400, 0, 20),
        Position = UDim2.new(0.5, -200, 0.57, 0),
        BackgroundTransparency = 1,
        TextColor3 = self.Theme.DarkText,
        Text = "INITIALIZING...",
        Font = Enum.Font.Code,
        TextSize = 14
    }, canvas)

    self:ApplyTween(canvas, {0.8}, {GroupTransparency = 0})
    task.wait(0.5)
    
    local stages = {"ACCESSING KERNEL", "BYPASSING_HEURISTICS", "DECRYPTING_UI", "AP6_READY"}
    for i, msg in ipairs(stages) do
        log.Text = msg
        self:ApplyTween(bar, {0.6, Enum.EasingStyle.Quart}, {Size = UDim2.new(i/#stages, 0, 1, 0)})
        task.wait(0.7)
    end

    self:ApplyTween(canvas, {0.8}, {GroupTransparency = 1})
    task.wait(0.8)
    gui:Destroy()
    callback()
end

function AP6:Notify(title, text, duration)
    local gui = PlayerGui:FindFirstChild("AP6_NOTIF") or self:CreateElement("ScreenGui", {Name = "AP6_NOTIF", IgnoreGuiInset = true}, PlayerGui)
    local container = gui:FindFirstChild("Holder") or self:CreateElement("Frame", {
        Name = "Holder",
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -320, 0, 0),
        BackgroundTransparency = 1
    }, gui)
    
    local layout = container:FindFirstChild("Layout") or self:CreateElement("UIListLayout", {
        Name = "Layout",
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10)
    }, container)

    local notif = self:CreateElement("CanvasGroup", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = Color3.fromRGB(12, 12, 16),
        GroupTransparency = 1
    }, container)
    self:CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}, notif)
    self:CreateElement("UIStroke", {Color = self.Theme.Accent, Thickness = 1.2}, notif)

    local t = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = title:upper(),
        TextColor3 = self.Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, notif)
    
    local d = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    }, notif)

    self:ApplyTween(notif, {0.4}, {GroupTransparency = 0})
    task.delay(duration or 4, function()
        self:ApplyTween(notif, {0.4}, {GroupTransparency = 1})
        task.wait(0.4)
        notif:Destroy()
    end)
end

function AP6:CreateMainUI(games)
    local gui = self:CreateElement("ScreenGui", {Name = "AP6_HUB", IgnoreGuiInset = true, ResetOnSpawn = false}, PlayerGui)
    local main = self:CreateElement("CanvasGroup", {
        Size = UDim2.new(0, 650, 0, 400),
        Position = UDim2.new(0.5, -325, 0.5, -200),
        BackgroundColor3 = self.Theme.Main,
        GroupTransparency = 1
    }, gui)
    
    self:CreateElement("UICorner", {CornerRadius = UDim.new(0, 6)}, main)
    self:CreateElement("UIStroke", {Color = self.Theme.Outline, Thickness = 1}, main)
    
    local sidebar = self:CreateElement("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Color3.fromRGB(12, 12, 18),
        BorderSizePixel = 0
    }, main)
    
    self:CreateElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = "AP6 HUB",
        TextColor3 = self.Theme.Accent,
        Font = Enum.Font.Code,
        TextSize = 24
    }, sidebar)

    local infoBox = self:CreateElement("Frame", {
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 1, -70),
        BackgroundColor3 = Color3.fromRGB(15, 15, 22),
    }, sidebar)
    self:CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}, infoBox)
    
    local execText = self:CreateElement("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "EXEC: " .. getExecutor(),
        TextColor3 = self.Theme.Secondary,
        Font = Enum.Font.Code,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, infoBox)

    local scroll = self:CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, -200, 1, -20),
        Position = UDim2.new(0, 190, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent
    }, main)
    
    local layout = self:CreateElement("UIListLayout", {Padding = UDim.new(0, 8)}, scroll)

    for id, data in pairs(games) do
        local active = (id == game.PlaceId)
        local item = self:CreateElement("Frame", {
            Size = UDim2.new(1, -10, 0, 50),
            BackgroundColor3 = active and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(12, 12, 18),
            BorderSizePixel = 0
        }, scroll)
        self:CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}, item)
        
        local accent = self:CreateElement("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = active and self.Theme.Accent or self.Theme.Outline,
            BorderSizePixel = 0
        }, item)

        self:CreateElement("TextLabel", {
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 15, 0, 0),
            BackgroundTransparency = 1,
            Text = data.name:upper(),
            TextColor3 = active and Color3.new(1,1,1) or self.Theme.DarkText,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        }, item)

        local btn = self:CreateElement("TextButton", {
            Size = UDim2.new(0, 80, 0, 26),
            Position = UDim2.new(1, -90, 0.5, -13),
            BackgroundColor3 = active and self.Theme.Accent or self.Theme.Outline,
            Text = active and "BREACH" or "LOCKED",
            TextColor3 = active and Color3.new(0,0,0) or self.Theme.DarkText,
            Font = Enum.Font.GothamBlack,
            TextSize = 11
        }, item)
        self:CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}, btn)

        btn.MouseButton1Click:Connect(function()
            if active then
                self:ApplyTween(main, {0.5}, {GroupTransparency = 1})
                task.wait(0.5)
                gui:Destroy()
                loadstring(game:HttpGet(data.url))()
            else
                self:Notify("ACCESS DENIED", "Target mismatch.", 3)
            end
        end)
    end

    scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y)
    
    self:ApplyTween(main, {1}, {GroupTransparency = 0})
    
    local drag = {}
    main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag.Active = true
            drag.Start = i.Position
            drag.Pos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag.Active and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - drag.Start
            main.Position = UDim2.new(drag.Pos.X.Scale, drag.Pos.X.Offset + delta.X, drag.Pos.Y.Scale, drag.Pos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag.Active = false end
    end)
end

function AP6:Init(games)
    self:BootSequence(function()
        self:CreateMainUI(games)
    end)
end

return AP6
