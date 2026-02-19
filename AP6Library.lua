--[[
    █████╗ ██████╗ ██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔══██╗██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ███████║██████╔╝██████╔╝    ███████║██║   ██║██████╔╝
    ██╔══██║██╔═══╝ ██╔═══╝     ██╔══██║██║   ██║██╔══██╗
    ██║  ██║██║     ██║         ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝╚═╝     ╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
    FUTURE UI LIBRARY v2050.1 - Cyberpunk Edition
]]

local AP6 = {
    RainbowColorValue = 0,
    HueSelectionPosition = 0,
    PresetColor = Color3.fromRGB(0, 255, 255),
    CloseBind = Enum.KeyCode.RightControl,
    Theme = "Cyber", -- Cyber, Neon, Matrix, Void
    BlurEnabled = true,
    ParticlesEnabled = true,
    SoundEnabled = true,
    Version = "2050.1"
}

-- Servicios
local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting"),
    SoundService = game:GetService("SoundService"),
    HttpService = game:GetService("HttpService"),
    TextService = game:GetService("TextService")
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utilidades matemáticas avanzadas
local Math = {
    Lerp = function(a, b, t) return a + (b - a) * t end,
    Clamp = function(v, min, max) return math.max(min, math.min(max, v)) end,
    Map = function(v, a, b, c, d) return c + (d - c) * ((v - a) / (b - a)) end,
    Round = function(n, d) return math.floor(n * 10^d + 0.5) / 10^d end
}

-- Sistema de sonidos futuristas
local Sounds = {
    Hover = "rbxassetid://9113083740",
    Click = "rbxassetid://9113083550",
    Open = "rbxassetid://9113084019",
    Close = "rbxassetid://9113084195",
    Success = "rbxassetid://9113084430",
    Error = "rbxassetid://9113084610"
}

local function PlaySound(id, volume)
    if not AP6.SoundEnabled then return end
    local sound = Instance.new("Sound")
    sound.SoundId = id
    sound.Volume = volume or 0.5
    sound.Parent = Services.SoundService
    sound:Play()
    Services.TweenService:Create(sound, TweenInfo.new(0.5), {Volume = 0}):Play()
    task.delay(1, function() sound:Destroy() end)
end

-- Sistema de partículas cuánticas
local ParticleSystem = {
    Active = {},
    Create = function(parent, config)
        if not AP6.ParticlesEnabled then return end
        config = config or {}
        local emitter = Instance.new("ParticleEmitter")
        emitter.Color = config.Color or ColorSequence.new(AP6.PresetColor)
        emitter.Size = config.Size or NumberSequence.new(0.5, 0)
        emitter.Transparency = config.Transparency or NumberSequence.new(0, 1)
        emitter.Lifetime = config.Lifetime or NumberRange.new(0.5, 1.5)
        emitter.Rate = config.Rate or 50
        emitter.Speed = config.Speed or NumberRange.new(2, 5)
        emitter.SpreadAngle = config.Spread or Vector2.new(0, 0)
        emitter.Acceleration = config.Acceleration or Vector3.new(0, -5, 0)
        emitter.Parent = parent
        return emitter
    end
}

-- Efecto de blur dinámico
local BlurEffect = nil
local function UpdateBlur()
    if not AP6.BlurEnabled then return end
    if not BlurEffect then
        BlurEffect = Instance.new("BlurEffect")
        BlurEffect.Parent = Services.Lighting
    end
    local target = 0
    for _, ui in pairs(Services.CoreGui:GetChildren()) do
        if ui.Name:find("AP6") and ui.Enabled then
            target = 15
            break
        end
    end
    Services.TweenService:Create(BlurEffect, TweenInfo.new(0.5), {Size = target}):Play()
end

-- Paleta de colores futuristas
local Themes = {
    Cyber = {
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(255, 0, 128),
        Background = Color3.fromRGB(5, 5, 8),
        Surface = Color3.fromRGB(12, 12, 18),
        Accent = Color3.fromRGB(255, 255, 0),
        Text = Color3.fromRGB(240, 240, 255),
        Glow = Color3.fromRGB(0, 200, 255)
    },
    Neon = {
        Primary = Color3.fromRGB(180, 50, 255),
        Secondary = Color3.fromRGB(50, 255, 150),
        Background = Color3.fromRGB(8, 0, 15),
        Surface = Color3.fromRGB(20, 5, 35),
        Accent = Color3.fromRGB(255, 100, 200),
        Text = Color3.fromRGB(255, 240, 255),
        Glow = Color3.fromRGB(200, 50, 255)
    },
    Matrix = {
        Primary = Color3.fromRGB(0, 255, 70),
        Secondary = Color3.fromRGB(0, 150, 50),
        Background = Color3.fromRGB(0, 5, 0),
        Surface = Color3.fromRGB(0, 15, 5),
        Accent = Color3.fromRGB(150, 255, 0),
        Text = Color3.fromRGB(200, 255, 200),
        Glow = Color3.fromRGB(0, 255, 50)
    },
    Void = {
        Primary = Color3.fromRGB(255, 50, 50),
        Secondary = Color3.fromRGB(150, 0, 255),
        Background = Color3.fromRGB(2, 2, 5),
        Surface = Color3.fromRGB(8, 8, 12),
        Accent = Color3.fromRGB(255, 100, 0),
        Text = Color3.fromRGB(220, 220, 235),
        Glow = Color3.fromRGB(255, 30, 30)
    }
}

local CurrentTheme = Themes[AP6.Theme] or Themes.Cyber

-- Sistema de animaciones avanzado
local Animations = {
    Spring = function(obj, target, speed)
        local velocity = 0
        local current = obj.Position
        local connection
        connection = Services.RunService.Heartbeat:Connect(function(dt)
            local displacement = target - current
            local spring = displacement * (speed or 10)
            velocity = velocity + spring * dt
            velocity = velocity * 0.85 -- damping
            current = current + velocity * dt
            
            obj.Position = current
            
            if math.abs(velocity) < 0.1 and math.abs(displacement) < 0.1 then
                obj.Position = target
                connection:Disconnect()
            end
        end)
    end,
    
    Glitch = function(obj, intensity)
        local original = obj.Position
        for i = 1, 8 do
            obj.Position = UDim2.new(
                original.X.Scale, original.X.Offset + math.random(-intensity, intensity),
                original.Y.Scale, original.Y.Offset + math.random(-intensity, intensity)
            )
            task.wait(0.03)
        end
        obj.Position = original
    end,
    
    Pulse = function(obj, property, min, max, duration)
        local tween1 = Services.TweenService:Create(obj, TweenInfo.new(duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {[property] = max})
        local tween2 = Services.TweenService:Create(obj, TweenInfo.new(duration/2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {[property] = min})
        tween1:Play()
        tween1.Completed:Connect(function() tween2:Play() end)
        tween2.Completed:Connect(function() Animations.Pulse(obj, property, min, max, duration) end)
    end
}

-- Sistema de arrastre con inercia
local function MakeDraggable(topbar, object)
    local dragging = false
    local dragStart, startPos, velocity
    local lastPos, lastTime
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            lastPos = object.AbsolutePosition
            lastTime = tick()
            PlaySound(Sounds.Click, 0.3)
        end
    end)
    
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            -- Aplicar inercia
            if velocity then
                local target = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + velocity.X * 0.5,
                    startPos.Y.Scale, startPos.Y.Offset + velocity.Y * 0.5
                )
                Services.TweenService:Create(object, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = target}):Play()
            end
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            object.Position = newPos
            
            -- Calcular velocidad para inercia
            local currentTime = tick()
            local dt = currentTime - lastTime
            if dt > 0 then
                velocity = (object.AbsolutePosition - lastPos) / dt
            end
            lastPos = object.AbsolutePosition
            lastTime = currentTime
        end
    end)
end

-- BOOTLOADER FUTURISTA
function AP6:Boot(callback)
    local BootGui = Instance.new("ScreenGui")
    BootGui.Name = "AP6_BOOT_2050"
    BootGui.IgnoreGuiInset = true
    BootGui.Parent = Services.CoreGui
    
    -- Fondo con gradiente animado
    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = CurrentTheme.Background
    Background.Parent = BootGui
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.Background),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.Surface),
        ColorSequenceKeypoint.new(1, CurrentTheme.Background)
    })
    Gradient.Rotation = 45
    Gradient.Parent = Background
    
    -- Animar gradiente
    task.spawn(function()
        while Background and Background.Parent do
            Gradient.Rotation = Gradient.Rotation + 1
            task.wait(0.05)
        end
    end)
    
    -- Grid futurista
    local Grid = Instance.new("ImageLabel")
    Grid.Size = UDim2.new(1, 0, 1, 0)
    Grid.BackgroundTransparency = 1
    Grid.Image = "rbxassetid://6887081556"
    Grid.ImageColor3 = CurrentTheme.Primary
    Grid.ImageTransparency = 0.95
    Grid.Parent = Background
    
    -- Contenedor central
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0, 600, 0, 400)
    Container.Position = UDim2.new(0.5, -300, 0.5, -200)
    Container.BackgroundTransparency = 1
    Container.Parent = Background
    
    -- Logo holográfico
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(0, 400, 0, 150)
    LogoContainer.Position = UDim2.new(0.5, -200, 0, 50)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Container
    
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.BackgroundTransparency = 1
    Logo.Text = "AP6 HUB"
    Logo.TextColor3 = CurrentTheme.Primary
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 80
    Logo.TextTransparency = 1
    Logo.Parent = LogoContainer
    
    -- Efecto de brillo detrás del logo
    local Glow = Instance.new("ImageLabel")
    Glow.Size = UDim2.new(1.5, 0, 2, 0)
    Glow.Position = UDim2.new(-0.25, 0, -0.5, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://6887081556"
    Glow.ImageColor3 = CurrentTheme.Glow
    Glow.ImageTransparency = 1
    Glow.Parent = LogoContainer
    
    -- Versión
    local Version = Instance.new("TextLabel")
    Version.Size = UDim2.new(0, 200, 0, 30)
    Version.Position = UDim2.new(1, -210, 1, -35)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. AP6.Version .. " // BUILD 2050"
    Version.TextColor3 = CurrentTheme.Secondary
    Version.Font = Enum.Font.Code
    Version.TextSize = 14
    Version.TextTransparency = 1
    Version.Parent = Container
    
    -- Barra de progreso futurista
    local ProgressContainer = Instance.new("Frame")
    ProgressContainer.Size = UDim2.new(0, 500, 0, 4)
    ProgressContainer.Position = UDim2.new(0.5, -250, 0.7, 0)
    ProgressContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ProgressContainer.BorderSizePixel = 0
    ProgressContainer.Parent = Container
    
    Instance.new("UICorner", ProgressContainer).CornerRadius = UDim.new(0, 2)
    
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = CurrentTheme.Primary
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = ProgressContainer
    
    Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 2)
    
    -- Brillo de la barra
    local ProgressGlow = Instance.new("Frame")
    ProgressGlow.Size = UDim2.new(0, 100, 1, 0)
    ProgressGlow.Position = UDim2.new(1, -100, 0, 0)
    ProgressGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressGlow.BackgroundTransparency = 0.8
    ProgressGlow.BorderSizePixel = 0
    ProgressGlow.Parent = ProgressFill
    
    Instance.new("UICorner", ProgressGlow).CornerRadius = UDim.new(0, 2)
    
    -- Terminal de carga
    local Terminal = Instance.new("ScrollingFrame")
    Terminal.Size = UDim2.new(0, 500, 0, 120)
    Terminal.Position = UDim2.new(0.5, -250, 0.75, 20)
    Terminal.BackgroundTransparency = 1
    Terminal.ScrollBarThickness = 0
    Terminal.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Terminal.Parent = Container
    
    local TerminalLayout = Instance.new("UIListLayout")
    TerminalLayout.Padding = UDim.new(0, 4)
    TerminalLayout.Parent = Terminal
    
    -- Animaciones de entrada
    Services.TweenService:Create(Logo, TweenInfo.new(1, Enum.EasingStyle.Back), {TextTransparency = 0}):Play()
    Services.TweenService:Create(Glow, TweenInfo.new(1.5), {ImageTransparency = 0.7}):Play()
    Services.TweenService:Create(Version, TweenInfo.new(1), {TextTransparency = 0}):Play()
    
    -- Secuencia de carga
    task.spawn(function()
        local modules = {
            "INITIALIZING_NEURAL_LINK...",
            "BYPASSING_SECURITY_PROTOCOLS...",
            "INJECTING_RUNTIME_MODULES...",
            "OPTIMIZING_RENDER_PIPELINE...",
            "SYNCING_WITH_MAINFRAME...",
            "DECRYPTING_ASSETS...",
            "CALIBRATING_UI_COMPONENTS...",
            "ESTABLISHING_CONNECTION...",
            "SYSTEM_READY"
        }
        
        for i, module in ipairs(modules) do
            local line = Instance.new("TextLabel")
            line.Size = UDim2.new(1, 0, 0, 20)
            line.BackgroundTransparency = 1
            line.Text = string.format("[0x%04X] %s", math.random(0x1000, 0xFFFF), module)
            line.TextColor3 = CurrentTheme.Text
            line.Font = Enum.Font.Code
            line.TextSize = 12
            line.TextTransparency = 1
            line.Parent = Terminal
            
            Services.TweenService:Create(line, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            Terminal.CanvasPosition = Vector2.new(0, 9999)
            
            -- Actualizar progreso
            local progress = i / #modules
            Services.TweenService:Create(ProgressFill, TweenInfo.new(0.5), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
            
            -- Efecto de glitch aleatorio
            if math.random() > 0.7 then
                task.spawn(function()
                    Logo.TextColor3 = CurrentTheme.Secondary
                    task.wait(0.05)
                    Logo.TextColor3 = CurrentTheme.Primary
                end)
            end
            
            task.wait(0.4)
        end
        
        -- Finalizar
        task.wait(0.5)
        PlaySound(Sounds.Success, 0.8)
        
        -- Explosión de partículas
        local burst = Instance.new("Frame")
        burst.Size = UDim2.new(0, 10, 0, 10)
        burst.Position = UDim2.new(0.5, -5, 0.5, -5)
        burst.BackgroundTransparency = 1
        burst.Parent = Background
        
        ParticleSystem.Create(burst, {
            Rate = 200,
            Lifetime = NumberRange.new(1, 2),
            Speed = NumberRange.new(50, 150),
            Color = ColorSequence.new(CurrentTheme.Primary, CurrentTheme.Secondary)
        })
        
        task.wait(0.1)
        
        -- Fade out
        Services.TweenService:Create(Background, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
        for _, child in pairs(Container:GetDescendants()) do
            if child:IsA("GuiObject") then
                Services.TweenService:Create(child, TweenInfo.new(0.5), {TextTransparency = 1, ImageTransparency = 1}):Play()
            end
        end
        
        task.wait(0.8)
        BootGui:Destroy()
        if callback then callback() end
    end)
end

-- SISTEMA DE NOTIFICACIONES HOLOGRÁFICAS
function AP6:Notify(title, text, type, duration)
    type = type or "Info"
    duration = duration or 5
    
    local NotifGui = Services.CoreGui:FindFirstChild("AP6_NOTIF_2050") or Instance.new("ScreenGui")
    NotifGui.Name = "AP6_NOTIF_2050"
    NotifGui.Parent = Services.CoreGui
    
    local Holder = NotifGui:FindFirstChild("Holder") or Instance.new("Frame")
    if not NotifGui:FindFirstChild("Holder") then
        Holder.Name = "Holder"
        Holder.Size = UDim2.new(0, 350, 1, -40)
        Holder.Position = UDim2.new(1, -370, 0, 20)
        Holder.BackgroundTransparency = 1
        Holder.Parent = NotifGui
        
        Instance.new("UIListLayout", Holder).Padding = UDim.new(0, 12)
    end
    
    -- Colores según tipo
    local colors = {
        Info = CurrentTheme.Primary,
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50)
    }
    local notifColor = colors[type] or colors.Info
    
    -- Contenedor principal
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 100)
    Notif.BackgroundTransparency = 1
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Notif.Parent = Holder
    
    -- Fondo glassmorphism
    local Glass = Instance.new("Frame")
    Glass.Size = UDim2.new(1, 0, 1, 0)
    Glass.BackgroundColor3 = CurrentTheme.Surface
    Glass.BackgroundTransparency = 0.2
    Glass.BorderSizePixel = 0
    Glass.Parent = Notif
    
    Instance.new("UICorner", Glass).CornerRadius = UDim.new(0, 12)
    
    -- Borde neon
    local Border = Instance.new("UIStroke")
    Border.Thickness = 2
    Border.Color = notifColor
    Border.Transparency = 0.5
    Border.Parent = Glass
    
    -- Gradiente de fondo
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    Gradient.Transparency = NumberSequence.new(0.9, 0.95)
    Gradient.Rotation = 90
    Gradient.Parent = Glass
    
    -- Icono
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.BackgroundColor3 = notifColor
    Icon.BackgroundTransparency = 0.8
    Icon.Text = type == "Info" and "ℹ" or type == "Success" and "✓" or type == "Error" and "✕" or "!"
    Icon.TextColor3 = notifColor
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 24
    Icon.Parent = Glass
    
    Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 8)
    
    -- Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 0, 25)
    TitleLabel.Position = UDim2.new(0, 70, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = notifColor
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = 0
    TitleLabel.Parent = Glass
    
    -- Texto
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -80, 0, 50)
    TextLabel.Position = UDim2.new(0, 70, 0, 40)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = CurrentTheme.Text
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextSize = 13
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = 0
    TextLabel.TextYAlignment = 0
    TextLabel.Parent = Glass
    
    -- Barra de progreso
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, -20, 0, 3)
    ProgressBar.Position = UDim2.new(0, 10, 1, -8)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = Glass
    
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(0, 2)
    
    local ProgressFill = Instance.new("Frame")
    ProgressFill.Size = UDim2.new(1, 0, 1, 0)
    ProgressFill.BackgroundColor3 = notifColor
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = ProgressBar
    
    Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 2)
    
    -- Animación de entrada
    PlaySound(Sounds.Open, 0.4)
    Services.TweenService:Create(Notif, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Animación de progreso
    Services.TweenService:Create(ProgressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    
    -- Auto-cerrar
    task.delay(duration, function()
        PlaySound(Sounds.Close, 0.3)
        Services.TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0, 0)}):Play()
        task.wait(0.5)
        Notif:Destroy()
    end)
end

-- VENTANA PRINCIPAL FUTURISTA
function AP6:Window(title, theme)
    AP6.Theme = theme or "Cyber"
    CurrentTheme = Themes[AP6.Theme] or Themes.Cyber
    
    local WindowGui = Instance.new("ScreenGui")
    WindowGui.Name = "AP6_WINDOW_2050"
    WindowGui.ResetOnSpawn = false
    WindowGui.Parent = Services.CoreGui
    
    -- Frame principal con glassmorphism
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 750, 0, 450)
    Main.Position = UDim2.new(0.5, -375, 0.5, -225)
    Main.BackgroundColor3 = CurrentTheme.Background
    Main.BackgroundTransparency = 0.1
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = WindowGui
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
    
    -- Efecto de blur
    local Blur = Instance.new("ImageLabel")
    Blur.Name = "Blur"
    Blur.Size = UDim2.new(1, 0, 1, 0)
    Blur.BackgroundTransparency = 1
    Blur.Image = "rbxassetid://6887081556"
    Blur.ImageColor3 = CurrentTheme.Background
    Blur.ImageTransparency = 0.4
    Blur.ScaleType = Enum.ScaleType.Tile
    Blur.TileSize = UDim2.new(0, 50, 0, 50)
    Blur.Parent = Main
    
    -- Borde neon animado
    local Border = Instance.new("UIStroke")
    Border.Thickness = 2
    Border.Color = CurrentTheme.Primary
    Border.Parent = Main
    
    task.spawn(function()
        while Main and Main.Parent do
            Services.TweenService:Create(Border, TweenInfo.new(2), {Color = CurrentTheme.Secondary}):Play()
            task.wait(2)
            Services.TweenService:Create(Border, TweenInfo.new(2), {Color = CurrentTheme.Primary}):Play()
            task.wait(2)
        end
    end)
    
    -- Barra superior
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55)
    TopBar.BackgroundColor3 = CurrentTheme.Surface
    TopBar.BackgroundTransparency = 0.5
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 20)
    TopFix.Position = UDim2.new(0, 0, 1, -20)
    TopFix.BackgroundColor3 = CurrentTheme.Surface
    TopFix.BackgroundTransparency = 0.5
    TopFix.BorderSizePixel = 0
    TopFix.Parent = TopBar
    
    -- Título con efecto de scanline
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -200, 1, 0)
    Title.Position = UDim2.new(0, 25, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title:upper()
    Title.TextColor3 = CurrentTheme.Text
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.TextXAlignment = 0
    Title.Parent = TopBar
    
    -- Scanline animada
    local Scanline = Instance.new("Frame")
    Scanline.Size = UDim2.new(0, 2, 0.6, 0)
    Scanline.Position = UDim2.new(0, 0, 0.2, 0)
    Scanline.BackgroundColor3 = CurrentTheme.Primary
    Scanline.BorderSizePixel = 0
    Scanline.Parent = Title
    
    task.spawn(function()
        while Title and Title.Parent do
            Services.TweenService:Create(Scanline, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 0, 0.2, 0)}):Play()
            task.wait(1.5)
            Scanline.Position = UDim2.new(0, 0, 0.2, 0)
        end
    end)
    
    -- Botones de control
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
    MinimizeBtn.Position = UDim2.new(1, -80, 0.5, -16)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = CurrentTheme.Text
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = TopBar
    
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
    CloseBtn.BackgroundColor3 = CurrentTheme.Primary
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Parent = TopBar
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
    
    -- Sidebar de pestañas
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 200, 1, -55)
    Sidebar.Position = UDim2.new(0, 0, 0, 55)
    Sidebar.BackgroundColor3 = CurrentTheme.Surface
    Sidebar.BackgroundTransparency = 0.7
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 0)
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 16, 1, 0)
    SidebarFix.Position = UDim2.new(1, -16, 0, 0)
    SidebarFix.BackgroundColor3 = CurrentTheme.Surface
    SidebarFix.BackgroundTransparency = 0.7
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = Sidebar
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -20, 1, -20)
    TabList.Position = UDim2.new(0, 10, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar
    
    Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 8)
    
    -- Contenedor de contenido
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -200, 1, -55)
    ContentContainer.Position = UDim2.new(0, 200, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main
    
    -- Sistema de pestañas
    local Tabs = {}
    local CurrentTab = nil
    
    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        TabButton.Text = "  " .. name:upper()
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 170)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 13
        TabButton.TextXAlignment = 0
        TabButton.Parent = TabList
        
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 10)
        
        -- Indicador activo
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.BackgroundColor3 = CurrentTheme.Primary
        Indicator.BorderSizePixel = 0
        Indicator.Parent = TabButton
        
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 2)
        
        -- Contenido de la pestaña
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -30, 1, -30)
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = CurrentTheme.Primary
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 12)
        ContentLayout.Parent = TabContent
        
        -- Función de activación
        TabButton.MouseButton1Click:Connect(function()
            PlaySound(Sounds.Click, 0.3)
            
            -- Desactivar otras pestañas
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                Services.TweenService:Create(tab.Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
                tab.Button.TextColor3 = Color3.fromRGB(150, 150, 170)
                Services.TweenService:Create(tab.Indicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 0)}):Play()
            end
            
            -- Activar esta
            CurrentTab = name
            TabContent.Visible = true
            Services.TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            TabButton.TextColor3 = CurrentTheme.Primary
            Services.TweenService:Create(Indicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 20)}):Play()
            
            -- Animación de contenido
            TabContent.Position = UDim2.new(0, 25, 0, 15)
            Services.TweenService:Create(TabContent, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 15, 0, 15)}):Play()
        end)
        
        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if CurrentTab ~= name then
                Services.TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if CurrentTab ~= name then
                Services.TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
            end
        end)
        
        local TabObj = {
            Button = TabButton,
            Content = TabContent,
            Indicator = Indicator,
            Elements = {}
        }
        
        table.insert(Tabs, TabObj)
        
        -- Si es la primera, activarla
        if #Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Métodos de elementos
        function TabObj:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 50)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Btn.Text = "  " .. text
            Btn.TextColor3 = CurrentTheme.Text
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            Btn.TextXAlignment = 0
            Btn.Parent = TabContent
            
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Thickness = 1.5
            BtnStroke.Color = Color3.fromRGB(50, 50, 65)
            BtnStroke.Parent = Btn
            
            -- Efecto de brillo en hover
            local Glow = Instance.new("Frame")
            Glow.Size = UDim2.new(1, 0, 1, 0)
            Glow.BackgroundColor3 = CurrentTheme.Primary
            Glow.BackgroundTransparency = 1
            Glow.BorderSizePixel = 0
            Glow.ZIndex = 0
            Glow.Parent = Btn
            
            Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 12)
            
            Btn.MouseEnter:Connect(function()
                PlaySound(Sounds.Hover, 0.2)
                Services.TweenService:Create(Glow, TweenInfo.new(0.3), {BackgroundTransparency = 0.9}):Play()
                Services.TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = CurrentTheme.Primary}):Play()
            end)
            
            Btn.MouseLeave:Connect(function()
                Services.TweenService:Create(Glow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                Services.TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            
            Btn.MouseButton1Click:Connect(function()
                PlaySound(Sounds.Click, 0.4)
                -- Efecto de ripple
                local ripple = Instance.new("Frame")
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ripple.BackgroundTransparency = 0.5
                ripple.BorderSizePixel = 0
                ripple.Parent = Btn
                
                Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
                
                Services.TweenService:Create(ripple, TweenInfo.new(0.6), {
                    Size = UDim2.new(2, 0, 2, 0),
                    Position = UDim2.new(-0.5, 0, -0.5, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                task.delay(0.6, function() ripple:Destroy() end)
                
                pcall(callback)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return Btn
        end
        
        function TabObj:Toggle(text, default, callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 55)
            Container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Container.Parent = TabContent
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 12)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -100, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = 0
            Label.Parent = Container
            
            -- Switch futurista
            local SwitchBg = Instance.new("TextButton")
            SwitchBg.Size = UDim2.new(0, 55, 0, 28)
            SwitchBg.Position = UDim2.new(1, -70, 0.5, -14)
            SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SwitchBg.Text = ""
            SwitchBg.AutoButtonColor = false
            SwitchBg.Parent = Container
            
            Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
            
            local SwitchFill = Instance.new("Frame")
            SwitchFill.Size = UDim2.new(0, 0, 1, 0)
            SwitchFill.BackgroundColor3 = CurrentTheme.Primary
            SwitchFill.BorderSizePixel = 0
            SwitchFill.Parent = SwitchBg
            
            Instance.new("UICorner", SwitchFill).CornerRadius = UDim.new(1, 0)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 24, 0, 24)
            Knob.Position = UDim2.new(0, 2, 0.5, -12)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Knob.Parent = SwitchBg
            
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            
            local Shadow = Instance.new("ImageLabel")
            Shadow.Size = UDim2.new(1.5, 0, 1.5, 0)
            Shadow.Position = UDim2.new(-0.25, 0, -0.25, 0)
            Shadow.BackgroundTransparency = 1
            Shadow.Image = "rbxassetid://6887081556"
            Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
            Shadow.ImageTransparency = 0.7
            Shadow.Parent = Knob
            
            local enabled = default or false
            
            local function Update()
                local targetPos = enabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
                local targetFill = enabled and 1 or 0
                local targetColor = enabled and CurrentTheme.Primary or Color3.fromRGB(40, 40, 50)
                
                Services.TweenService:Create(Knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
                Services.TweenService:Create(SwitchFill, TweenInfo.new(0.3), {Size = UDim2.new(targetFill, 0, 1, 0)}):Play()
                Services.TweenService:Create(SwitchBg, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
                
                pcall(callback, enabled)
            end
            
            SwitchBg.MouseButton1Click:Connect(function()
                PlaySound(Sounds.Click, 0.3)
                enabled = not enabled
                Update()
            end)
            
            if enabled then Update() end
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return Container
        end
        
        function TabObj:Slider(text, min, max, default, callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 80)
            Container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Container.Parent = TabContent
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 12)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 30)
            Label.Position = UDim2.new(0, 15, 0, 8)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextXAlignment = 0
            Label.Parent = Container
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 30)
            ValueLabel.Position = UDim2.new(1, -70, 0, 8)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = CurrentTheme.Primary
            ValueLabel.Font = Enum.Font.GothamBlack
            ValueLabel.TextSize = 16
            ValueLabel.Parent = Container
            
            -- Barra de slider futurista
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -30, 0, 8)
            Track.Position = UDim2.new(0, 15, 0, 50)
            Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Track.BorderSizePixel = 0
            Track.Parent = Container
            
            Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Primary
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            
            -- Brillo del fill
            local FillGlow = Instance.new("Frame")
            FillGlow.Size = UDim2.new(1, 0, 3, 0)
            FillGlow.Position = UDim2.new(0, 0, 0.5, -1.5)
            FillGlow.BackgroundColor3 = CurrentTheme.Primary
            FillGlow.BackgroundTransparency = 0.5
            FillGlow.BorderSizePixel = 0
            FillGlow.Parent = Fill
            
            Instance.new("UICorner", FillGlow).CornerRadius = UDim.new(1, 0)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 18, 0, 18)
            Knob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.BorderSizePixel = 0
            Knob.Parent = Track
            
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            
            local KnobGlow = Instance.new("ImageLabel")
            KnobGlow.Size = UDim2.new(2, 0, 2, 0)
            KnobGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
            KnobGlow.BackgroundTransparency = 1
            KnobGlow.Image = "rbxassetid://6887081556"
            KnobGlow.ImageColor3 = CurrentTheme.Primary
            KnobGlow.ImageTransparency = 0.3
            KnobGlow.Parent = Knob
            
            local dragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                
                Services.TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                Services.TweenService:Create(Knob, TweenInfo.new(0.1), {Position = UDim2.new(pos, -9, 0.5, -9)}):Play()
                
                ValueLabel.Text = tostring(value)
                pcall(callback, value)
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                    Services.TweenService:Create(Knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 22, 0, 22)}):Play()
                end
            end)
            
            Services.UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    Services.TweenService:Create(Knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18)}):Play()
                end
            end)
            
            Services.UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return Container
        end
        
        function TabObj:Dropdown(text, options, callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 50)
            Container.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            Container.ClipsDescendants = true
            Container.Parent = TabContent
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 12)
            
            local Header = Instance.new("TextButton")
            Header.Size = UDim2.new(1, 0, 0, 50)
            Header.BackgroundTransparency = 1
            Header.Text = "  " .. text
            Header.TextColor3 = CurrentTheme.Text
            Header.Font = Enum.Font.GothamBold
            Header.TextSize = 14
            Header.TextXAlignment = 0
            Header.Parent = Container
            
            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 30, 0, 50)
            Arrow.Position = UDim2.new(1, -40, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = CurrentTheme.Primary
            Arrow.Font = Enum.Font.GothamBold
            Arrow.TextSize = 14
            Arrow.Parent = Header
            
            local Selected = Instance.new("TextLabel")
            Selected.Size = UDim2.new(0, 150, 0, 50)
            Selected.Position = UDim2.new(1, -190, 0, 0)
            Selected.BackgroundTransparency = 1
            Selected.Text = options[1] or "Select..."
            Selected.TextColor3 = CurrentTheme.Primary
            Selected.Font = Enum.Font.Gotham
            Selected.TextSize = 13
            Selected.TextXAlignment = 2
            Selected.Parent = Header
            
            local OptionsContainer = Instance.new("Frame")
            OptionsContainer.Size = UDim2.new(1, -20, 0, #options * 40)
            OptionsContainer.Position = UDim2.new(0, 10, 0, 55)
            OptionsContainer.BackgroundTransparency = 1
            OptionsContainer.Parent = Container
            
            local expanded = false
            
            for i, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Size = UDim2.new(1, 0, 0, 35)
                OptionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 40)
                OptionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                OptionBtn.Text = "  " .. option
                OptionBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
                OptionBtn.Font = Enum.Font.Gotham
                OptionBtn.TextSize = 13
                OptionBtn.TextXAlignment = 0
                OptionBtn.Parent = OptionsContainer
                
                Instance.new("UICorner", OptionBtn).CornerRadius = UDim.new(0, 8)
                
                OptionBtn.MouseEnter:Connect(function()
                    Services.TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
                end)
                
                OptionBtn.MouseLeave:Connect(function()
                    Services.TweenService:Create(OptionBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
                end)
                
                OptionBtn.MouseButton1Click:Connect(function()
                    PlaySound(Sounds.Click, 0.3)
                    Selected.Text = option
                    expanded = false
                    Services.TweenService:Create(Container, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 50)}):Play()
                    Services.TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    pcall(callback, option)
                end)
            end
            
            Header.MouseButton1Click:Connect(function()
                PlaySound(Sounds.Click, 0.3)
                expanded = not expanded
                local targetSize = expanded and UDim2.new(1, 0, 0, 60 + #options * 40) or UDim2.new(1, 0, 0, 50)
                Services.TweenService:Create(Container, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
                Services.TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = expanded and 180 or 0}):Play()
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            return Container
        end
        
        return TabObj
    end
    
    -- Hacer arrastrable
    MakeDraggable(TopBar, Main)
    
    -- Botones de control
    MinimizeBtn.MouseButton1Click:Connect(function()
        PlaySound(Sounds.Close, 0.3)
        Services.TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.5)
        Main.Visible = false
        UpdateBlur()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        PlaySound(Sounds.Close, 0.5)
        Services.TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = -10
        }):Play()
        task.wait(0.4)
        WindowGui:Destroy()
        UpdateBlur()
    end)
    
    -- Tecla de cierre
    Services.UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == AP6.CloseBind then
            Main.Visible = not Main.Visible
            UpdateBlur()
            if Main.Visible then
                PlaySound(Sounds.Open, 0.4)
                Services.TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, 750, 0, 450),
                    Position = UDim2.new(0.5, -375, 0.5, -225)
                }):Play()
            end
        end
    end)
    
    UpdateBlur()
    
    -- Animación de entrada
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Rotation = -5
    Services.TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 750, 0, 450),
        Rotation = 0
    }):Play()
    
    PlaySound(Sounds.Open, 0.5)
    
    return {
        Tab = CreateTab,
        Notify = function(t, m, ty, d) AP6:Notify(t, m, ty, d) end
    }
end

-- Sistema de inicialización rápida
function AP6:Init(config)
    config = config or {}
    local db = config.Games or {}
    local title = config.Title or "AP6 HUB"
    local theme = config.Theme or "Cyber"
    
    AP6:Boot(function()
        local Window = AP6:Window(title, theme)
        
        -- Tab de juegos
        if #db > 0 then
            local GamesTab = Window:Tab("Games")
            for _, gameData in ipairs(db) do
                local isCurrent = gameData.Id == game.PlaceId
                local btnText = isCurrent and "▶ EXECUTE: " .. gameData.Name or "🔒 " .. gameData.Name .. " [LOCKED]"
                
                GamesTab:Button(btnText, function()
                    if isCurrent then
                        Window:Notify("SYSTEM", "Loading " .. gameData.Name .. "...", "Info", 3)
                        if gameData.Load then
                            gameData.Load()
                        end
                    else
                        Window:Notify("ERROR", "This module is not compatible with this game.", "Error", 4)
                    end
                end)
            end
        end
        
        -- Tab de utilidades
        local UtilTab = Window:Tab("Utilities")
        
        UtilTab:Button("Rejoin Server", function()
            Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
        
        UtilTab:Button("Copy JobId", function()
            setclipboard(game.JobId)
            Window:Notify("COPIED", "JobId copied to clipboard!", "Success", 3)
        end)
        
        -- Tab de configuración
        local SettingsTab = Window:Tab("Settings")
        
        SettingsTab:Toggle("Blur Background", true, function(v)
            AP6.BlurEnabled = v
            UpdateBlur()
        end)
        
        SettingsTab:Toggle("Sound Effects", true, function(v)
            AP6.SoundEnabled = v
        end)
        
        SettingsTab:Dropdown("Theme", {"Cyber", "Neon", "Matrix", "Void"}, function(selected)
            AP6.Theme = selected
            Window:Notify("RESTART REQUIRED", "Please re-execute to apply theme.", "Warning", 5)
        end)
        
        -- Tab de créditos
        local CreditsTab = Window:Tab("Credits")
        CreditsTab:Button("AP6 Team © 2050", function() end)
        CreditsTab:Button("Version: " .. AP6.Version, function() end)
        CreditsTab:Button("Status: Operational", function() end)
    end)
end

return AP6
