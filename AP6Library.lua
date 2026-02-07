local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(10, 10, 12),
        Secondary = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 60, 60),
        Outline = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Executor = (identifyexecutor and identifyexecutor()) or "Unknown Executor"
}

function AP6:Tween(obj, time, goal)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

function AP6:Confetti()
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_CONFETTI"
    for i = 1, 50 do
        task.spawn(function()
            local p = Instance.new("Frame", gui)
            p.Size = UDim2.new(0, math.random(5,10), 0, math.random(5,10))
            p.Position = UDim2.new(math.random(), 0, -0.1, 0)
            p.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
            p.BorderSizePixel = 0
            p.Rotation = math.random(0, 360)
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            
            local t = self:Tween(p, math.random(2, 4), {
                Position = UDim2.new(p.Position.X.Scale, math.random(-100, 100), 1.1, 0),
                Rotation = math.random(0, 1000)
            })
            t.Completed:Wait()
            p:Destroy()
        end)
    end
    task.delay(5, function() gui:Destroy() end)
end

function AP6:Notify(title, msg, dur)
    dur = dur or 3
    local g = PlayerGui:FindFirstChild("AP6_NOTIF") or Instance.new("ScreenGui", PlayerGui)
    g.Name = "AP6_NOTIF"
    
    local h = g:FindFirstChild("H") or Instance.new("Frame", g)
    h.Name = "H" h.Size = UDim2.new(0, 300, 1, 0) h.Position = UDim2.new(1, -310, 0, 0) h.BackgroundTransparency = 1
    if not h:FindFirstChild("L") then 
        local l = Instance.new("UIListLayout", h) l.VerticalAlignment = Enum.VerticalAlignment.Bottom l.Padding = UDim.new(0, 8)
    end

    local c = Instance.new("CanvasGroup", h)
    c.Size = UDim2.new(1, 0, 0, 70) c.BackgroundColor3 = self.Theme.Secondary c.GroupTransparency = 1
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", c) s.Color = self.Theme.Accent s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local tl = Instance.new("TextLabel", c)
    tl.Size = UDim2.new(1, -20, 0, 30) tl.Position = UDim2.new(0, 12, 0, 5) tl.BackgroundTransparency = 1
    tl.Text = title:upper() tl.TextColor3 = self.Theme.Accent tl.Font = Enum.Font.Code tl.TextSize = 14 tl.TextXAlignment = 0

    local dl = Instance.new("TextLabel", c)
    dl.Size = UDim2.new(1, -20, 0, 30) dl.Position = UDim2.new(0, 12, 0, 30) dl.BackgroundTransparency = 1
    dl.Text = msg tl.TextColor3 = Color3.new(1,1,1) dl.Font = Enum.Font.Code dl.TextSize = 12 dl.TextXAlignment = 0

    self:Tween(c, 0.5, {GroupTransparency = 0})
    task.delay(dur, function()
        self:Tween(c, 0.5, {GroupTransparency = 1}):Completed:Wait()
        c:Destroy()
    end)
end

function AP6:Boot(cb)
    local g = Instance.new("ScreenGui", PlayerGui)
    local c = Instance.new("CanvasGroup", g)
    c.Size = UDim2.new(1, 0, 1, 0) c.BackgroundColor3 = Color3.new(0,0,0) c.GroupTransparency = 0
    
    local l = Instance.new("TextLabel", c)
    l.Size = UDim2.new(0, 400, 0, 100) l.Position = UDim2.new(0.5, -200, 0.45, -50) l.BackgroundTransparency = 1
    l.Text = "AP6_CORE" l.TextColor3 = self.Theme.Cyan l.Font = Enum.Font.Code l.TextSize = 80 l.TextTransparency = 1

    local bar = Instance.new("Frame", c)
    bar.Size = UDim2.new(0, 0, 0, 2) bar.Position = UDim2.new(0.5, -150, 0.55, 0) bar.BackgroundColor3 = self.Theme.Accent bar.BorderSizePixel = 0

    self:Tween(l, 1.5, {TextTransparency = 0})
    self:Tween(bar, 2, {Size = UDim2.new(0, 300, 0, 2)})
    task.wait(2.5)
    self:Tween(c, 1, {GroupTransparency = 1})
    task.wait(1)
    g:Destroy()
    cb()
end

function AP6:Init(games)
    self:Boot(function()
        self:Confetti()
        self:Notify("SYSTEM", "User Verified: " .. Player.Name, 4)
        
        local g = Instance.new("ScreenGui", PlayerGui)
        g.Name = "AP6_HUB"
        
        local m = Instance.new("CanvasGroup", g)
        m.Size = UDim2.new(0, 600, 0, 400) m.Position = UDim2.new(0.5, -300, 0.5, -200)
        m.BackgroundColor3 = self.Theme.Main m.GroupTransparency = 1
        Instance.new("UICorner", m).CornerRadius = UDim.new(0, 10)
        local ms = Instance.new("UIStroke", m) ms.Color = self.Theme.Outline ms.Thickness = 1 ms.ApplyStrokeMode = 1

        local tb = Instance.new("Frame", m)
        tb.Size = UDim2.new(1, 0, 0, 40) tb.BackgroundColor3 = self.Theme.Secondary tb.BorderSizePixel = 0
        
        local tit = Instance.new("TextLabel", tb)
        tit.Size = UDim2.new(1, -150, 1, 0) tit.Position = UDim2.new(0, 15, 0, 0) tit.BackgroundTransparency = 1
        tit.Text = "AP6 HUB // " .. self.Executor tit.TextColor3 = self.Theme.Cyan tit.Font = Enum.Font.Code tit.TextSize = 14 tit.TextXAlignment = 0

        local close = Instance.new("TextButton", tb)
        close.Size = UDim2.new(0, 40, 0, 40) close.Position = UDim2.new(1, -40, 0, 0) close.Text = "X"
        close.BackgroundColor3 = self.Theme.Red close.TextColor3 = Color3.new(1,1,1) close.Font = Enum.Font.Code close.BorderSizePixel = 0

        local min = Instance.new("TextButton", tb)
        min.Size = UDim2.new(0, 40, 0, 40) min.Position = UDim2.new(1, -80, 0, 0) min.Text = "-"
        min.BackgroundColor3 = self.Theme.Outline min.TextColor3 = Color3.new(1,1,1) min.Font = Enum.Font.Code min.BorderSizePixel = 0

        local sc = Instance.new("ScrollingFrame", m)
        sc.Size = UDim2.new(1, -30, 1, -60) sc.Position = UDim2.new(0, 15, 0, 50) sc.BackgroundTransparency = 1 sc.ScrollBarThickness = 0
        local ly = Instance.new("UIListLayout", sc) ly.Padding = UDim.new(0, 10)

        for id, data in pairs(games) do
            local active = (tonumber(id) == game.PlaceId)
            local f = Instance.new("Frame", sc)
            f.Size = UDim2.new(1, -10, 0, 50) f.BackgroundColor3 = self.Theme.Secondary
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
            local fs = Instance.new("UIStroke", f) fs.Color = active and self.Theme.Accent or self.Theme.Outline
            
            local lab = Instance.new("TextLabel", f)
            lab.Size = UDim2.new(1, -130, 1, 0) lab.Position = UDim2.new(0, 15, 0, 0) lab.BackgroundTransparency = 1
            lab.Text = data.name:upper() lab.TextColor3 = Color3.new(1,1,1) lab.Font = Enum.Font.Code lab.TextSize = 13 lab.TextXAlignment = 0

            local btn = Instance.new("TextButton", f)
            btn.Size = UDim2.new(0, 100, 0, 30) btn.Position = UDim2.new(1, -110, 0.5, -15)
            btn.BackgroundColor3 = active and self.Theme.Accent or self.Theme.Outline
            btn.Text = active and "INJECT" or "LOCKED" btn.Font = Enum.Font.Code btn.TextSize = 12
            btn.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(100, 100, 100)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

            btn.MouseButton1Click:Connect(function()
                if active then
                    self:Notify("EXECUTING", "Applying payload to " .. data.name, 3)
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                end
            end)
        end

        local minimized = false
        min.MouseButton1Click:Connect(function()
            minimized = not minimized
            self:Tween(m, 0.5, {Size = minimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 400)})
            sc.Visible = not minimized
        end)

        close.MouseButton1Click:Connect(function()
            self:Tween(m, 0.5, {GroupTransparency = 1}):Completed:Wait()
            g:Destroy()
        end)

        local d, ds, sp
        tb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = m.Position end end)
        UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - ds
            m.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

        self:Tween(m, 0.8, {GroupTransparency = 0})
    end)
end

return AP6
