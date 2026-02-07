--[[ 
    AP6 HUB - PRESTIGE EDITION (WinUI / Rayfield Hybrid)
    Focus: Zero Transparency Bugs, Deep UI Logic, Smooth SFX
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(10, 10, 14),
        Secondary = Color3.fromRGB(16, 16, 22),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 60, 60),
        Orange = Color3.fromRGB(255, 160, 0),
        Outline = Color3.fromRGB(40, 40, 50),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(160, 160, 175),
        Font = Enum.Font.Code
    },
    Executor = (identifyexecutor and identifyexecutor()) or "Standard Environment",
    IsOpen = true
}

-- [ HELPER: CREATE ]
local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

-- [ HELPER: TWEEN ]
function AP6:Tween(obj, time, goal, style)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, goal)
    tween:Play()
    return tween
end

-- [ HELPER: SOUND ]
function AP6:PlaySfx(id, vol)
    task.spawn(function()
        local s = Create("Sound", {
            SoundId = "rbxassetid://" .. tostring(id),
            Volume = vol or 0.5,
            Parent = SoundService
        })
        s:Play()
        s.Ended:Wait()
        s:Destroy()
    end)
end

-- [ NOTIFICATION SYSTEM ]
function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local gui = PlayerGui:FindFirstChild("AP6_NOTIF_HOLDER") or Create("ScreenGui", {Name = "AP6_NOTIF_HOLDER", IgnoreGuiInset = true}, PlayerGui)
        local container = gui:FindFirstChild("Container") or Create("Frame", {
            Name = "Container",
            Size = UDim2.new(0, 320, 1, -40),
            Position = UDim2.new(1, -330, 0, 20),
            BackgroundTransparency = 1
        }, gui)
        
        if not container:FindFirstChild("Layout") then
            Create("UIListLayout", {Name = "Layout", VerticalAlignment = 2, Padding = UDim.new(0, 12)}, container)
        end

        local card = Create("CanvasGroup", {
            Size = UDim2.new(1, 0, 0, 85),
            BackgroundColor3 = self.Theme.Secondary,
            GroupTransparency = 1
        }, container)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
        Create("UIStroke", {Color = self.Theme.Accent, ApplyStrokeMode = 1, Thickness = 1.5}, card)

        Create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 35),
            Position = UDim2.new(0, 15, 0, 8),
            BackgroundTransparency = 1,
            Text = title:upper(),
            TextColor3 = self.Theme.Accent,
            Font = self.Theme.Font,
            TextSize = 14,
            TextXAlignment = 0
        }, card)

        Create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 40),
            Position = UDim2.new(0, 15, 0, 38),
            BackgroundTransparency = 1,
            Text = msg,
            TextColor3 = Color3.new(1,1,1),
            Font = self.Theme.Font,
            TextSize = 11,
            TextXAlignment = 0,
            TextWrapped = true
        }, card)

        self:PlaySfx(6543431344, 0.4)
        self:Tween(card, 0.6, {GroupTransparency = 0})
        task.wait(dur or 4)
        self:Tween(card, 0.6, {GroupTransparency = 1}).Completed:Wait()
        card:Destroy()
    end)
end

-- [ BOOT SYSTEM ]
function AP6:Boot(callback)
    local g = Create("ScreenGui", {IgnoreGuiInset = true, DisplayOrder = 9999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(2, 2, 4)}, g)
    
    local logo = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0.45, -50),
        BackgroundTransparency = 1,
        Text = "AP6 HUB",
        TextColor3 = self.Theme.Cyan,
        Font = self.Theme.Font,
        TextSize = 85,
        TextTransparency = 1
    }, c)

    local bar = Create("Frame", {
        Size = UDim2.new(0, 350, 0, 3),
        Position = UDim2.new(0.5, -175, 0.5, 50),
        BackgroundColor3 = self.Theme.Outline,
        BorderSizePixel = 0
    }, c)
    local fill = Create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.Theme.Accent, BorderSizePixel = 0}, bar)
    local info = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, 70),
        BackgroundTransparency = 1,
        Text = "INITIALIZING CORE...",
        TextColor3 = self.Theme.DarkText,
        Font = self.Theme.Font,
        TextSize = 12,
        TextTransparency = 1
    }, c)

    -- Animación de entrada
    self:PlaySfx(1324546452, 0.7)
    self:Tween(logo, 1.2, {TextTransparency = 0, Position = UDim2.new(0, 0, 0.45, -60)})
    self:Tween(info, 1.2, {TextTransparency = 0})

    -- Proceso de Carga
    local steps = {"VERIFYING_EXECUTOR", "PATCHING_MEMORY", "LOADING_ASSETS", "READY"}
    for i, step in ipairs(steps) do
        info.Text = "> " .. step .. "..."
        self:Tween(fill, 0.8, {Size = UDim2.new(i/#steps, 0, 1, 0)}).Completed:Wait()
    end

    -- Solución al "Texto Tieso": Fade Out completo antes de ejecutar Callback
    self:PlaySfx(5236242203, 0.6)
    self:Tween(c, 0.8, {GroupTransparency = 1}).Completed:Wait()
    g:Destroy()
    callback()
end

-- [ MAIN HUB ]
function AP6:Init(games)
    self:Boot(function()
        -- Confetti de bienvenida
        task.spawn(function()
            local fx = Create("ScreenGui", {Parent = PlayerGui}, PlayerGui)
            for i = 1, 100 do
                task.spawn(function()
                    local p = Create("Frame", {
                        Size = UDim2.new(0, math.random(6,12), 0, math.random(6,12)),
                        Position = UDim2.new(math.random(), 0, -0.1, 0),
                        BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1),
                        BorderSizePixel = 0
                    }, fx)
                    Create("UICorner", {CornerRadius = UDim.new(1, 0)}, p)
                    AP6:Tween(p, math.random(2, 5), {Position = UDim2.new(p.Position.X.Scale + math.random(-0.1, 0.1), 0, 1.1, 0), Rotation = math.random(0, 1000)}).Completed:Wait()
                    p:Destroy()
                end)
            end
            task.delay(6, function() fx:Destroy() end)
        end)

        self:Notify("SECURITY", "Kernel initialized as " .. self.Executor, 5)

        local main = Create("ScreenGui", {Name = "AP6_HUB_CORE"}, PlayerGui)
        local frame = Create("CanvasGroup", {
            Size = UDim2.new(0, 750, 0, 500),
            Position = UDim2.new(0.5, -375, 0.5, -250),
            BackgroundColor3 = self.Theme.Main,
            GroupTransparency = 1
        }, main)
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}, frame)
        Create("UIStroke", {Color = self.Theme.Outline, Thickness = 2, ApplyStrokeMode = 1}, frame)

        -- Topbar
        local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = self.Theme.Secondary, BorderSizePixel = 0}, frame)
        Create("TextLabel", {
            Size = UDim2.new(1, -150, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = "AP6 HUB // PRESTIGE EDITION",
            TextColor3 = self.Theme.Cyan,
            Font = self.Theme.Font,
            TextSize = 16,
            TextXAlignment = 0
        }, top)

        -- Botones X y -
        local close = Create("TextButton", {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(1, -60, 0, 0), Text = "X", BackgroundColor3 = self.Theme.Red, TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 22, BorderSizePixel = 0, AutoButtonColor = false}, top)
        local min = Create("TextButton", {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(1, -120, 0, 0), Text = "—", BackgroundColor3 = self.Theme.Outline, TextColor3 = Color3.new(1,1,1), Font = self.Theme.Font, TextSize = 22, BorderSizePixel = 0, AutoButtonColor = false}, top)

        -- Sidebar (La Leyenda)
        local side = Create("Frame", {Size = UDim2.new(0, 230, 1, -60), Position = UDim2.new(0, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(8, 8, 12), BorderSizePixel = 0}, frame)
        local sideLayout = Create("UIListLayout", {Padding = UDim.new(0, 15), HorizontalAlignment = 1}, side)
        sideLayout.Parent = side -- Forzar layout

        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Text = "STATUS KEY", TextColor3 = self.Theme.Accent, Font = self.Theme.Font, TextSize = 18}, side)

        local function AddKey(color, text)
            local r = Create("Frame", {Size = UDim2.new(1, -40, 0, 30), BackgroundTransparency = 1, Position = UDim2.new(0, 20, 0, 0)}, side)
            local d = Create("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 10, 0.5, -6), BackgroundColor3 = color, BorderSizePixel = 0}, r)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            Create("TextLabel", {Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = self.Theme.DarkText, Font = self.Theme.Font, TextSize = 12, TextXAlignment = 0}, r)
        end

        AddKey(self.Theme.Accent, "🟢 ACTIVE GAME")
        AddKey(self.Theme.Red, "🔴 INACTIVE")
        AddKey(self.Theme.Orange, "🟠 MAINTENANCE")

        -- Content
        local scroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, -260, 1, -90),
            Position = UDim2.new(0, 245, 0, 75),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.Accent
        }, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 15)}, scroll)

        -- Game Cards
        for id, data in pairs(games) do
            local isCurrent = (tonumber(id) == game.PlaceId)
            local dotColor = isCurrent and self.Theme.Accent or (data.Maintenance and self.Theme.Orange or self.Theme.Red)
            
            local card = Create("Frame", {Size = UDim2.new(1, -15, 0, 85), BackgroundColor3 = self.Theme.Secondary}, scroll)
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card)
            local stroke = Create("UIStroke", {Color = isCurrent and self.Theme.Accent or self.Theme.Outline, Thickness = 2}, card)

            local dot = Create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 20, 0.5, -7), BackgroundColor3 = dotColor, BorderSizePixel = 0}, card)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
            
            if isCurrent then -- Efecto pulso para juego activo
                task.spawn(function()
                    while task.wait(0.8) do
                        AP6:Tween(dot, 0.4, {BackgroundTransparency = 0.5}).Completed:Wait()
                        AP6:Tween(dot, 0.4, {BackgroundTransparency = 0}).Completed:Wait()
                    end
                end)
            end

            Create("TextLabel", {
                Size = UDim2.new(1, -200, 1, 0),
                Position = UDim2.new(0, 50, 0, 0),
                BackgroundTransparency = 1,
                Text = data.name:upper(),
                TextColor3 = Color3.new(1,1,1),
                Font = self.Theme.Font,
                TextSize = 14,
                TextXAlignment = 0
            }, card)

            local exec = Create("TextButton", {
                Size = UDim2.new(0, 120, 0, 40),
                Position = UDim2.new(1, -140, 0.5, -20),
                BackgroundColor3 = isCurrent and self.Theme.Accent or Color3.fromRGB(30, 30, 35),
                Text = isCurrent and "EXECUTE" or "LOCKED",
                TextColor3 = isCurrent and Color3.new(0,0,0) or self.Theme.DarkText,
                Font = self.Theme.Font,
                TextSize = 12
            }, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, exec)

            exec.MouseButton1Click:Connect(function()
                if isCurrent then
                    AP6:PlaySfx(12222242, 0.5)
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                else
                    AP6:Notify("ERROR", "Invalid Environment for injection.", 3)
                end
            end)
        end

        -- Fade In Principal
        self:Tween(frame, 1, {GroupTransparency = 0})

        -- Botones
        local isMin = false
        min.MouseButton1Click:Connect(function()
            isMin = not isMin
            AP6:Tween(frame, 0.6, {Size = isMin and UDim2.new(0, 750, 0, 60) or UDim2.new(0, 750, 0, 500)})
            scroll.Visible = not isMin
            side.Visible = not isMin
        end)

        close.MouseButton1Click:Connect(function()
            AP6:PlaySfx(1324546452, 0.5)
            AP6:Tween(frame, 0.7, {GroupTransparency = 1}).Completed:Wait()
            main:Destroy()
        end)

        -- Arrastrar
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
