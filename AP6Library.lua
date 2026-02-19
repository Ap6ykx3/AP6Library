--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           A P 6    H U B    P R E M I U M    V 3              ║
    ║                  Ultra Professional Edition                   ║
    ╚═══════════════════════════════════════════════════════════════╝
]]

local AP6 = {
    Version = "3.0.0",
    Theme = "Cyber",
    Config = {
        AnimationSpeed = 0.3,
        BlurEnabled = true,
        SoundEnabled = false,
        Draggable = true
    }
}

-- Servicios
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Paleta de colores profesional
local Themes = {
    Cyber = {
        Primary = Color3.fromRGB(0, 240, 255),
        Secondary = Color3.fromRGB(255, 0, 128),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 30),
        SurfaceLight = Color3.fromRGB(35, 35, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 170),
        Success = Color3.fromRGB(50, 255, 100),
        Error = Color3.fromRGB(255, 50, 50),
        Warning = Color3.fromRGB(255, 200, 50)
    },
    Midnight = {
        Primary = Color3.fromRGB(100, 150, 255),
        Secondary = Color3.fromRGB(200, 100, 255),
        Background = Color3.fromRGB(5, 5, 10),
        Surface = Color3.fromRGB(15, 15, 25),
        SurfaceLight = Color3.fromRGB(30, 30, 45),
        Text = Color3.fromRGB(240, 240, 255),
        TextDark = Color3.fromRGB(140, 140, 160),
        Success = Color3.fromRGB(100, 255, 150),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 180, 60)
    },
    Crimson = {
        Primary = Color3.fromRGB(255, 50, 50),
        Secondary = Color3.fromRGB(255, 150, 0),
        Background = Color3.fromRGB(15, 5, 5),
        Surface = Color3.fromRGB(30, 10, 10),
        SurfaceLight = Color3.fromRGB(50, 20, 20),
        Text = Color3.fromRGB(255, 240, 240),
        TextDark = Color3.fromRGB(180, 140, 140),
        Success = Color3.fromRGB(100, 255, 100),
        Error = Color3.fromRGB(255, 30, 30),
        Warning = Color3.fromRGB(255, 200, 50)
    }
}

local CurrentTheme = Themes[AP6.Theme] or Themes.Cyber

-- Utilidades
local Utils = {
    Tween = function(obj, props, duration, easing, dir)
        return TweenService:Create(obj, TweenInfo.new(
            duration or AP6.Config.AnimationSpeed,
            easing or Enum.EasingStyle.Quart,
            dir or Enum.EasingDirection.Out
        ), props)
    end,
    
    Round = function(num, dec)
        return math.floor(num * 10^dec + 0.5) / 10^dec
    end,
    
    Clamp = function(num, min, max)
        return math.max(min, math.min(max, num))
    end
}

-- Sistema de arrastre suave
local function MakeDraggable(header, frame)
    if not AP6.Config.Draggable then return end
    
    local dragging = false
    local dragStart, startPos
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Bootloader cinematográfico
function AP6:Boot(callback)
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "AP6_Boot"
    Screen.ResetOnSpawn = false
    Screen.Parent = CoreGui
    
    -- Fondo oscuro
    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(1, 0, 1, 0)
    Bg.BackgroundColor3 = Color3.new(0, 0, 0)
    Bg.Parent = Screen
    
    -- Logo central
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 400, 0, 100)
    Logo.Position = UDim2.new(0.5, -200, 0.4, -50)
    Logo.BackgroundTransparency = 1
    Logo.Text = "AP6"
    Logo.TextColor3 = CurrentTheme.Primary
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 80
    Logo.TextTransparency = 1
    Logo.Parent = Bg
    
    local SubLogo = Instance.new("TextLabel")
    SubLogo.Size = UDim2.new(0, 400, 0, 30)
    SubLogo.Position = UDim2.new(0.5, -200, 0.4, 40)
    SubLogo.BackgroundTransparency = 1
    SubLogo.Text = "HUB PREMIUM"
    SubLogo.TextColor3 = CurrentTheme.TextDark
    SubLogo.Font = Enum.Font.GothamBold
    SubLogo.TextSize = 18
    SubLogo.TextTransparency = 1
    SubLogo.Parent = Bg
    
    -- Barra de carga
    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(0, 300, 0, 3)
    BarBg.Position = UDim2.new(0.5, -150, 0.5, 50)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = Bg
    
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = CurrentTheme.Primary
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    
    -- Animar entrada
    Utils.Tween(Logo, {TextTransparency = 0}, 0.8, Enum.EasingStyle.Back):Play()
    task.wait(0.2)
    Utils.Tween(SubLogo, {TextTransparency = 0}, 0.6):Play()
    Utils.Tween(BarFill, {Size = UDim2.new(1, 0, 1, 0)}, 2, Enum.EasingStyle.Quart):Play()
    
    task.wait(2.2)
    
    -- Salida
    Utils.Tween(Logo, {TextTransparency = 1}, 0.4):Play()
    Utils.Tween(SubLogo, {TextTransparency = 1}, 0.4):Play()
    Utils.Tween(BarBg, {BackgroundTransparency = 1}, 0.4):Play()
    Utils.Tween(BarFill, {BackgroundTransparency = 1}, 0.4):Play()
    
    task.wait(0.5)
    Screen:Destroy()
    
    if callback then callback() end
end

-- Notificaciones elegantes
function AP6:Notify(title, message, notifType, duration)
    notifType = notifType or "Info"
    duration = duration or 3
    
    local Screen = CoreGui:FindFirstChild("AP6_Notifs") or Instance.new("ScreenGui")
    Screen.Name = "AP6_Notifs"
    Screen.Parent = CoreGui
    
    local Holder = Screen:FindFirstChild("Holder") or Instance.new("Frame")
    if not Screen:FindFirstChild("Holder") then
        Holder.Name = "Holder"
        Holder.Size = UDim2.new(0, 320, 1, -40)
        Holder.Position = UDim2.new(1, -340, 0, 20)
        Holder.BackgroundTransparency = 1
        Holder.Parent = Screen
        
        Instance.new("UIListLayout", Holder).Padding = UDim.new(0, 10)
    end
    
    -- Colores según tipo
    local colors = {
        Info = CurrentTheme.Primary,
        Success = CurrentTheme.Success,
        Error = CurrentTheme.Error,
        Warning = CurrentTheme.Warning
    }
    local color = colors[notifType] or colors.Info
    
    -- Notificación
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(1, 0, 0, 80)
    Notif.BackgroundColor3 = CurrentTheme.Surface
    Notif.BackgroundTransparency = 0.1
    Notif.BorderSizePixel = 0
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Notif.Parent = Holder
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 12)
    
    -- Borde izquierdo de color
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, -20)
    Accent.Position = UDim2.new(0, 8, 0, 10)
    Accent.BackgroundColor3 = color
    Accent.BorderSizePixel = 0
    Accent.Parent = Notif
    
    Instance.new("UICorner", Accent).CornerRadius = UDim.new(0, 2)
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, 25)
    Title.Position = UDim2.new(0, 25, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = title:upper()
    Title.TextColor3 = color
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = 0
    Title.Parent = Notif
    
    -- Mensaje
    local Msg = Instance.new("TextLabel")
    Msg.Size = UDim2.new(1, -40, 0, 40)
    Msg.Position = UDim2.new(0, 25, 0, 35)
    Msg.BackgroundTransparency = 1
    Msg.Text = message
    Msg.TextColor3 = CurrentTheme.Text
    Msg.Font = Enum.Font.Gotham
    Msg.TextSize = 12
    Msg.TextWrapped = true
    Msg.TextXAlignment = 0
    Msg.TextYAlignment = 0
    Msg.Parent = Notif
    
    -- Animación entrada
    Utils.Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back):Play()
    
    -- Auto cerrar
    task.delay(duration, function()
        Utils.Tween(Notif, {Position = UDim2.new(1, 50, 0, 0)}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In):Play()
        task.wait(0.4)
        Notif:Destroy()
    end)
end

-- Ventana principal
function AP6:Window(title, theme)
    AP6.Theme = theme or "Cyber"
    CurrentTheme = Themes[AP6.Theme] or Themes.Cyber
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "AP6_Main"
    Screen.ResetOnSpawn = false
    Screen.Parent = CoreGui
    
    -- Frame principal
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 700, 0, 450)
    Main.Position = UDim2.new(0.5, -350, 0.5, -225)
    Main.BackgroundColor3 = CurrentTheme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Screen
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
    
    -- Borde neon
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = CurrentTheme.Primary
    Stroke.Transparency = 0.5
    Stroke.Parent = Main
    
    -- Barra superior
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 50)
    Top.BackgroundColor3 = CurrentTheme.Surface
    Top.BorderSizePixel = 0
    Top.Parent = Main
    
    Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 16)
    
    local TopFix = Instance.new("Frame")
    TopFix.Size = UDim2.new(1, 0, 0, 25)
    TopFix.Position = UDim2.new(0, 0, 1, -25)
    TopFix.BackgroundColor3 = CurrentTheme.Surface
    TopFix.BorderSizePixel = 0
    TopFix.Parent = Top
    
    -- Título
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -150, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = 0
    TitleLabel.Parent = Top
    
    -- Botón minimizar
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -75, 0.5, -15)
    MinBtn.BackgroundColor3 = CurrentTheme.SurfaceLight
    MinBtn.Text = "−"
    MinBtn.TextColor3 = CurrentTheme.Text
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 18
    MinBtn.Parent = Top
    
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    
    -- Botón cerrar
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundColor3 = CurrentTheme.Error
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    CloseBtn.Parent = Top
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 180, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = CurrentTheme.Surface
    Sidebar.BackgroundTransparency = 0.5
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    
    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -20, 1, -20)
    TabList.Position = UDim2.new(0, 10, 0, 10)
    TabList.BackgroundTransparency = 1
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.Parent = Sidebar
    
    Instance.new("UIListLayout", TabList).Padding = UDim.new(0, 8)
    
    -- Contenido
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -180, 1, -50)
    Content.Position = UDim2.new(0, 180, 0, 50)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    local Tabs = {}
    local CurrentTab = nil
    
    -- Función crear tab
    local function CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 42)
        TabBtn.BackgroundColor3 = CurrentTheme.SurfaceLight
        TabBtn.Text = "  " .. name:upper()
        TabBtn.TextColor3 = CurrentTheme.TextDark
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = 0
        TabBtn.Parent = TabList
        
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)
        
        -- Indicador
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 3, 0, 0)
        Indicator.Position = UDim2.new(0, 0, 0.5, 0)
        Indicator.BackgroundColor3 = CurrentTheme.Primary
        Indicator.BorderSizePixel = 0
        Indicator.Parent = TabBtn
        
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 2)
        
        -- Contenido del tab
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -30, 1, -30)
        TabContent.Position = UDim2.new(0, 15, 0, 15)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = CurrentTheme.Primary
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Parent = Content
        
        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = TabContent
        
        -- Seleccionar tab
        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab == name then return end
            CurrentTab = name
            
            -- Resetear todos
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                Utils.Tween(tab.Button, {BackgroundColor3 = CurrentTheme.SurfaceLight}, 0.2):Play()
                tab.Button.TextColor3 = CurrentTheme.TextDark
                Utils.Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2):Play()
            end
            
            -- Activar este
            TabContent.Visible = true
            Utils.Tween(TabBtn, {BackgroundColor3 = CurrentTheme.Primary}, 0.2):Play()
            TabBtn.TextColor3 = Color3.new(0, 0, 0)
            Utils.Tween(Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.2):Play()
        end)
        
        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if CurrentTab ~= name then
                Utils.Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.2):Play()
            end
        end)
        
        TabBtn.MouseLeave:Connect(function()
            if CurrentTab ~= name then
                Utils.Tween(TabBtn, {BackgroundColor3 = CurrentTheme.SurfaceLight}, 0.2):Play()
            end
        end)
        
        local TabObj = {
            Button = TabBtn,
            Content = TabContent,
            Indicator = Indicator
        }
        
        table.insert(Tabs, TabObj)
        
        -- Auto seleccionar primero
        if #Tabs == 1 then
            TabBtn.MouseButton1Click:Fire()
        end
        
        -- Elementos
        function TabObj:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 45)
            Btn.BackgroundColor3 = CurrentTheme.SurfaceLight
            Btn.Text = "  " .. text
            Btn.TextColor3 = CurrentTheme.Text
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 13
            Btn.TextXAlignment = 0
            Btn.Parent = TabContent
            
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
            
            -- Efecto hover
            Btn.MouseEnter:Connect(function()
                Utils.Tween(Btn, {BackgroundColor3 = CurrentTheme.Primary}, 0.2):Play()
                Btn.TextColor3 = Color3.new(0, 0, 0)
            end)
            
            Btn.MouseLeave:Connect(function()
                Utils.Tween(Btn, {BackgroundColor3 = CurrentTheme.SurfaceLight}, 0.2):Play()
                Btn.TextColor3 = CurrentTheme.Text
            end)
            
            Btn.MouseButton1Click:Connect(function()
                -- Ripple effect
                local Ripple = Instance.new("Frame")
                Ripple.Size = UDim2.new(0, 0, 0, 0)
                Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                Ripple.BackgroundColor3 = Color3.new(1, 1, 1)
                Ripple.BackgroundTransparency = 0.5
                Ripple.BorderSizePixel = 0
                Ripple.Parent = Btn
                
                Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)
                
                Utils.Tween(Ripple, {
                    Size = UDim2.new(2, 0, 2, 0),
                    Position = UDim2.new(-0.5, 0, -0.5, 0),
                    BackgroundTransparency = 1
                }, 0.6):Play()
                
                task.delay(0.6, function() Ripple:Destroy() end)
                
                pcall(callback)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
            return Btn
        end
        
        function TabObj:Toggle(text, default, callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 50)
            Container.BackgroundColor3 = CurrentTheme.SurfaceLight
            Container.Parent = TabContent
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 13
            Label.TextXAlignment = 0
            Label.Parent = Container
            
            -- Switch
            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 50, 0, 26)
            Switch.Position = UDim2.new(1, -65, 0.5, -13)
            Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            Switch.Text = ""
            Switch.AutoButtonColor = false
            Switch.Parent = Container
            
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 22, 0, 22)
            Knob.Position = UDim2.new(0, 2, 0.5, -11)
            Knob.BackgroundColor3 = Color3.new(1, 1, 1)
            Knob.BorderSizePixel = 0
            Knob.Parent = Switch
            
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            
            local enabled = default or false
            
            local function Update()
                local pos = enabled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
                local col = enabled and CurrentTheme.Success or Color3.fromRGB(40, 40, 50)
                
                Utils.Tween(Knob, {Position = pos}, 0.3):Play()
                Utils.Tween(Switch, {BackgroundColor3 = col}, 0.3):Play()
                
                pcall(callback, enabled)
            end
            
            Switch.MouseButton1Click:Connect(function()
                enabled = not enabled
                Update()
            end)
            
            if enabled then Update() end
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
            return Container
        end
        
        function TabObj:Slider(text, min, max, default, callback)
            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, 0, 0, 70)
            Container.BackgroundColor3 = CurrentTheme.SurfaceLight
            Container.Parent = TabContent
            
            Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 10)
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 0, 30)
            Label.Position = UDim2.new(0, 15, 0, 8)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 13
            Label.TextXAlignment = 0
            Label.Parent = Container
            
            local Value = Instance.new("TextLabel")
            Value.Size = UDim2.new(0, 50, 0, 30)
            Value.Position = UDim2.new(1, -65, 0, 8)
            Value.BackgroundTransparency = 1
            Value.Text = tostring(default)
            Value.TextColor3 = CurrentTheme.Primary
            Value.Font = Enum.Font.GothamBlack
            Value.TextSize = 14
            Value.Parent = Container
            
            -- Track
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -30, 0, 6)
            Track.Position = UDim2.new(0, 15, 0, 45)
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
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 16, 0, 16)
            Knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            Knob.BackgroundColor3 = Color3.new(1, 1, 1)
            Knob.BorderSizePixel = 0
            Knob.Parent = Track
            
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
            
            local dragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pos)
                
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Knob.Position = UDim2.new(pos, -8, 0.5, -8)
                Value.Text = tostring(val)
                
                pcall(callback, val)
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
            return Container
        end
        
        function TabObj:Label(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.TextDark
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextWrapped = true
            Label.Parent = TabContent
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
            return Label
        end
        
        return TabObj
    end
    
    -- Control de ventana
    MakeDraggable(Top, Main)
    
    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        -- Crear botón de restaurar
        local Restore = Instance.new("TextButton")
        Restore.Size = UDim2.new(0, 50, 0, 50)
        Restore.Position = UDim2.new(0, 20, 0.5, -25)
        Restore.BackgroundColor3 = CurrentTheme.Primary
        Restore.Text = "AP6"
        Restore.TextColor3 = Color3.new(0, 0, 0)
        Restore.Font = Enum.Font.GothamBlack
        Restore.TextSize = 12
        Restore.Parent = Screen
        
        Instance.new("UICorner", Restore).CornerRadius = UDim.new(1, 0)
        
        Restore.MouseButton1Click:Connect(function()
            Main.Visible = true
            Restore:Destroy()
            Utils.Tween(Main, {Size = UDim2.new(0, 700, 0, 450)}, 0.3):Play()
        end)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Utils.Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
        task.wait(0.3)
        Screen:Destroy()
    end)
    
    -- Animación entrada
    Main.Size = UDim2.new(0, 0, 0, 0)
    Utils.Tween(Main, {Size = UDim2.new(0, 700, 0, 450)}, 0.6, Enum.EasingStyle.Back):Play()
    
    return {
        Tab = CreateTab,
        Notify = function(t, m, ty, d) AP6:Notify(t, m, ty, d) end
    }
end

return AP6
