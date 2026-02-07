-- [[ AP6 HUB: REMASTERED LIBRARY VERSION ]]
-- [[ BASE: YOUR UPLOADED LIB | STYLE: NEON CYAN/BLACK ]]

local Library = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

-- [ CONFIGURACIÓN DE ESTILO: AP6 IMAGE ]
local PresetColor = Color3.fromRGB(0, 255, 255) -- CIAN NEÓN 
local BackgroundColor = Color3.fromRGB(8, 8, 12) -- NEGRO PROFUNDO 
local CloseBind = Enum.KeyCode.RightControl

-- [ RAINBOW ENGINE ]
coroutine.wrap(function()
    while wait() do
        Library.RainbowColorValue = Library.RainbowColorValue + 1 / 255
        Library.HueSelectionPosition = Library.HueSelectionPosition + 1
        if Library.RainbowColorValue >= 1 then Library.RainbowColorValue = 0 end
        if Library.HueSelectionPosition == 80 then Library.HueSelectionPosition = 0 end
    end
end)()

-- [ 1. BOOT SEQUENCE (MAMBO) ]
function Library:Boot()
    local BootGui = Instance.new("ScreenGui")
    BootGui.Name = "AP6_BOOT"
    BootGui.Parent = PlayerGui
    BootGui.IgnoreGuiInset = true
    
    local Canvas = Instance.new("CanvasGroup")
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundColor3 = Color3.new(0,0,0)
    Canvas.Parent = BootGui
    
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 0, 100)
    Logo.Position = UDim2.new(0, 0, 0.45, -50)
    Logo.BackgroundTransparency = 1
    Logo.Text = "AP6 HUB"
    Logo.TextColor3 = PresetColor
    Logo.Font = Enum.Font.Code
    Logo.TextSize = 100
    Logo.TextTransparency = 1
    Logo.Parent = Canvas

    local Terminal = Instance.new("ScrollingFrame")
    Terminal.Size = UDim2.new(1, -60, 0.4, 0)
    Terminal.Position = UDim2.new(0, 30, 0.6, 0)
    Terminal.BackgroundTransparency = 1
    Terminal.ScrollBarThickness = 0
    Terminal.Parent = Canvas
    
    local List = Instance.new("UIListLayout")
    List.Parent = Terminal
    List.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- Animación de Entrada
    TweenService:Create(Logo, TweenInfo.new(1), {TextTransparency = 0}):Play()
    
    -- Simulador de Hacking
    task.spawn(function()
        local logs = {"dir /s SYSTEM32", "BYPASSING_AC...", "INJECTING_DLL...", "HOOKING_EVENTS...", "SUCCESS_200_OK"}
        for i = 1, 60 do
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 15)
            lbl.BackgroundTransparency = 1
            lbl.Text = "root@ap6:~ " .. logs[math.random(1, #logs)] .. " ["..math.random(100,999).."]"
            lbl.TextColor3 = Color3.fromRGB(0, 200, 100)
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = Terminal
            Terminal.CanvasPosition = Vector2.new(0, 9999)
            task.wait(0.03)
        end
    end)
    
    task.wait(2.5)
    
    -- EFECTO SHAKE (TEMBLOR)
    for i = 1, 10 do
        Canvas.Position = UDim2.new(0, math.random(-10, 10), 0, math.random(-10, 10))
        task.wait(0.02)
    end
    
    -- Desvanecer
    TweenService:Create(Canvas, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
    task.wait(0.5)
    BootGui:Destroy()
end

-- [ UTILS: DRAG ]
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        end
    end)
end

-- [ MAIN WINDOW ]
function Library:Window(text, preset, closebind)
    -- Ejecutar Boot Sequence primero
    self:Boot()

    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(0, 255, 255) -- Forzar Cian 
    
    local ui = Instance.new("ScreenGui")
    ui.Name = "AP6_UI"
    ui.Parent = game.CoreGui
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner") -- Redondeo 
    local MainStroke = Instance.new("UIStroke") -- Borde Neón
    local TabHold = Instance.new("Frame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local TabFolder = Instance.new("Folder")
    local DragFrame = Instance.new("Frame")
    local SidebarText = Instance.new("TextLabel") -- Coming Soon
    local Separator = Instance.new("Frame")

    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = BackgroundColor
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 0, 0, 0) -- Empieza pequeño para la animación
    Main.ClipsDescendants = true
    
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    MainStroke.Color = PresetColor
    MainStroke.Thickness = 2
    MainStroke.Parent = Main

    -- EFECTO MATRIX (RAIN) EN EL FONDO
    local MatrixBg = Instance.new("Frame")
    MatrixBg.Size = UDim2.new(1,0,1,0)
    MatrixBg.BackgroundTransparency = 1
    MatrixBg.ZIndex = 0
    MatrixBg.Parent = Main
    
    spawn(function()
        while Main.Parent do
            local drop = Instance.new("TextLabel")
            drop.Position = UDim2.new(math.random(), 0, -0.1, 0)
            drop.Size = UDim2.new(0, 20, 0, 20)
            drop.Text = string.char(math.random(33, 126))
            drop.TextColor3 = PresetColor
            drop.TextTransparency = 0.8
            drop.BackgroundTransparency = 1
            drop.Parent = MatrixBg
            TweenService:Create(drop, TweenInfo.new(3), {Position = UDim2.new(drop.Position.X.Scale, 0, 1.1, 0)}):Play()
            game.Debris:AddItem(drop, 3)
            wait(0.2)
        end
    end)

    -- Animación de apertura
    Main:TweenSize(UDim2.new(0, 600, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.6, true)

    DragFrame.Name = "DragFrame"
    DragFrame.Parent = Main
    DragFrame.BackgroundTransparency = 1
    DragFrame.Size = UDim2.new(1, 0, 0, 40)
    MakeDraggable(DragFrame, Main)

    Title.Parent = Main
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.04, 0, 0, 0)
    Title.Size = UDim2.new(0, 300, 0, 40)
    Title.Font = Enum.Font.Code
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Separador Visual
    Separator.Parent = Main
    Separator.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Separator.BorderSizePixel = 0
    Separator.Position = UDim2.new(0, 0, 0, 40)
    Separator.Size = UDim2.new(1, 0, 0, 1)

    -- Sidebar Container
    TabHold.Parent = Main
    TabHold.BackgroundTransparency = 1
    TabHold.Position = UDim2.new(0, 10, 0, 50)
    TabHold.Size = UDim2.new(0, 130, 0, 290)

    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 8)
    
    -- "Key System: Coming Soon"
    SidebarText.Parent = Main
    SidebarText.BackgroundTransparency = 1
    SidebarText.Position = UDim2.new(0, 10, 1, -30)
    SidebarText.Size = UDim2.new(0, 130, 0, 20)
    SidebarText.Font = Enum.Font.Code
    SidebarText.Text = "Key System: Coming Soon"
    SidebarText.TextColor3 = Color3.fromRGB(100, 100, 100)
    SidebarText.TextSize = 10
    SidebarText.TextWrapped = true

    -- Botón de Cierre (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Main
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 20
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main:Destroy() -- Cierre instantáneo
        ui:Destroy()
    end)

    TabFolder.Parent = Main

    -- [ NOTIFICATION MODIFICADA (BARRIDO) ]
    function Library:Notification(title, desc)
        local NotifFrame = Instance.new("Frame")
        local NotifCorner = Instance.new("UICorner")
        local NotifStroke = Instance.new("UIStroke")
        local NotifTitle = Instance.new("TextLabel")
        local NotifDesc = Instance.new("TextLabel")

        NotifFrame.Name = "Notif"
        NotifFrame.Parent = ui
        NotifFrame.BackgroundColor3 = BackgroundColor
        NotifFrame.Size = UDim2.new(0, 250, 0, 70)
        -- Posición inicial fuera de pantalla (Derecha)
        NotifFrame.Position = UDim2.new(1.2, 0, 0.85, 0) 
        
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = NotifFrame
        
        NotifStroke.Color = PresetColor
        NotifStroke.Thickness = 2
        NotifStroke.Parent = NotifFrame

        NotifTitle.Parent = NotifFrame
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.Size = UDim2.new(1, -20, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = PresetColor
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left

        NotifDesc.Parent = NotifFrame
        NotifDesc.BackgroundTransparency = 1
        NotifDesc.Position = UDim2.new(0, 10, 0, 25)
        NotifDesc.Size = UDim2.new(1, -20, 0, 40)
        NotifDesc.Font = Enum.Font.Gotham
        NotifDesc.Text = desc
        NotifDesc.TextColor3 = Color3.new(1,1,1)
        NotifDesc.TextSize = 12
        NotifDesc.TextWrapped = true
        NotifDesc.TextXAlignment = Enum.TextXAlignment.Left

        -- Animación Barrido (Slide In)
        NotifFrame:TweenPosition(UDim2.new(1, -270, 0.85, 0), "Out", "Quart", 0.5)
        
        task.delay(4, function()
            -- Animación Barrido Salida (Slide Out)
            local t = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0.85, 0)})
            t:Play()
            t.Completed:Wait()
            NotifFrame:Destroy()
        end)
    end

    local tabHandler = {}

    function tabHandler:Tab(text)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")

        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Text = text
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local TabFrame = Instance.new("ScrollingFrame")
        local TabList = Instance.new("UIListLayout")

        TabFrame.Parent = TabFolder
        TabFrame.BackgroundTransparency = 1
        TabFrame.Position = UDim2.new(0, 150, 0, 50)
        TabFrame.Size = UDim2.new(0, 430, 0, 280)
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)
        TabFrame.ScrollBarThickness = 2
        TabFrame.Visible = false
        
        TabList.Parent = TabFrame
        TabList.Padding = UDim.new(0, 8)
        TabList.SortOrder = Enum.SortOrder.LayoutOrder

        -- Lógica de cambio de pestaña
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabFolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabHold:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(150,150,150)
                    v.BackgroundColor3 = Color3.fromRGB(20,20,25)
                end 
            end
            TabFrame.Visible = true
            TabBtn.TextColor3 = PresetColor
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end)
        
        -- Seleccionar la primera automáticamente
        if #TabFolder:GetChildren() == 1 then 
            TabFrame.Visible = true 
            TabBtn.TextColor3 = PresetColor
        end

        local contentHandler = {}

        function contentHandler:Button(text, callback)
            local Button = Instance.new("TextButton")
            local BtnCorner = Instance.new("UICorner")
            local BtnStroke = Instance.new("UIStroke")
            
            Button.Parent = TabFrame
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Estilo LOCKED
            Button.Text = text
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Button
            
            BtnStroke.Color = Color3.fromRGB(40,40,40)
            BtnStroke.Thickness = 1
            BtnStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
                BtnStroke.Color = PresetColor -- Hover Cian
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,25)}):Play()
                BtnStroke.Color = Color3.fromRGB(40,40,40)
            end)

            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            
            TabFrame.CanvasSize = UDim2.new(0,0,0, TabList.AbsoluteContentSize.Y + 10)
        end
        -- (Aquí podrías agregar Toggle/Slider si los necesitas del Library.txt original)
        return contentHandler
    end
    return tabHandler
end

return Library
