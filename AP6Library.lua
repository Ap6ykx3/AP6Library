local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(8, 8, 10),
        Secondary = Color3.fromRGB(12, 12, 16),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 60, 60),
        Outline = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Executor = (identifyexecutor and identifyexecutor()) or "Unknown Executor"
}

-- [ UTILS ]
function AP6:Tween(obj, time, goal)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

function AP6:Confetti()
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_CONFETTI"
    for i = 1, 60 do
        task.spawn(function()
            local p = Instance.new("Frame", gui)
            p.Size = UDim2.new(0, math.random(6,12), 0, math.random(6,12))
            p.Position = UDim2.new(math.random(), 0, -0.1, 0)
            p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.8, 1)
            p.BorderSizePixel = 0
            p.Rotation = math.random(0, 360)
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            
            local t = self:Tween(p, math.random(2, 5), {
                Position = UDim2.new(p.Position.X.Scale + math.random(-0.1, 0.1), 0, 1.1, 0),
                Rotation = math.random(0, 1000)
            })
            t.Completed:Wait()
            p:Destroy()
        end)
    end
    task.delay(6, function() gui:Destroy() end)
end

function AP6:Notify(title, msg, dur)
    dur = dur or 3
    local g = PlayerGui:FindFirstChild("AP6_NOTIF_GUI") or Instance.new("ScreenGui", PlayerGui)
    g.Name = "AP6_NOTIF_GUI"
    g.IgnoreGuiInset = true

    local h = g:FindFirstChild("Holder") or Instance.new("Frame", g)
    h.Name = "Holder"
    h.Size = UDim2.new(0, 300, 1, -20)
    h.Position = UDim2.new(1, -310, 0, 10)
    h.BackgroundTransparency = 1
    
    if not h:FindFirstChild("UIListLayout") then
        local l = Instance.new("UIListLayout", h)
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
        l.Padding = UDim.new(0, 8)
    end

    local c = Instance.new("CanvasGroup", h)
    c.Size = UDim2.new(1, 0, 0, 70)
    c.BackgroundColor3 = self.Theme.Secondary
    c.GroupTransparency = 1
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", c)
    s.Color = self.Theme.Accent
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tl = Instance.new("TextLabel", c)
    tl.Size = UDim2.new(1, -20, 0, 30)
    tl.Position = UDim2.new(0, 12, 0, 5)
    tl.BackgroundTransparency = 1
    tl.Text = title:upper()
    tl.TextColor3 = self.Theme.Accent
    tl.Font = Enum.Font.Code
    tl.TextSize = 13
    tl.TextXAlignment = Enum.TextXAlignment.Left

    local dl = Instance.new("TextLabel", c)
    dl.Size = UDim2.new(1, -24, 0, 30)
    dl.Position = UDim2.new(0, 12, 0, 32)
    dl.BackgroundTransparency = 1
    dl.Text = msg
    dl.TextColor3 = Color3.new(1,1,1)
    dl.Font = Enum.Font.Code
    dl.TextSize = 11
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.TextWrapped = true

    self:Tween(c, 0.4, {GroupTransparency = 0})
    task.delay(dur, function()
        self:Tween(c, 0.4, {GroupTransparency = 1}):Completed:Wait()
        c:Destroy()
    end)
end

function AP6:Boot(cb)
    local g = Instance.new("ScreenGui", PlayerGui)
    local c = Instance.new("CanvasGroup", g)
    c.Size = UDim2.new(1, 0, 1, 0)
    c.BackgroundColor3 = Color3.fromRGB(2, 2, 3)
    c.GroupTransparency = 1

    local logo = Instance.new("TextLabel", c)
    logo.Size = UDim2.new(0, 500, 0, 100)
    logo.Position = UDim2.new(0.5, -250, 0.4, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6_HUB_STABLE"
    logo.TextColor3 = self.Theme.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 55
    logo.TextTransparency = 1

    local console = Instance.new("TextLabel", c)
    console.Size = UDim2.new(0, 400, 0, 150)
    console.Position = UDim2.new(0.5, -200, 0.5, 20)
    console.BackgroundTransparency = 1
    console.TextColor3 = self.Theme.Accent
    console.Font = Enum.Font.Code
    console.TextSize = 13
    console.TextXAlignment = 0
    console.TextYAlignment = 0

    self:Tween(c, 0.5, {GroupTransparency = 0})
    self:Tween(logo, 1, {TextTransparency = 0})
    
    local lines = {
        "> Initializing AP6_v4_Kernel...",
        "> Detecting Executor: " .. self.Executor,
        "> Bypassing Memory Integrity...",
        "> Finalizing User Interface...",
        "> ACCESS GRANTED."
    }
    
    local ct = ""
    for _, line in ipairs(lines) do
        ct = ct .. line .. "\n"
        console.Text = ct
        task.wait(0.3)
    end
    
    task.wait(0.5)
    self:Tween(c, 0.8, {GroupTransparency = 1})
    task.wait(0.8)
    g:Destroy()
    cb()
end

function AP6:Init(games)
    self:Boot(function()
        self:Confetti()
        self:Notify("SECURITY", "System Initialized as " .. self.Executor, 4)

        local g = Instance.new("ScreenGui", PlayerGui)
        g.Name = "AP6_MAIN"
        
        local m = Instance.new("CanvasGroup", g)
        m.Size = UDim2.new(0, 580, 0, 380)
        m.Position = UDim2.new(0.5, -290, 0.5, -190)
        m.BackgroundColor3 = self.Theme.Main
        m.GroupTransparency = 1
        Instance.new("UICorner", m).CornerRadius = UDim.new(0, 8)
        local ms = Instance.new("UIStroke", m)
        ms.Color = self.Theme.Outline
        ms.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local tb = Instance.new("Frame", m)
        tb.Size = UDim2.new(1, 0, 0, 35)
        tb.BackgroundColor3 = self.Theme.Secondary
        tb.BorderSizePixel = 0

        local tit = Instance.new("TextLabel", tb)
        tit.Size = UDim2.new(1, -100, 1, 0)
        tit.Position = UDim2.new(0, 15, 0, 0)
        tit.BackgroundTransparency = 1
        tit.Text = "AP6 HUB // " .. self.Executor:upper()
        tit.TextColor3 = self.Theme.Cyan
        tit.Font = Enum.Font.Code
        tit.TextSize = 12
        tit.TextXAlignment = 0

        local close = Instance.new("TextButton", tb)
        close.Size = UDim2.new(0, 35, 0, 35)
        close.Position = UDim2.new(1, -35, 0, 0)
        close.Text = "X"
        close.BackgroundColor3 = self.Theme.Red
        close.TextColor3 = Color3.new(1,1,1)
        close.BorderSizePixel = 0

        local min = Instance.new("TextButton", tb)
        min.Size = UDim2.new(0, 35, 0, 35)
        min.Position = UDim2.new(1, -70, 0, 0)
        min.Text = "-"
        min.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        min.TextColor3 = Color3.new(1,1,1)
        min.BorderSizePixel = 0

        local sc = Instance.new("ScrollingFrame", m)
        sc.Size = UDim2.new(1, -20, 1, -55)
        sc.Position = UDim2.new(0, 10, 0, 45)
        sc.BackgroundTransparency = 1
        sc.ScrollBarThickness = 0
        local ly = Instance.new("UIListLayout", sc)
        ly.Padding = UDim.new(0, 8)

        for id, data in pairs(games) do
            local active = (tonumber(id) == game.PlaceId)
            local item = Instance.new("Frame", sc)
            item.Size = UDim2.new(1, -10, 0, 50)
            item.BackgroundColor3 = self.Theme.Secondary
            Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
            local itms = Instance.new("UIStroke", item)
            itms.Color = active and self.Theme.Accent or self.Theme.Outline

            local label = Instance.new("TextLabel", item)
            label.Size = UDim2.new(1, -130, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = data.name:upper()
            label.TextColor3 = active and Color3.new(1,1,1) or Color3.fromRGB(120, 120, 130)
            label.Font = Enum.Font.Code
            label.TextSize = 12
            label.TextXAlignment = 0

            local btn = Instance.new("TextButton", item)
            btn.Size = UDim2.new(0, 100, 0, 30)
            btn.Position = UDim2.new(1, -110, 0.5, -15)
            btn.BackgroundColor3 = active and self.Theme.Accent or Color3.fromRGB(25, 25, 30)
            btn.Text = active and "EXECUTE" or "LOCKED"
            btn.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(80, 80, 80)
            btn.Font = Enum.Font.Code
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            btn.MouseButton1Click:Connect(function()
                if active then
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                else
                    self:Notify("ERROR", "Invalid Environment ID", 3)
                end
            end)
        end

        local isMin = false
        min.MouseButton1Click:Connect(function()
            isMin = not isMin
            self:Tween(m, 0.5, {Size = isMin and UDim2.new(0, 580, 0, 35) or UDim2.new(0, 580, 0, 380)})
            sc.Visible = not isMin
        end)

        close.MouseButton1Click:Connect(function()
            self:Tween(m, 0.5, {GroupTransparency = 1}):Completed:Wait()
            g:Destroy()
        end)

        
        local drag, start, pos
        tb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pos = m.Position end end)
        UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - start
            m.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

        self:Tween(m, 0.6, {GroupTransparency = 0})
    end)
end

return AP6
