local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    PlayerGui = PlayerGui,
    Colors = {
        Background = Color3.fromRGB(8, 8, 11),
        Secondary = Color3.fromRGB(14, 14, 18),
        Primary = Color3.fromRGB(255, 0, 45),
        Accent = Color3.fromRGB(255, 30, 70),
        Text = Color3.fromRGB(255, 255, 255),
        Grey = Color3.fromRGB(130, 130, 140)
    },
    Sounds = {
        Notify = "rbxassetid://6518811702",
        Click = "rbxassetid://6895079853",
        Hover = "rbxassetid://8739001153",
        Load = "rbxassetid://138090596",
        Success = "rbxassetid://131057808"
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
    s.Volume = 0.7
    s:Play()
    game.Debris:AddItem(s, 4)
end

function AP6:CheckKey(input, success, fail)
    if input == "Ap6S" then
        success()
    else
        fail()
    end
end

function AP6:Notify(title, text, duration)
    self:PlaySound(self.Sounds.Notify)
    local gui = self.PlayerGui:FindFirstChild("AP6Notify") or Instance.new("ScreenGui", self.PlayerGui)
    gui.Name = "AP6Notify"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 360, 1, -100)
    holder.Position = UDim2.new(1, -380, 0, 60)
    holder.BackgroundTransparency = 1

    if not holder:FindFirstChild("Layout") then
        local l = Instance.new("UIListLayout", holder)
        l.Padding = UDim.new(0, 14)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local frame = Instance.new("Frame", holder)
    frame.Size = UDim2.new(1, 0, 0, 82)
    frame.BackgroundColor3 = self.Colors.Background
    frame.BackgroundTransparency = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = self.Colors.Primary
    stroke.Thickness = 3

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -30, 0, 28)
    titleLabel.Position = UDim2.new(0, 18, 0, 14)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title:upper()
    titleLabel.TextColor3 = self.Colors.Primary
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 17
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local desc = Instance.new("TextLabel", frame)
    desc.Size = UDim2.new(1, -30, 0, 40)
    desc.Position = UDim2.new(0, 18, 0, 38)
    desc.BackgroundTransparency = 1
    desc.Text = text
    desc.TextColor3 = self.Colors.Text
    desc.Font = Enum.Font.Gotham
    desc.TextSize = 15
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(desc, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    task.delay(duration or 4.5, function()
        TweenService:Create(frame, TweenInfo.new(0.55, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleLabel, TweenInfo.new(0.55), {TextTransparency = 1}):Play()
        TweenService:Create(desc, TweenInfo.new(0.55), {TextTransparency = 1}):Play()
        task.wait(0.6)
        frame:Destroy()
    end)
end

function AP6:FadeIn(frame, duration)
    frame.BackgroundTransparency = 1
    for _, obj in ipairs(frame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            obj.TextTransparency = 1
        elseif obj:IsA("UIStroke") then
            obj.Transparency = 1
        end
    end
    TweenService:Create(frame, TweenInfo.new(duration or 0.9, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
    task.delay(0.1, function()
        for _, obj in ipairs(frame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                TweenService:Create(obj, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
            elseif obj:IsA("UIStroke") then
                TweenService:Create(obj, TweenInfo.new(0.7), {Transparency = 0}):Play()
            end
        end
    end)
end

function AP6:MakeDraggable(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
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
    bg.BackgroundColor3 = Color3.fromRGB(6, 6, 9)

    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0, 420, 0, 80)
    logo.Position = UDim2.new(0.5, -210, 0.42, -40)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6"
    logo.TextColor3 = self.Colors.Primary
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 72
    logo.TextTransparency = 1

    local subtitle = Instance.new("TextLabel", bg)
    subtitle.Size = UDim2.new(0, 420, 0, 40)
    subtitle.Position = UDim2.new(0.5, -210, 0.42, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "TERMINATOR"
    subtitle.TextColor3 = self.Colors.Text
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 28
    subtitle.TextTransparency = 1

    local bar = Instance.new("Frame", bg)
    bar.Size = UDim2.new(0, 0, 0, 6)
    bar.Position = UDim2.new(0.5, -210, 0.58, 0)
    bar.BackgroundColor3 = self.Colors.Primary
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    self:PlaySound(self.Sounds.Load)

    TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(subtitle, TweenInfo.new(1, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(bar, TweenInfo.new(2.8, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 420, 0, 6)}):Play()

    task.wait(3.3)
    TweenService:Create(bg, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.7), {TextTransparency = 1}):Play()
    TweenService:Create(bar, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()

    task.wait(0.8)
    gui:Destroy()
    callback()
end

return AP6
