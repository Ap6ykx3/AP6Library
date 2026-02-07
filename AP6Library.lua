local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(2, 2, 4),
        Secondary = Color3.fromRGB(5, 5, 8),
        Terminal = Color3.fromRGB(0, 255, 100),
        Accent = Color3.fromRGB(0, 255, 150),
        Red = Color3.fromRGB(255, 45, 65),
        Dark = Color3.fromRGB(10, 10, 15),
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

function AP6:Sfx(id, vol)
    task.spawn(function()
        local s = Create("Sound", {SoundId = "rbxassetid://"..tostring(id), Volume = vol or 0.5, Parent = SoundService})
        s:Play()
        s.Ended:Wait()
        s:Destroy()
    end)
end


function AP6:ApplyGlitch(obj)
    task.spawn(function()
        while obj and obj.Parent do
            task.wait(math.random(2, 8))
            for i = 1, math.random(2, 5) do
                local off = UDim2.new(0, math.random(-4, 4), 0, math.random(-4, 4))
                obj.Position = obj.Position + off
                if obj:IsA("CanvasGroup") then obj.GroupTransparency = 0.2 end
                task.wait(0.05)
                obj.Position = obj.Position - off
                if obj:IsA("CanvasGroup") then obj.GroupTransparency = 0 end
            end
        end
    end)
end


function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local g = PlayerGui:FindFirstChild("AP6_N") or Create("ScreenGui", {Name = "AP6_N", IgnoreGuiInset = true}, PlayerGui)
        local h = g:FindFirstChild("H") or Create("Frame", {Name = "H", Size = UDim2.new(0, 300, 1, -40), Position = UDim2.new(1, -310, 0, 20), BackgroundTransparency = 1}, g)
        if not h:FindFirstChild("L") then Create("UIListLayout", {Name = "L", VerticalAlignment = 2, Padding = UDim.new(0, 10)}, h) end

        local card = Create("CanvasGroup", {Size = UDim2.new(1, 0, 0, 75), BackgroundColor3 = self.Theme.Dark, GroupTransparency = 1, Position = UDim2.new(1.5, 0, 0, 0)}, h)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
        local s = Create("UIStroke", {Thickness = 2, Color = self.Rainbow}, card)
        
        task.spawn(function() while card.Parent do s.Color = self.Rainbow task.wait() end end)

        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = ">> "..title:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 13, TextXAlignment = 0}, card)
        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 35), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = msg, TextColor3 = Color3.fromRGB(180,180,180), Font = self.Theme.Font, TextSize = 10, TextXAlignment = 0, TextWrapped = true}, card)

        self:Sfx(6543431344)
        self:Tween(card, 0.6, {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)})
        task.wait(dur or 4)
    
        self:Tween(card, 0.6, {GroupTransparency = 1, Position = UDim2.new(1.8, 0, 0, 0)}).Completed:Wait()
        card:Destroy()
    end)
end

-- [ BOOT: eDex-UI TERMINAL (FULL VERSION) ]
function AP6:Boot(cb)
    local g = Create("ScreenGui", {IgnoreGuiInset = true, DisplayOrder = 999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0)}, g)
    
    local cmd = Create("ScrollingFrame", {Size = UDim2.new(1, -60, 0.45, 0), Position = UDim2.new(0, 30, 0.05, 0), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,20,0), ScrollBarThickness = 0}, c)
    Create("UIListLayout", {VerticalAlignment = 2, Padding = UDim.new(0, 2)}, cmd)

    local logo = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 100), Position = UDim2.new(0, 0, 0.5, -50), BackgroundTransparency = 1, Text = "AP6 HUB", TextColor3 = self.Rainbow, Font = self.Theme.Font, TextSize = 140, TextTransparency = 1, TextScaled = true}, c)
    local sub = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0.5, 60), BackgroundTransparency = 1, Text = "ESTABLISHING SECURE CONNECTION...", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 16, TextTransparency = 1}, c)

    task.spawn(function()
        local logs = {"sudo apt-get install bypass", "connecting to server...", "injecting payloads...", "dir /s system32", "0x00FF - SUCCESS"}
        for i = 1, 100 do
            Create("TextLabel", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "root@ap6:~$ " .. logs[math.random(1,#logs)] .. " ["..i.."]", TextColor3 = self.Theme.Terminal, Font = self.Theme.Font, TextSize = 12, TextXAlignment = 0}, cmd)
            cmd.CanvasPosition = Vector2.new(0, cmd.AbsoluteCanvasSize.Y)
            task.wait(0.02)
        end
    end)

    task.spawn(function() while c.Parent do logo.TextColor3 = self.Rainbow sub.TextColor3 = self.Rainbow task.wait() end end)

    self:Sfx(1324546452)
    self:Tween(logo, 1.5, {TextTransparency = 0})
    self:Tween(sub, 1.5, {TextTransparency = 0})
    task.wait(3)

    self:Sfx(5236242203)
    self:Tween(logo, 0.6, {TextTransparency = 1, Size = UDim2.new(1.8, 0, 1.8, 0)})
    self:Tween(sub, 0.6, {TextTransparency = 1})
    self:Tween(c, 0.8, {GroupTransparency = 1}).Completed:Wait()
    g:Destroy()
    cb()
end


function AP6:Init(games)
    self:Boot(function()
        local main = Create("ScreenGui", {Name = "AP6_UNI_V9"}, PlayerGui)
        local frame = Create("CanvasGroup", {Size = UDim2.new(0, 750, 0, 480), Position = UDim2.new(0.5, -375, 0.5, -240), BackgroundColor3 = self.Theme.Main, GroupTransparency = 1}, main)
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}, frame)
        local stroke = Create("UIStroke", {Thickness = 3, Color = self.Rainbow}, frame)

        task.spawn(function() while frame.Parent do stroke.Color = self.Rainbow task.wait() end end)

       
        local bg = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, frame)
        for i = 1, 12 do
            task.spawn(function()
                while bg.Parent do
                    local d = Create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1, Text = string.char(math.random(33, 126)), TextColor3 = self.Theme.Terminal, TextTransparency = 0.85, Font = self.Theme.Font, TextSize = 10}, bg)
                    AP6:Tween(d, math.random(3, 7), {Position = UDim2.new(d.Position.X.Scale, 0, 1.1, 0)}).Completed:Connect(function() d:Destroy() end)
                    task.wait(0.25)
                end
            end)
        end

        local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = self.Theme.Dark, BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = "AP6 HUB // UNIVERSAL HUB [v9.8]", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, top)

      
        local close = Create("TextButton", {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -42, 0.5, -16), Text = "×", BackgroundColor3 = self.Theme.Red, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Code, TextSize = 24, AutoButtonColor = false}, top)
        Create("UICorner", {CornerRadius = UDim.new(1, 0)}, close)

        local sidebar = Create("Frame", {Size = UDim2.new(0, 200, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(4, 4, 6), BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Text = "Nan", TextColor3 = Color3.fromRGB(100, 100, 110), Font = self.Theme.Font, TextSize = 18}, sidebar)

        local container = Create("ScrollingFrame", {Size = UDim2.new(1, -230, 1, -80), Position = UDim2.new(0, 215, 0, 60), BackgroundTransparency = 1, ScrollBarThickness = 0}, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, container)

        for id, data in pairs(games) do
            local isCur = (tonumber(id) == game.PlaceId)
            local card = Create("Frame", {Size = UDim2.new(1, -10, 0, 75), BackgroundColor3 = self.Theme.Secondary}, container)
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card) -- ROUNDED CARDS
            local s = Create("UIStroke", {Thickness = 1.5, Color = isCur and self.Rainbow or self.Theme.Outline}, card)
            if isCur then task.spawn(function() while card.Parent do s.Color = self.Rainbow task.wait() end end) end

            Create("TextLabel", {Size = UDim2.new(1, -160, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = data.name:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 13, TextXAlignment = 0}, card)

            local btn = Create("TextButton", {Size = UDim2.new(0, 110, 0, 35), Position = UDim2.new(1, -125, 0.5, -17.5), BackgroundColor3 = isCur and Color3.new(1,1,1) or Color3.fromRGB(25, 25, 30), Text = isCur and "EXECUTE" or "LOCKED", TextColor3 = Color3.new(0,0,0), Font = self.Theme.Font, TextSize = 12}, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}, btn) -- ROUNDED BUTTONS
            
            if isCur then
                task.spawn(function() while btn.Parent do btn.BackgroundColor3 = self.Rainbow task.wait() end end)
                btn.MouseButton1Click:Connect(function()
                    self:Sfx(12222242)
                    if data.url then loadstring(game:HttpGet(data.url))() end
                    if data.onExecute then data.onExecute() end
                end)
            end
        end

        self:Tween(frame, 0.7, {GroupTransparency = 0})
        self:ApplyGlitch(frame)

        close.MouseButton1Click:Connect(function()
            self:Sfx(1324546452)
            self:Tween(frame, 0.5, {GroupTransparency = 1, Size = UDim2.new(0, 650, 0, 400)}).Completed:Wait()
            main:Destroy()
        end)

       
        local d, s, p
        top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true s = i.Position p = frame.Position end end)
        UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - s
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
    end)
end

return AP6
