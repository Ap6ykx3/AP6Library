-- AP6Library.lua (GUARDALO EN: https://raw.githubusercontent.com/Ap6ykx3/AP6Library/main/AP6Library.lua)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    PlayerGui = PlayerGui,
    Theme = {
        Background = Color3.fromRGB(12, 12, 16),
        Topbar = Color3.fromRGB(18, 18, 24),
        Secondary = Color3.fromRGB(22, 22, 28),
        Primary = Color3.fromRGB(255, 0, 45),
        Accent = Color3.fromRGB(255, 40, 80),
        Text = Color3.fromRGB(240, 240, 240),
        Subtext = Color3.fromRGB(160, 160, 170),
        Element = Color3.fromRGB(26, 26, 34),
        ElementHover = Color3.fromRGB(34, 34, 44),
        Stroke = Color3.fromRGB(50, 50, 60)
    },
    Sounds = {
        Notify = "rbxassetid://6518811702",
        Click = "rbxassetid://6895079853",
        Hover = "rbxassetid://8739001153",
        Load = "rbxassetid://138090596"
    },
    Icons = {
        Ready = "✅",
        NotInGame = "⛔",
        Developing = "⚙️"
    }
}

function AP6:PlaySound(id)
    local s = Instance.new("Sound", workspace)
    s.SoundId = id
    s.Volume = 0.65
    s:Play()
    game.Debris:AddItem(s, 4)
end

function AP6:CheckKey(input, success, fail)
    if input == "Ap6S" then success() else fail() end
end

function AP6:Notify(title, content, duration)
    self:PlaySound(self.Sounds.Notify)
    local gui = self.PlayerGui:FindFirstChild("AP6Notify") or Instance.new("ScreenGui", self.PlayerGui)
    gui.Name = "AP6Notify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 380, 1, -120)
    holder.Position = UDim2.new(1, -400, 0, 80)
    holder.BackgroundTransparency = 1

    if not holder:FindFirstChild("Layout") then
        local l = Instance.new("UIListLayout", holder)
        l.Padding = UDim.new(0, 16)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local frame = Instance.new("Frame", holder)
    frame.Size = UDim2.new(1, 0, 0, 88)
    frame.BackgroundColor3 = self.Theme.Background
    frame.BackgroundTransparency = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = self.Theme.Primary
    stroke.Thickness = 2.5
    stroke.Transparency = 1

    local titleLbl = Instance.new("TextLabel", frame)
    titleLbl.Size = UDim2.new(1, -40, 0, 26)
    titleLbl.Position = UDim2.new(0, 20, 0, 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title:upper()
    titleLbl.TextColor3 = self.Theme.Primary
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 17
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local contentLbl = Instance.new("TextLabel", frame)
    contentLbl.Size = UDim2.new(1, -40, 0, 40)
    contentLbl.Position = UDim2.new(0, 20, 0, 38)
    contentLbl.BackgroundTransparency = 1
    contentLbl.Text = content
    contentLbl.TextColor3 = self.Theme.Text
    contentLbl.Font = Enum.Font.Gotham
    contentLbl.TextSize = 15
    contentLbl.TextWrapped = true
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(titleLbl, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
    TweenService:Create(contentLbl, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()

    task.delay(duration or 5, function()
        TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.6), {Transparency = 1}):Play()
        TweenService:Create(titleLbl, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
        TweenService:Create(contentLbl, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
        task.wait(0.65)
        frame:Destroy()
    end)
end

function AP6:FadeIn(frame, duration)
    frame.BackgroundTransparency = 1
    for _, obj in ipairs(frame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.TextTransparency = 1
        elseif obj:IsA("UIStroke") then
            obj.Transparency = 1
        end
    end
    TweenService:Create(frame, TweenInfo.new(duration or 0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0}):Play()
    task.delay(0.15, function()
        for _, obj in ipairs(frame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                TweenService:Create(obj, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
            elseif obj:IsA("UIStroke") then
                TweenService:Create(obj, TweenInfo.new(0.7), {Transparency = 0}):Play()
            end
        end
    end)
end

function AP6:MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function AP6:BindToggle(frame)
    local toggled = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggled = not toggled
            frame.Visible = toggled
        end
    end)
end

function AP6:Loading(callback)
    local gui = Instance.new("ScreenGui", self.PlayerGui)
    gui.Name = "AP6Loading"
    gui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(8, 8, 12)

    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0, 480, 0, 90)
    logo.Position = UDim2.new(0.5, -240, 0.42, -45)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6"
    logo.TextColor3 = self.Theme.Primary
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 88
    logo.TextTransparency = 1

    local subtitle = Instance.new("TextLabel", bg)
    subtitle.Size = UDim2.new(0, 480, 0, 40)
    subtitle.Position = UDim2.new(0.5, -240, 0.42, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "TERMINATOR"
    subtitle.TextColor3 = self.Theme.Text
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 32
    subtitle.TextTransparency = 1

    local bar = Instance.new("Frame", bg)
    bar.Size = UDim2.new(0, 0, 0, 7)
    bar.Position = UDim2.new(0.5, -240, 0.58, 10)
    bar.BackgroundColor3 = self.Theme.Primary
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    self:PlaySound(self.Sounds.Load)

    TweenService:Create(logo, TweenInfo.new(0.9, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
    TweenService:Create(subtitle, TweenInfo.new(1.1, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
    TweenService:Create(bar, TweenInfo.new(2.9, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 480, 0, 7)}):Play()

    task.wait(3.4)
    TweenService:Create(bg, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
    TweenService:Create(bar, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()

    task.wait(0.9)
    gui:Destroy()
    callback()
end

return AP6
