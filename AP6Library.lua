local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AP6Lib = {}

AP6Lib.Key = "Ap6S"

AP6Lib.Colors = {
    Background = Color3.fromRGB(26,26,26),
    Panel = Color3.fromRGB(34,34,34),
    Primary = Color3.fromRGB(0,170,255),
    Secondary = Color3.fromRGB(255,90,90),
    Text = Color3.fromRGB(230,230,230),
    SubText = Color3.fromRGB(150,150,150)
}

AP6Lib.Icons = {
    Ready = "🟢",
    NotInGame = "🔴",
    Developing = "🟡"
}

function AP6Lib:Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function AP6Lib:FadeIn(obj, t)
    obj.Visible = true
    obj.BackgroundTransparency = 1
    self:Tween(obj, {BackgroundTransparency = 0}, t)
end

function AP6Lib:FadeOut(obj, t, cb)
    self:Tween(obj, {BackgroundTransparency = 1}, t)
    task.delay(t or 0.4, function()
        obj.Visible = false
        if cb then cb() end
    end)
end

function AP6Lib:GetNotifyGui()
    local gui = LocalPlayer:WaitForChild("PlayerGui")
    local n = gui:FindFirstChild("AP6NotifyGui")
    if not n then
        n = Instance.new("ScreenGui", gui)
        n.Name = "AP6NotifyGui"
        n.ResetOnSpawn = false
    end
    return n
end

function AP6Lib:Notify(title, text, dur)
    dur = dur or 3
    local gui = self:GetNotifyGui()

    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0, 340, 0, 60)
    f.Position = UDim2.new(1, 360, 1, -90)
    f.BackgroundColor3 = self.Colors.Panel
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 14)

    local s = Instance.new("UIStroke", f)
    s.Color = self.Colors.Primary
    s.Transparency = 0.6

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -20, 1, -20)
    l.Position = UDim2.new(0, 10, 0, 10)
    l.BackgroundTransparency = 1
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Font = Enum.Font.GothamBold
    l.TextSize = 15
    l.TextColor3 = self.Colors.Text
    l.Text = title.." | "..text

    self:Tween(f, {Position = UDim2.new(1, -360, 1, -90)}, 0.45)

    task.delay(dur, function()
        self:Tween(f, {Position = UDim2.new(1, 360, 1, -90)}, 0.4)
        task.wait(0.4)
        f:Destroy()
    end)
end

function AP6Lib:Confirm(title, text, yes)
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.ResetOnSpawn = false

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 1

    self:Tween(bg, {BackgroundTransparency = 0.4}, 0.3)

    local p = Instance.new("Frame", bg)
    p.Size = UDim2.new(0, 360, 0, 180)
    p.Position = UDim2.new(0.5, -180, 0.5, -90)
    p.BackgroundColor3 = self.Colors.Panel
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 16)

    local t = Instance.new("TextLabel", p)
    t.Size = UDim2.new(1, -30, 0, 40)
    t.Position = UDim2.new(0, 15, 0, 15)
    t.BackgroundTransparency = 1
    t.Text = title
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 18
    t.TextColor3 = self.Colors.Text
    t.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", p)
    c.Size = UDim2.new(1, -30, 0, 40)
    c.Position = UDim2.new(0, 15, 0, 55)
    c.BackgroundTransparency = 1
    c.Text = text
    c.Font = Enum.Font.Gotham
    c.TextSize = 14
    c.TextColor3 = self.Colors.SubText
    c.TextWrapped = true
    c.TextXAlignment = Enum.TextXAlignment.Left

    local y = Instance.new("TextButton", p)
    y.Size = UDim2.new(0.45, 0, 0, 36)
    y.Position = UDim2.new(0.05, 0, 1, -50)
    y.Text = "Yes"
    y.Font = Enum.Font.GothamBold
    y.TextSize = 14
    y.TextColor3 = Color3.new(1,1,1)
    y.BackgroundColor3 = self.Colors.Primary
    Instance.new("UICorner", y).CornerRadius = UDim.new(0, 10)

    local n = Instance.new("TextButton", p)
    n.Size = UDim2.new(0.45, 0, 0, 36)
    n.Position = UDim2.new(0.5, 0, 1, -50)
    n.Text = "No"
    n.Font = Enum.Font.GothamBold
    n.TextSize = 14
    n.TextColor3 = Color3.new(1,1,1)
    n.BackgroundColor3 = self.Colors.Secondary
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)

    y.MouseButton1Click:Connect(function()
        gui:Destroy()
        if yes then yes() end
    end)

    n.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

function AP6Lib:CheckKey(key, success, fail)
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.ResetOnSpawn = false

    local p = Instance.new("Frame", gui)
    p.Size = UDim2.new(0, 420, 0, 260)
    p.Position = UDim2.new(0.5, -210, 0.5, -130)
    p.BackgroundColor3 = self.Colors.Panel
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 20)

    local t = Instance.new("TextLabel", p)
    t.Size = UDim2.new(1, -40, 0, 50)
    t.Position = UDim2.new(0, 20, 0, 20)
    t.BackgroundTransparency = 1
    t.Text = "AP6 HUB"
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 28
    t.TextColor3 = self.Colors.Text
    t.TextXAlignment = Enum.TextXAlignment.Left

    local i = Instance.new("TextBox", p)
    i.Size = UDim2.new(1, -40, 0, 42)
    i.Position = UDim2.new(0, 20, 0, 90)
    i.PlaceholderText = "Enter key"
    i.Text = ""
    i.Font = Enum.Font.GothamSemibold
    i.TextSize = 15
    i.TextColor3 = self.Colors.Text
    i.BackgroundColor3 = self.Colors.Background
    Instance.new("UICorner", i).CornerRadius = UDim.new(0, 12)

    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1, -40, 0, 40)
    b.Position = UDim2.new(0, 20, 1, -60)
    b.Text = "Unlock"
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = self.Colors.Primary
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

    b.MouseButton1Click:Connect(function()
        if i.Text == key then
            gui:Destroy()
            success()
        else
            if fail then fail() end
            self:Notify("AP6 HUB", "Invalid key", 3)
        end
    end)
end

return AP6Lib
