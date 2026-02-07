local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(2, 2, 4),
        Secondary = Color3.fromRGB(5, 5, 8),
        Terminal = Color3.fromRGB(0, 255, 100),
        Accent = Color3.fromRGB(0, 255, 150),
        Red = Color3.fromRGB(255, 40, 40),
        Dark = Color3.fromRGB(10, 10, 15),
        Outline = Color3.fromRGB(30, 30, 35),
        Font = Enum.Font.Code
    },
    Rainbow = Color3.new(1, 1, 1)
}

task.spawn(function()
    local h = 0
    while true do
        h = h + 0.0015
        if h > 1 then h = 0 end
        AP6.Rainbow = Color3.fromHSV(h, 0.8, 1)
        RunService.RenderStepped:Wait()
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

function AP6:ApplyGlitch(obj)
    task.spawn(function()
        while obj and obj.Parent do
            task.wait(math.random(2, 8))
            for i = 1, math.random(2, 5) do
                local offset = UDim2.new(0, math.random(-4, 4), 0, math.random(-4, 4))
                obj.Position = obj.Position + offset
                task.wait(0.05)
                obj.Position = obj.Position - offset
            end
        end
    end)
end

function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local g = PlayerGui:FindFirstChild("AP6_NOTIF") or Create("ScreenGui", {Name = "AP6_NOTIF", IgnoreGuiInset = true}, PlayerGui)
        local h = g:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.new(0, 320, 1, -40), Position = UDim2.new(1, -330, 0, 20), BackgroundTransparency = 1}, g)
        if not h:FindFirstChild("Layout") then Create("UIListLayout", {Name = "Layout", VerticalAlignment = 2, Padding = UDim.new(0, 12)}, h) end

        local card = Create("CanvasGroup", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = self.Theme.Dark, GroupTransparency = 1, Position = UDim2.new(2, 0, 0, 0)}, h)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
        local stroke = Create("UIStroke", {Thickness = 2, Color = self.Rainbow}, card)
        
        task.spawn(function() while card.Parent do stroke.Color = self.Rainbow RunService.RenderStepped:Wait() end end)

        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = "SYSTEM :: " .. title:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, card)
        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 35), BackgroundTransparency = 1, Text = msg, TextColor3 = Color3.fromRGB(200, 200, 200), Font = self.Theme.Font, TextSize = 11, TextXAlignment = 0, TextWrapped = true}, card)

        self:Tween(card, 0.6, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
        task.wait(dur or 4)
        self:Tween(card, 0.6, {GroupTransparency = 1, Position = UDim2.new(2, 0, 0, 0)}).Completed:Wait()
        card:Destroy()
    end)
end

function AP6:Boot(cb)
    local g = Create("ScreenGui", {Name = "AP6_BOOT", IgnoreGuiInset = true, DisplayOrder = 999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0)}, g)
    
    local cmd = Create("ScrollingFrame", {Size = UDim2.new(1, -60, 0.5, 0), Position = UDim2.new(0, 30, 0.05, 0), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,20,0), ScrollBarThickness = 0}, c)
    Create("UIListLayout", {VerticalAlignment = 2, Padding = UDim.new(0, 2)}, cmd)

    local logo = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0.5, -60), BackgroundTransparency = 1, Text = "AP6 HUB", TextColor3 = self.Rainbow, Font = self.Theme.Font, TextSize = 140, TextTransparency = 1, TextScaled = true}, c)
    
    task.spawn(function()
        local logs = {"root@ap6:~$ dir /s C:\\WINDOWS\\SYSTEM32", "Reading package lists...", "Injecting kernel payloads...", "Status: 200 OK", "Bypass successful..."}
        for i = 1, 100 do
            local text = logs[math.random(1,#logs)] .. " [" .. i .. "]"
            Create("TextLabel", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = text, TextColor3 = self.Theme.Terminal, Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, cmd)
            cmd.CanvasPosition = Vector2.new(0, cmd.AbsoluteCanvasSize.Y)
            task.wait(0.02)
        end
    end)

    task.spawn(function() while c.Parent do logo.TextColor3 = self.Rainbow task.wait() end end)
    self:Tween(logo, 1.2, {TextTransparency = 0})
    task.wait(3)

    for i = 1, 15 do
        c.Position = UDim2.new(0, math.random(-20, 20), 0, math.random(-20, 20))
        task.wait(0.02)
    end
    
    g:Destroy()
    cb()
end

function AP6:Init(games)
    self:Boot(function()
        local main = Create("ScreenGui", {Name = "AP6_UNI_V12"}, PlayerGui)
        local frame = Create("Frame", {Size = UDim2.new(0, 750, 0, 480), Position = UDim2.new(0.5, -375, 0.5, -240), BackgroundColor3 = self.Theme.Main, ClipsDescendants = true}, main)
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}, frame) -- REDONDEADO REAL
        
        local stroke = Create("UIStroke", {Thickness = 3, Color = self.Rainbow}, frame)
        task.spawn(function() while frame.Parent do stroke.Color = self.Rainbow RunService.RenderStepped:Wait() end end)

        local inner = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1}, frame)
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}, inner)

        local bg = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, inner)
        for i = 1, 15 do
            task.spawn(function()
                while bg.Parent do
                    local drop = Create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1, Text = string.char(math.random(33, 126)), TextColor3 = self.Theme.Terminal, TextTransparency = 0.8, Font = self.Theme.Font, TextSize = 10}, bg)
                    AP6:Tween(drop, math.random(2, 5), {Position = UDim2.new(drop.Position.X.Scale, 0, 1.1, 0)}).Completed:Connect(function() drop:Destroy() end)
                    task.wait(0.2)
                end
            end)
        end

        local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = self.Theme.Dark, BorderSizePixel = 0}, inner)
        Create("Frame", {Name = "Separator", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.Theme.Outline, BorderSizePixel = 0}, top)
        
        Create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = "AP6 HUB // UNIVERSAL HUB [v12.0]", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, top)

        local close = Create("TextButton", {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -42, 0.5, -16), Text = "×", BackgroundColor3 = self.Theme.Red, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Code, TextSize = 26, AutoButtonColor = false}, top)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, close)

        local sidebar = Create("Frame", {Size = UDim2.new(0, 200, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(4, 4, 6), BorderSizePixel = 0}, inner)
        Create("Frame", {Name = "Separator", Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = self.Theme.Outline, BorderSizePixel = 0}, sidebar)
        
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Text = "Key System:\nComing Soon", TextColor3 = Color3.fromRGB(120, 120, 130), Font = self.Theme.Font, TextSize = 15}, sidebar)

        local legHolder = Create("Frame", {Size = UDim2.new(1, -40, 0, 200), Position = UDim2.new(0, 20, 0, 80), BackgroundTransparency = 1}, sidebar)
        Create("UIListLayout", {Padding = UDim.new(0, 15)}, legHolder)

        local function AddL(c, t)
            local r = Create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, legHolder)
            local d = Create("Frame", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0.5, -5), BackgroundColor3 = c, BorderSizePixel = 0}, r)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            Create("TextLabel", {Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Text = t, TextColor3 = Color3.fromRGB(180, 180, 180), Font = self.Theme.Font, TextSize = 11, TextXAlignment = 0}, r)
        end
        AddL(self.Theme.Accent, "🟢 ONLINE")
        AddL(self.Theme.Red, "🔴 OFFLINE")

        local container = Create("ScrollingFrame", {Size = UDim2.new(1, -240, 1, -85), Position = UDim2.new(0, 220, 0, 65), BackgroundTransparency = 1, ScrollBarThickness = 0}, inner)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, container)

        for id, data in pairs(games) do
            local isCurrent = (tonumber(id) == game.PlaceId)
            local card = Create("Frame", {Size = UDim2.new(1, -10, 0, 75), BackgroundColor3 = self.Theme.Secondary}, container)
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card)
            local cs = Create("UIStroke", {Thickness = 1.5, Color = isCurrent and self.Rainbow or self.Theme.Outline}, card)
            if isCurrent then task.spawn(function() while card.Parent do cs.Color = self.Rainbow RunService.RenderStepped:Wait() end end) end

            Create("TextLabel", {Size = UDim2.new(1, -180, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = data.name:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, card)
            local btn = Create("TextButton", {Size = UDim2.new(0, 110, 0, 35), Position = UDim2.new(1, -125, 0.5, -17), BackgroundColor3 = isCurrent and Color3.new(1,1,1) or Color3.fromRGB(25, 25, 30), Text = isCurrent and "EXECUTE" or "LOCKED", TextColor3 = Color3.new(0,0,0), Font = self.Theme.Font, TextSize = 12}, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
            
            if isCurrent then
                task.spawn(function() while btn.Parent do btn.BackgroundColor3 = self.Rainbow RunService.RenderStepped:Wait() end end)
                btn.MouseButton1Click:Connect(function()
                    if data.url then loadstring(game:HttpGet(data.url))() end
                    if data.onExecute then data.onExecute() end
                end)
            end
        end

        close.MouseButton1Click:Connect(function() main:Destroy() end)

        local d, s, p
        top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = i.Position p = frame.Position end end)
        UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - s
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
        
        self:ApplyGlitch(inner)
    end)
end

return AP6
