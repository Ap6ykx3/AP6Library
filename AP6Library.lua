-- AP6Library.lua (GUARDALO EN TU GITHUB COMO AP6Library/main/AP6Library.lua)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Colors = {
        Background = Color3.fromRGB(10, 10, 12),
        Secondary = Color3.fromRGB(15, 15, 18),
        Primary = Color3.fromRGB(255, 0, 45),
        Text = Color3.fromRGB(255, 255, 255),
        Grey = Color3.fromRGB(140, 140, 140)
    },
    Sounds = {
        Notify = "rbxassetid://6518811702",
        Click = "rbxassetid://6895079853",
        Hover = "rbxassetid://8739001153",
        Load = "rbxassetid://138090596"
    },
    Icons = {
        Ready = "✅",
        NotInGame = "🚫",
        Developing = "🔧"
    }
}

function AP6:PlaySound(id)
    local s = Instance.new("Sound", workspace)
    s.SoundId = id
    s.Volume = 0.6
    s:Play()
    game.Debris:AddItem(s, 3)
end

function AP6:CheckKey(input, success, fail)
    if input == "Ap6S" then success() else fail() end
end

function AP6:Notify(title, text, time)
    self:PlaySound(self.Sounds.Notify)
    local gui = PlayerGui:FindFirstChild("AP6Notify") or Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6Notify"
    gui.ResetOnSpawn = false

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 340, 1, -80)
    holder.Position = UDim2.new(1, -360, 0, 40)
    holder.BackgroundTransparency = 1

    if not holder:FindFirstChild("List") then
        local list = Instance.new("UIListLayout", holder)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 12)
        list.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local frame = Instance.new("Frame", holder)
    frame.Size = UDim2.new(1, 0, 0, 78)
    frame.BackgroundColor3 = self.Colors.Background
    frame.BackgroundTransparency = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = self.Colors.Primary
    stroke.Thickness = 2.5

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(1, -24, 0, 26)
    t.Position = UDim2.new(0, 16, 0, 12)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = self.Colors.Primary
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 16
    t.TextXAlignment = Enum.TextXAlignment.Left

    local d = Instance.new("TextLabel", frame)
    d.Size = UDim2.new(1, -24, 0, 36)
    d.Position = UDim2.new(0, 16, 0, 36)
    d.BackgroundTransparency = 1
    d.Text = text
    d.TextColor3 = self.Colors.Text
    d.Font = Enum.Font.Gotham
    d.TextSize = 14
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
    TweenService:Create(t, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(d, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    task.delay(time or 5, function()
        TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(d, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.55)
        frame:Destroy()
    end)
end

function AP6:FadeIn(frame, time)
    frame.BackgroundTransparency = 1
    for _, v in ipairs(frame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then v.TextTransparency = 1
        elseif v:IsA("ImageLabel") then v.ImageTransparency = 1 end
    end
    TweenService:Create(frame, TweenInfo.new(time or 1, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
    task.delay(0.15, function()
        for _, v in ipairs(frame:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.65, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
            elseif v:IsA("ImageLabel") then
                TweenService:Create(v, TweenInfo.new(0.65), {ImageTransparency = 0}):Play()
            end
        end
    end)
end

function AP6:MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
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

function AP6:BindToggle(frame, key)
    key = key or Enum.KeyCode.RightShift
    local visible = true
    UserInputService.InputBegan:Connect(function(i)
        if i.KeyCode == key then
            visible = not visible
            frame.Visible = visible
        end
    end)
end

function AP6:Loading(callback)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6Loading"
    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(1,0,1,0)
    f.BackgroundColor3 = Color3.fromRGB(6,6,8)
    local logo = Instance.new("TextLabel", f)
    logo.Size = UDim2.new(0, 340, 0, 70)
    logo.Position = UDim2.new(0.5, -170, 0.42, -35)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6 TERMINATOR"
    logo.Font = Enum.Font.GothamBlack
    logo.TextSize = 42
    logo.TextColor3 = self.Colors.Primary
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 0, 0, 5)
    bar.Position = UDim2.new(0.5, -170, 0.55, 0)
    bar.BackgroundColor3 = self.Colors.Primary
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 999)
    self:PlaySound(self.Sounds.Load)
    TweenService:Create(bar, TweenInfo.new(2.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 340, 0, 5)}):Play()
    task.wait(2.7)
    TweenService:Create(f, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(bar, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    task.wait(0.7)
    gui:Destroy()
    callback()
end

return AP6
