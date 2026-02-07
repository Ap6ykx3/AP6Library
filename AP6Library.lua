local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(2, 2, 3),
        Secondary = Color3.fromRGB(7, 7, 10),
        Accent = Color3.fromRGB(0, 255, 150),
        Red = Color3.fromRGB(255, 50, 70),
        Orange = Color3.fromRGB(255, 150, 0),
        Outline = Color3.fromRGB(25, 25, 30),
        Text = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Code
    },
    Rainbow = Color3.new(1, 1, 1)
}

task.spawn(function()
    local h = 0
    while true do
        h = h + 0.002
        if h > 1 then h = 0 end
        AP6.Rainbow = Color3.fromHSV(h, 0.8, 1)
        task.wait()
    end
end)

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

function AP6:Tween(obj, time, goal, style)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

function AP6:Sfx(id)
    task.spawn(function()
        local s = Create("Sound", {SoundId = "rbxassetid://"..tostring(id), Volume = 0.5, Parent = SoundService})
        s:Play()
        s.Ended:Wait()
        s:Destroy()
    end)
end

function AP6:ApplyGlitch(obj)
    task.spawn(function()
        while obj.Parent do
            task.wait(math.random(5, 15))
            for i = 1, 5 do
                local off = UDim2.new(0, math.random(-3, 3), 0, math.random(-3, 3))
                obj.Position = obj.Position + off
                task.wait(0.05)
                obj.Position = obj.Position - off
            end
        end
    end)
end

function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local g = PlayerGui:FindFirstChild("AP6_N") or Create("ScreenGui", {Name = "AP6_N", IgnoreGuiInset = true}, PlayerGui)
        local h = g:FindFirstChild("H") or Create("Frame", {Name = "H", Size = UDim2.new(0, 280, 1, -40), Position = UDim2.new(1, -290, 0, 20), BackgroundTransparency = 1}, g)
        if not h:FindFirstChild("L") then Create("UIListLayout", {Name = "L", VerticalAlignment = 2, Padding = UDim.new(0, 8)}, h) end

        local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 0, 65), BackgroundColor3 = self.Theme.Secondary, GroupTransparency = 1}, h)
        Create("UICorner", {CornerRadius = UDim.new(0, 2)}, c)
        local s = Create("UIStroke", {Thickness = 2}, c)
        
        task.spawn(function()
            while c.Parent do s.Color = self.Rainbow task.wait() end
        end)

        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = "> " .. title:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 13, TextXAlignment = 0}, c)
        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = msg, TextColor3 = Color3.fromRGB(180,180,180), Font = self.Theme.Font, TextSize = 10, TextXAlignment = 0, TextWrapped = true}, c)

        self:Sfx(6543431344)
        self:Tween(c, 0.4, {GroupTransparency = 0})
        task.wait(dur or 4)
        self:Tween(c, 0.4, {GroupTransparency = 1}).Completed:Wait()
        c:Destroy()
    end)
end

function AP6:Boot(cb)
    local g = Create("ScreenGui", {IgnoreGuiInset = true, DisplayOrder = 999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0)}, g)
    
    local lines = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1}, c)
    for i = 1, 30 do
        Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, i/30, 0), BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.97, BorderSizePixel = 0}, lines)
    end

    local logo = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 100), Position = UDim2.new(0, 0, 0.5, -50), BackgroundTransparency = 1, Text = "AP6 HUB", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 110, TextTransparency = 1}, c)
    local bar = Create("Frame", {Size = UDim2.new(0, 0, 0, 1), Position = UDim2.new(0.5, 0, 0.5, 60), BackgroundColor3 = self.Rainbow, BorderSizePixel = 0}, c)
    
    task.spawn(function()
        while c.Parent do
            logo.TextColor3 = self.Rainbow
            bar.BackgroundColor3 = self.Rainbow
            task.wait()
        end
    end)

    self:Sfx(1324546452)
    self:Tween(logo, 1.5, {TextTransparency = 0, Position = UDim2.new(0, 0, 0.48, -50)})
    self:Tween(bar, 3, {Size = UDim2.new(0, 400, 0, 1), Position = UDim2.new(0.5, -200, 0.5, 60)})
    task.wait(3.5)

    self:Sfx(5236242203)
    self:Tween(c, 0.8, {GroupTransparency = 1, Size = UDim2.new(1.1, 0, 1.1, 0), Position = UDim2.new(-0.05, 0, -0.05, 0)}).Completed:Wait()
    g:Destroy()
    cb()
end

function AP6:Init(games)
    self:Boot(function()
        local main = Create("ScreenGui", {Name = "AP6_UNI"}, PlayerGui)
        local frame = Create("CanvasGroup", {Size = UDim2.new(0, 700, 0, 440), Position = UDim2.new(0.5, -350, 0.5, -220), BackgroundColor3 = self.Theme.Main, GroupTransparency = 1}, main)
        Create("UICorner", {CornerRadius = UDim.new(0, 2)}, frame)
        local stroke = Create("UIStroke", {Thickness = 2}, frame)

        task.spawn(function()
            while frame.Parent do stroke.Color = self.Rainbow task.wait() end
        end)

        local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = self.Theme.Secondary, BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = "AP6 HUB // UNIVERSAL HUB", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 13, TextXAlignment = 0}, top)

        local close = Create("TextButton", {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -40, 0, 0), Text = "X", BackgroundColor3 = self.Theme.Red, TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 16, BorderSizePixel = 0, AutoButtonColor = false}, top)
        local min = Create("TextButton", {Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(1, -80, 0, 0), Text = "—", BackgroundColor3 = self.Theme.Outline, TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 16, BorderSizePixel = 0, AutoButtonColor = false}, top)

        local sidebar = Create("Frame", {Size = UDim2.new(0, 180, 1, -40), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(5, 5, 8), BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 10), BackgroundTransparency = 1, Text = "Nan", TextColor3 = Color3.fromRGB(80,80,80), Font = self.Theme.Font, TextSize = 14}, sidebar)

        local leg = Create("Frame", {Size = UDim2.new(1, -30, 0, 150), Position = UDim2.new(0, 15, 0, 50), BackgroundTransparency = 1}, sidebar)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, leg)

        local function Add(c, t)
            local r = Create("Frame", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1}, leg)
            local d = Create("Frame", {Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 0, 0.5, -4), BackgroundColor3 = c, BorderSizePixel = 0}, r)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            Create("TextLabel", {Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = t, TextColor3 = Color3.fromRGB(150,150,150), Font = self.Theme.Font, TextSize = 10, TextXAlignment = 0}, r)
        end

        Add(self.Theme.Accent, "🟢 ONLINE")
        Add(self.Theme.Red, "🔴 OFFLINE")
        Add(self.Theme.Orange, "🟠 PATCH")

        local scroll = Create("ScrollingFrame", {Size = UDim2.new(1, -210, 1, -70), Position = UDim2.new(0, 195, 0, 55), BackgroundTransparency = 1, ScrollBarThickness = 0}, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 10)}, scroll)

        for id, data in pairs(games) do
            local cur = (tonumber(id) == game.PlaceId)
            local col = cur and self.Theme.Accent or (data.Maintenance and self.Theme.Orange or self.Theme.Red)
            
            local card = Create("Frame", {Size = UDim2.new(1, -10, 0, 65), BackgroundColor3 = self.Theme.Secondary}, scroll)
            Create("UICorner", {CornerRadius = UDim.new(0, 2)}, card)
            Create("UIStroke", {Color = self.Theme.Outline, Thickness = 1}, card)

            local d = Create("Frame", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 15, 0.5, -5), BackgroundColor3 = col, BorderSizePixel = 0}, card)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            
            if cur then
                task.spawn(function()
                    while d.Parent do
                        self:Tween(d, 0.6, {BackgroundTransparency = 0.5}).Completed:Wait()
                        self:Tween(d, 0.6, {BackgroundTransparency = 0}).Completed:Wait()
                    end
                end)
            end

            Create("TextLabel", {Size = UDim2.new(1, -170, 1, 0), Position = UDim2.new(0, 40, 0, 0), BackgroundTransparency = 1, Text = data.name:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 13, TextXAlignment = 0}, card)

            local btn = Create("TextButton", {Size = UDim2.new(0, 100, 0, 32), Position = UDim2.new(1, -115, 0.5, -16), BackgroundColor3 = cur and Color3.new(1,1,1) or Color3.fromRGB(20,20,25), Text = cur and "EXECUTE" or "LOCKED", TextColor3 = Color3.new(0,0,0), Font = self.Theme.Font, TextSize = 11}, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 2)}, btn)
            
            if cur then
                task.spawn(function()
                    while btn.Parent do btn.BackgroundColor3 = self.Rainbow task.wait() end
                end)
            end

            btn.MouseButton1Click:Connect(function()
                if cur then
                    self:Sfx(12222242)
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                end
            end)
        end

        self:Tween(frame, 0.6, {GroupTransparency = 0})
        self:ApplyGlitch(frame)

        local isM = false
        min.MouseButton1Click:Connect(function()
            isM = not isM
            self:Tween(frame, 0.5, {Size = isM and UDim2.new(0, 700, 0, 40) or UDim2.new(0, 700, 0, 440)})
            scroll.Visible = not isM
            sidebar.Visible = not isM
        end)

        close.MouseButton1Click:Connect(function()
            self:Sfx(1324546452)
            self:Tween(frame, 0.6, {GroupTransparency = 1, Size = UDim2.new(0, 650, 0, 400)}).Completed:Wait()
            main:Destroy()
        end)

        local dr, st, ps
        top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dr = true st = i.Position ps = frame.Position end end)
        UserInputService.InputChanged:Connect(function(i) if dr and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - st
            frame.Position = UDim2.new(ps.X.Scale, ps.X.Offset + delta.X, ps.Y.Scale, ps.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dr = false end end)
    end)
end

return AP6
