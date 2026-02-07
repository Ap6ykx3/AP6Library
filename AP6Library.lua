-- [[ AP6 HUB - PRESTIGE UI LIBRARY ]]
-- [[ INSPIRATION: RAYFIELD / WINUI 3 ]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(10, 10, 12),
        Secondary = Color3.fromRGB(15, 15, 20),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 60, 60),
        Orange = Color3.fromRGB(255, 160, 0),
        Outline = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(160, 160, 170),
        Font = Enum.Font.Code -- Fuente limpia para evitar bugs de caracteres
    },
    Elements = {},
    Signals = {},
    Executor = (identifyexecutor and identifyexecutor()) or "Universal Client"
}

-- [ UTILS ]
local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

function AP6:PlaySound(id, vol)
    local s = Create("Sound", {
        SoundId = "rbxassetid://" .. tostring(id),
        Volume = vol or 0.5,
        Parent = SoundService
    })
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

function AP6:Tween(obj, time, goal, style)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

-- [ NOTIFICATION SYSTEM ]
function AP6:Notify(title, msg, dur)
    task.spawn(function()
        local g = PlayerGui:FindFirstChild("AP6_NOTIFICATIONS") or Create("ScreenGui", {Name = "AP6_NOTIFICATIONS", IgnoreGuiInset = true}, PlayerGui)
        local h = g:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.new(0, 300, 1, -40), Position = UDim2.new(1, -310, 0, 20), BackgroundTransparency = 1}, g)
        
        if not h:FindFirstChild("Layout") then
            Create("UIListLayout", {Name = "Layout", VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10)}, h)
        end

        local card = Create("CanvasGroup", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundColor3 = self.Theme.Secondary,
            GroupTransparency = 1
        }, h)
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
        Create("UIStroke", {Color = self.Theme.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1.5}, card)

        Create("TextLabel", {
            Size = UDim2.new(1, -30, 0, 30),
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
            Position = UDim2.new(0, 15, 0, 32),
            BackgroundTransparency = 1,
            Text = msg,
            TextColor3 = self.Theme.Text,
            Font = self.Theme.Font,
            TextSize = 11,
            TextXAlignment = 0,
            TextWrapped = true
        }, card)

        self:PlaySound(6543431344, 0.4)
        self:Tween(card, 0.5, {GroupTransparency = 0})
        task.wait(dur or 4)
        self:Tween(card, 0.5, {GroupTransparency = 1}).Completed:Wait()
        card:Destroy()
    end)
end

-- [ CONFETTI FX ]
function AP6:Confetti()
    local g = Create("ScreenGui", {Name = "AP6_CONFETTI", Parent = PlayerGui}, PlayerGui)
    for i = 1, 100 do
        task.spawn(function()
            local p = Create("Frame", {
                Size = UDim2.new(0, math.random(5,10), 0, math.random(5,10)),
                Position = UDim2.new(math.random(), 0, -0.1, 0),
                BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1),
                BorderSizePixel = 0,
                Rotation = math.random(0, 360)
            }, g)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, p)
            local t = self:Tween(p, math.random(2, 4), {
                Position = UDim2.new(p.Position.X.Scale + (math.random(-10, 10)/100), 0, 1.1, 0),
                Rotation = math.random(0, 1000)
            })
            t.Completed:Wait()
            p:Destroy()
        end)
    end
    task.delay(5, function() g:Destroy() end)
end

-- [ BOOT SYSTEM ]
function AP6:Boot(cb)
    local g = Create("ScreenGui", {IgnoreGuiInset = true, DisplayOrder = 999}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(2, 2, 4), GroupTransparency = 0}, g)
    
    local logo = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 100),
        Position = UDim2.new(0, 0, 0.45, -50),
        BackgroundTransparency = 1,
        Text = "AP6 HUB",
        TextColor3 = self.Theme.Cyan,
        Font = self.Theme.Font,
        TextSize = 80,
        TextTransparency = 1
    }, c)

    local bar = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 2),
        Position = UDim2.new(0.5, -150, 0.5, 40),
        BackgroundColor3 = self.Theme.Outline,
        BorderSizePixel = 0
    }, c)
    local fill = Create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.Theme.Accent, BorderSizePixel = 0}, bar)

    -- Animación de entrada
    self:PlaySound(1324546452, 0.8)
    self:Tween(logo, 1, {TextTransparency = 0, Position = UDim2.new(0, 0, 0.45, -60)})
    
    -- Carga simulada profesional
    for i = 1, 100 do
        fill.Size = UDim2.new(i/100, 0, 1, 0)
        task.wait(0.02)
    end

    -- Animación de salida (Soluciona el problema de quedarse "tieso")
    self:PlaySound(5236242203, 0.6)
    local fade = self:Tween(c, 0.8, {GroupTransparency = 1})
    fade.Completed:Wait() -- Espera exacta a que termine el fade
    g:Destroy() -- Elimina todo
    cb()
end

-- [ MAIN INIT ]
function AP6:Init(games)
    self:Boot(function()
        self:Confetti()
        self:Notify("AUTHORIZED", "System loaded via " .. self.Executor, 4)

        local mainGui = Create("ScreenGui", {Name = "AP6_MAIN_UI"}, PlayerGui)
        
        -- Frame Principal estilo WinUI
        local frame = Create("CanvasGroup", {
            Size = UDim2.new(0, 750, 0, 500),
            Position = UDim2.new(0.5, -375, 0.5, -250),
            BackgroundColor3 = self.Theme.Main,
            GroupTransparency = 1 -- Empieza invisible para el fade in
        }, mainGui)
        Create("UICorner", {CornerRadius = UDim.new(0, 12)}, frame)
        local frameStroke = Create("UIStroke", {Color = self.Theme.Outline, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)

        -- Top Bar
        local topBar = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = self.Theme.Secondary,
            BorderSizePixel = 0
        }, frame)
        
        Create("TextLabel", {
            Size = UDim2.new(1, -150, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = "AP6 HUB // PRESTIGE EDITION",
            TextColor3 = self.Theme.Cyan,
            Font = self.Theme.Font,
            TextSize = 16,
            TextXAlignment = 0
        }, topBar)

        -- Botones Control (X y -)
        local close = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(1, -60, 0, 0),
            Text = "X",
            BackgroundColor3 = self.Theme.Red,
            TextColor3 = Color3.new(1,1,1),
            Font = self.Theme.Font,
            TextSize = 20,
            BorderSizePixel = 0,
            AutoButtonColor = false
        }, topBar)

        local min = Create("TextButton", {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(1, -120, 0, 0),
            Text = "—",
            BackgroundColor3 = self.Theme.Outline,
            TextColor3 = Color3.new(1,1,1),
            Font = self.Theme.Font,
            TextSize = 20,
            BorderSizePixel = 0,
            AutoButtonColor = false
        }, topBar)

        -- Sidebar (Legend Section)
        local sidebar = Create("Frame", {
            Size = UDim2.new(0, 220, 1, -60),
            Position = UDim2.new(0, 0, 0, 60),
            BackgroundColor3 = Color3.fromRGB(8, 8, 12),
            BorderSizePixel = 0
        }, frame)
        
        local legTitle = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 20, 0, 10),
            BackgroundTransparency = 1,
            Text = "SYSTEM STATUS",
            TextColor3 = self.Theme.Accent,
            Font = self.Theme.Font,
            TextSize = 16,
            TextXAlignment = 0
        }, sidebar)

        local legList = Create("Frame", {
            Size = UDim2.new(1, -40, 0, 200),
            Position = UDim2.new(0, 20, 0, 60),
            BackgroundTransparency = 1
        }, sidebar)
        Create("UIListLayout", {Padding = UDim.new(0, 15)}, legList)

        local function AddStatus(color, desc)
            local r = Create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, legList)
            local d = Create("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 0, 0.5, -6), BackgroundColor3 = color, BorderSizePixel = 0}, r)
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = d})
            Create("TextLabel", {Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Text = desc, TextColor3 = self.Theme.DarkText, Font = self.Theme.Font, TextSize = 12, TextXAlignment = 0}, r)
        end

        AddStatus(self.Theme.Accent, "🟢 Active Session")
        AddStatus(self.Theme.Red, "🔴 Inactive Game")
        AddStatus(self.Theme.Orange, "🟠 Maintenance")

        -- Content Area
        local scroll = Create("ScrollingFrame", {
            Size = UDim2.new(1, -260, 1, -100),
            Position = UDim2.new(0, 240, 0, 80),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.Accent
        }, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, scroll)

        -- Game Cards Injection
        for id, data in pairs(games) do
            local active = (tonumber(id) == game.PlaceId)
            local statusColor = active and self.Theme.Accent or (data.Maintenance and self.Theme.Orange or self.Theme.Red)
            
            local card = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 80),
                BackgroundColor3 = self.Theme.Secondary
            }, scroll)
            Create("UICorner", {CornerRadius = UDim.new(0, 10)}, card)
            local cStroke = Create("UIStroke", {Color = active and self.Theme.Accent or self.Theme.Outline, Thickness = 1.5}, card)

            -- Status Dot Animated
            local dot = Create("Frame", {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 15, 0.5, -6),
                BackgroundColor3 = statusColor,
                BorderSizePixel = 0
            }, card)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, dot)
            
            if active then
                task.spawn(function()
                    while task.wait(0.8) do
                        self:Tween(dot, 0.4, {BackgroundTransparency = 0.5}).Completed:Wait()
                        self:Tween(dot, 0.4, {BackgroundTransparency = 0}).Completed:Wait()
                    end
                end)
            end

            Create("TextLabel", {
                Size = UDim2.new(1, -180, 1, 0),
                Position = UDim2.new(0, 40, 0, 0),
                BackgroundTransparency = 1,
                Text = data.name:upper(),
                TextColor3 = self.Theme.Text,
                Font = self.Theme.Font,
                TextSize = 14,
                TextXAlignment = 0
            }, card)

            local exec = Create("TextButton", {
                Size = UDim2.new(0, 110, 0, 40),
                Position = UDim2.new(1, -125, 0.5, -20),
                BackgroundColor3 = active and self.Theme.Accent or Color3.fromRGB(25, 25, 30),
                Text = active and "EXECUTE" or "LOCKED",
                TextColor3 = active and Color3.new(0,0,0) or self.Theme.DarkText,
                Font = self.Theme.Font,
                TextSize = 12
            }, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, exec)

            exec.MouseButton1Click:Connect(function()
                if active then
                    self:PlaySound(12222242, 0.5)
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                else
                    self:Notify("SECURITY ERROR", "PlaceID mismatch detected.", 3)
                end
            end)
        end

        -- Fade In Final
        self:Tween(frame, 1, {GroupTransparency = 0})

        -- Control Logic
        local isMin = false
        min.MouseButton1Click:Connect(function()
            isMin = not isMin
            self:Tween(frame, 0.6, {Size = isMin and UDim2.new(0, 750, 0, 60) or UDim2.new(0, 750, 0, 500)})
            scroll.Visible = not isMin
            sidebar.Visible = not isMin
        end)

        close.MouseButton1Click:Connect(function()
            self:PlaySound(1324546452, 0.5)
            self:Tween(frame, 0.6, {GroupTransparency = 1}).Completed:Wait()
            mainGui:Destroy()
        end)

        -- Draggable
        local drag, start, pos
        topBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pos = frame.Position end end)
        UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - start
            frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + delta.X, pos.Y.Scale, pos.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    end)
end

return AP6
