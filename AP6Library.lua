local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local AP6 = {}

AP6.Colors = {
    Background = Color3.fromRGB(24,24,28),
    Primary = Color3.fromRGB(140,170,255),
    Secondary = Color3.fromRGB(255,120,150),
    Accent = Color3.fromRGB(170,255,200),
    Text = Color3.fromRGB(235,235,240)
}

AP6.Sounds = {
    Click = 9118823102,
    Notify = 9118823102
}

local function sound(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..id
    s.Volume = 1
    s.Parent = SoundService
    s:Play()
    Debris:AddItem(s,3)
end

local function tween(o,p,t,s,d)
    TweenService:Create(
        o,
        TweenInfo.new(t or 0.4, s or Enum.EasingStyle.Quad, d or Enum.EasingDirection.Out),
        p
    ):Play()
end

function AP6:FadeIn(o,t)
    o.Visible = true
    o.BackgroundTransparency = 1
    tween(o,{BackgroundTransparency = 0},t)
end

function AP6:FadeOut(o,t)
    tween(o,{BackgroundTransparency = 1},t)
    task.delay(t or 0.4,function()
        o.Visible = false
    end)
end

function AP6:Notify(title,text,dur)
    local gui = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,340,0,55)
    frame.Position = UDim2.new(1,-350,1,-85)
    frame.BackgroundColor3 = self.Colors.Secondary
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-14,1,-14)
    lbl.Position = UDim2.new(0,7,0,7)
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 15
    lbl.TextColor3 = self.Colors.Text
    lbl.Text = "✦ "..title.."  "..text
    lbl.Parent = frame

    sound(self.Sounds.Notify)
    self:FadeIn(frame,0.35)

    task.delay(dur or 3,function()
        self:FadeOut(frame,0.35)
        task.wait(0.35)
        frame:Destroy()
    end)
end

function AP6:CreateWindow(title,toggleKey)
    local gui = Instance.new("ScreenGui")
    gui.Name = "AP6_UI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,460,0,340)
    main.Position = UDim2.new(0.5,-230,0.5,-170)
    main.BackgroundColor3 = self.Colors.Background
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Visible = false
    main.Parent = gui

    local top = Instance.new("TextLabel")
    top.Size = UDim2.new(1,0,0,46)
    top.BackgroundTransparency = 1
    top.Font = Enum.Font.GothamBold
    top.TextSize = 20
    top.TextColor3 = self.Colors.Text
    top.Text = "✦ "..title
    top.Parent = main

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,1,-56)
    container.Position = UDim2.new(0,0,0,56)
    container.BackgroundTransparency = 1
    container.Parent = main

    local layout = Instance.new("UIListLayout",container)
    layout.Padding = UDim.new(0,10)

    self:FadeIn(main,0.6)

    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if toggleKey and i.KeyCode == toggleKey then
            if main.Visible then
                self:FadeOut(main,0.4)
            else
                self:FadeIn(main,0.4)
            end
        end
    end)

    return container
end

function AP6:CreateButton(parent,text,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,38)
    btn.BackgroundColor3 = self.Colors.Primary
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = self.Colors.Text
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        sound(self.Sounds.Click)
        tween(btn,{BackgroundColor3 = self.Colors.Accent},0.15)
        task.wait(0.15)
        tween(btn,{BackgroundColor3 = self.Colors.Primary},0.15)
        callback()
    end)

    return btn
end

function AP6:CreateLabel(parent,text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-20,0,28)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = self.Colors.Accent
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.Parent = parent
    return lbl
end

return AP6
