-- [[ AP6 HUB: THE ULTIMATE UNIVERSAL INTERFACE ]]
-- [[ STYLE: EDEX-UI / WINUI / CYBERPUNK ]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

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
        Font = Enum.Font.Code
    },
    Rainbow = Color3.new(1, 1, 1),
    IsLoading = true
}

-- [ RAINBOW ENGINE ]
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
        local s = Create("Sound", {SoundId = "rbxassetid://"..tostring(id), Volume = vol or 0.6, Parent = SoundService})
        s:Play()
        s.Ended:Wait()
        s:Destroy()
    end)
end

-- [ GLITCH EFFECT ]
function AP6:ApplyGlitch(obj)
    task.spawn(function()
        while obj and obj.Parent do
            task.wait(math.random(2, 8))
            for i = 1, math.random(2, 5) do
                local offset = UDim2.new(0, math.random(-4, 4), 0, math.random(-4, 4))
                obj.Position = obj.Position + offset
                if obj:IsA("TextLabel") then obj.TextTransparency = 0.5 end
                task.wait(0.05)
                obj.Position = obj.Position - offset
                if obj:IsA("TextLabel") then obj.TextTransparency = 0 end
            end
        end
    end)
end

-- [ NOTIFY SYSTEM ]
function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local g = PlayerGui:FindFirstChild("AP6_NOTIFICATION_ENGINE") or Create("ScreenGui", {Name = "AP6_NOTIFICATION_ENGINE", IgnoreGuiInset = true}, PlayerGui)
        local h = g:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.new(0, 320, 1, -40), Position = UDim2.new(1, -330, 0, 20), BackgroundTransparency = 1}, g)
        if not h:FindFirstChild("Layout") then Create("UIListLayout", {Name = "Layout", VerticalAlignment = 2, Padding = UDim.new(0, 12)}, h) end

        local card = Create("CanvasGroup", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = self.Theme.Dark, GroupTransparency = 1}, h)
        Create("UICorner", {CornerRadius = UDim.new(0, 4)}, card)
        local stroke = Create("UIStroke", {Thickness = 2, Color = self.Rainbow, ApplyStrokeMode = 1}, card)
        
        task.spawn(function()
            while card.Parent do stroke.Color = self.Rainbow RunService.RenderStepped:Wait() end
        end)

        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = "SYSTEM :: " .. title:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, card)
        Create("TextLabel", {Size = UDim2.new(1, -20, 0, 40), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, Text = msg, TextColor3 = Color3.fromRGB(200, 200, 200), Font = self.Theme.Font, TextSize = 11, TextXAlignment = 0, TextWrapped = true}, card)

        self:Sfx(6543431344, 0.4)
        self:Tween(card, 0.5, {GroupTransparency = 0})
        task.wait(dur or 4)
        self:Tween(card, 0.5, {GroupTransparency = 1}).Completed:Wait()
        card:Destroy()
    end)
end

-- [ eDex-UI TERMINAL BOOT ]
function AP6:Boot(cb)
    local g = Create("ScreenGui", {Name = "AP6_BOOTLOADER", IgnoreGuiInset = true, DisplayOrder = 999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0,0,0)}, g)
    
    local cmd = Create("ScrollingFrame", {Size = UDim2.new(1, -60, 0.5, 0), Position = UDim2.new(0, 30, 0.05, 0), BackgroundTransparency = 1, CanvasSize = UDim2.new(0,0,20,0), ScrollBarThickness = 0}, c)
    Create("UIListLayout", {VerticalAlignment = 2, Padding = UDim.new(0, 2)}, cmd)

    local logo = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 120), Position = UDim2.new(0, 0, 0.55, -60), BackgroundTransparency = 1, Text = "AP6 HUB", TextColor3 = self.Rainbow, Font = self.Theme.Font, TextSize = 140, TextTransparency = 1, TextScaled = true}, c)
    local sub = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0.55, 60), BackgroundTransparency = 1, Text = "ESTABLISHING SECURE CONNECTION...", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 16, TextTransparency = 1}, c)
    
    task.spawn(function()
        local logs = {
            "root@ap6:~$ sudo apt-get install universal_bypass",
            "Reading package lists... Done",
            "Building dependency tree...",
            "Connecting to rbx_cloud_v6...",
            "Status: HTTP/1.1 200 OK",
            "Injecting kernel payloads...",
            "DIR /S C:\\WINDOWS\\SYSTEM32\\DRIVERS",
            "0x0045FF - MEMORY_PATCH_APPLIED",
            "0x0045FG - BYPASS_SUCCESS",
            "root@ap6:~$ run main_hub.exe"
        }
        for i = 1, 100 do
            local text = logs[math.random(1,#logs)]
            if i % 10 == 0 then text = ">> CRITICAL_STDOUT: " .. tostring(math.random(1000, 9999)) end
            local l = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = text, TextColor3 = self.Theme.Terminal, Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, cmd)
            cmd.CanvasPosition = Vector2.new(0, cmd.AbsoluteCanvasSize.Y)
            task.wait(0.03)
        end
    end)

    task.spawn(function()
        while c.Parent do logo.TextColor3 = self.Rainbow sub.TextColor3 = self.Rainbow task.wait() end
    end)

    self:Sfx(1324546452, 0.8)
    self:Tween(logo, 1.2, {TextTransparency = 0, Position = UDim2.new(0, 0, 0.5, -60)})
    self:Tween(sub, 1.2, {TextTransparency = 0})
    task.wait(3.5)

    -- [ ANTI-TEXTO-TIESO TECHNOLOGY ]
    self:Sfx(5236242203, 0.6)
    self:Tween(logo, 0.5, {TextTransparency = 1, Size = UDim2.new(1.2, 0, 0, 150)})
    self:Tween(sub, 0.5, {TextTransparency = 1, Position = UDim2.new(0, 0, 0.5, 100)})
    self:Tween(cmd, 0.5, {Position = UDim2.new(0, 30, -0.6, 0)})
    local fadeOut = self:Tween(c, 0.8, {GroupTransparency = 1, BackgroundTransparency = 1})
    
    fadeOut.Completed:Wait()
    g:Destroy()
    cb()
end

-- [ MAIN HUB ENGINE ]
function AP6:Init(games)
    self:Boot(function()
        local main = Create("ScreenGui", {Name = "AP6_UNIVERSAL_CORE"}, PlayerGui)
        local frame = Create("CanvasGroup", {Size = UDim2.new(0, 750, 0, 480), Position = UDim2.new(0.5, -375, 0.5, -240), BackgroundColor3 = self.Theme.Main, GroupTransparency = 1}, main)
        Create("UICorner", {CornerRadius = UDim.new(0, 2)}, frame)
        local stroke = Create("UIStroke", {Thickness = 2.5, Color = self.Rainbow}, frame)

        task.spawn(function()
            while frame.Parent do stroke.Color = self.Rainbow RunService.RenderStepped:Wait() end
        end)

        -- Matrix Background Logic
        local bg = Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 0}, frame)
        for i = 1, 15 do
            task.spawn(function()
                while bg.Parent do
                    local drop = Create("TextLabel", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(math.random(), 0, -0.1, 0), BackgroundTransparency = 1, Text = string.char(math.random(33, 126)), TextColor3 = self.Theme.Terminal, TextTransparency = 0.8, Font = self.Theme.Font, TextSize = 10}, bg)
                    AP6:Tween(drop, math.random(2, 5), {Position = UDim2.new(drop.Position.X.Scale, 0, 1.1, 0)}).Completed:Connect(function() drop:Destroy() end)
                    task.wait(0.2)
                end
            end)
        end

        local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = self.Theme.Dark, BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = "AP6 HUB // UNIVERSAL HUB [v8.0]", TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, top)

        local close = Create("TextButton", {Size = UDim2.new(0, 45, 0, 45), Position = UDim2.new(1, -45, 0, 0), Text = "X", BackgroundColor3 = self.Theme.Red, TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 18, BorderSizePixel = 0}, top)
        
        local sidebar = Create("Frame", {Size = UDim2.new(0, 200, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = Color3.fromRGB(4, 4, 6), BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Text = "Nan", TextColor3 = Color3.fromRGB(120, 120, 130), Font = self.Theme.Font, TextSize = 18}, sidebar)

        local legHolder = Create("Frame", {Size = UDim2.new(1, -40, 0, 200), Position = UDim2.new(0, 20, 0, 60), BackgroundTransparency = 1}, sidebar)
        Create("UIListLayout", {Padding = UDim.new(0, 15)}, legHolder)

        local function AddL(c, t)
            local r = Create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, legHolder)
            local d = Create("Frame", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0.5, -5), BackgroundColor3 = c, BorderSizePixel = 0}, r)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            Create("TextLabel", {Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Text = t, TextColor3 = Color3.fromRGB(180, 180, 180), Font = self.Theme.Font, TextSize = 11, TextXAlignment = 0}, r)
        end

        AddL(self.Theme.Accent, "🟢 ONLINE")
        AddL(self.Theme.Red, "🔴 OFFLINE")
        AddL(self.Theme.Terminal, "📡 MASTER")

        local container = Create("ScrollingFrame", {Size = UDim2.new(1, -240, 1, -85), Position = UDim2.new(0, 220, 0, 65), BackgroundTransparency = 1, ScrollBarThickness = 0}, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, container)

        for id, data in pairs(games) do
            local isCurrent = (tonumber(id) == game.PlaceId)
            local card = Create("Frame", {Size = UDim2.new(1, -10, 0, 75), BackgroundColor3 = self.Theme.Secondary}, container)
            Create("UICorner", {CornerRadius = UDim.new(0, 2)}, card)
            local cs = Create("UIStroke", {Thickness = 1.5, Color = isCurrent and self.Rainbow or self.Theme.Outline}, card)
            
            if isCurrent then
                task.spawn(function() while card.Parent do cs.Color = self.Rainbow RunService.RenderStepped:Wait() end end)
            end

            Create("TextLabel", {Size = UDim2.new(1, -180, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = data.name:upper(), TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 14, TextXAlignment = 0}, card)

            local btn = Create("TextButton", {Size = UDim2.new(0, 110, 0, 35), Position = UDim2.new(1, -125, 0.5, -17), BackgroundColor3 = isCurrent and Color3.new(1,1,1) or Color3.fromRGB(25, 25, 30), Text = isCurrent and "EXECUTE" or "LOCKED", TextColor3 = Color3.new(0,0,0), Font = self.Theme.Font, TextSize = 12}, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 2)}, btn)
            
            if isCurrent then
                task.spawn(function() while btn.Parent do btn.BackgroundColor3 = self.Rainbow RunService.RenderStepped:Wait() end end)
                btn.MouseButton1Click:Connect(function()
                    AP6:Sfx(12222242)
                    if data.url then loadstring(game:HttpGet(data.url))() end
                    if data.onExecute then data.onExecute() end
                end)
            end
        end

        self:Tween(frame, 0.8, {GroupTransparency = 0})
        self:ApplyGlitch(frame)

        close.MouseButton1Click:Connect(function()
            self:Sfx(1324546452)
            self:Tween(frame, 0.6, {GroupTransparency = 1, Size = UDim2.new(0, 600, 0, 300)}).Completed:Wait()
            main:Destroy()
        end)

        -- Drag Logic
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
