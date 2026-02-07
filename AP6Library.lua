local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(0, 255, 255)
local CloseBind = Enum.KeyCode.RightControl

coroutine.wrap(
    function()
        while wait() do
            lib.RainbowColorValue = lib.RainbowColorValue + 1 / 255
            lib.HueSelectionPosition = lib.HueSelectionPosition + 1
            if lib.RainbowColorValue >= 1 then
                lib.RainbowColorValue = 0
            end
            if lib.HueSelectionPosition == 80 then
                lib.HueSelectionPosition = 0
            end
        end
    end
)()

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end

function lib:Boot(callback)
    local BootGui = Instance.new("ScreenGui")
    BootGui.Name = "AP6_BOOTLOADER"
    BootGui.Parent = game:GetService("CoreGui")
    BootGui.IgnoreGuiInset = true
    
    local Canvas = Instance.new("CanvasGroup")
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundColor3 = Color3.new(0,0,0)
    Canvas.Parent = BootGui
    
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(1, 0, 0, 150)
    Logo.Position = UDim2.new(0, 0, 0.4, -75)
    Logo.BackgroundTransparency = 1
    Logo.Text = "AP6 HUB"
    Logo.TextColor3 = PresetColor
    Logo.Font = Enum.Font.Code
    Logo.TextSize = 140
    Logo.TextTransparency = 1
    Logo.TextScaled = true
    Logo.Parent = Canvas

    local BarBG = Instance.new("Frame")
    BarBG.Size = UDim2.new(0.4, 0, 0, 4)
    BarBG.Position = UDim2.new(0.5, 0, 0.5, 60)
    BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BarBG.AnchorPoint = Vector2.new(0.5, 0.5)
    BarBG.BorderSizePixel = 0
    BarBG.Parent = Canvas

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = PresetColor
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBG
    
    local ProgressStroke = Instance.new("UIStroke")
    ProgressStroke.Thickness = 2
    ProgressStroke.Color = PresetColor
    ProgressStroke.Parent = BarFill

    local Terminal = Instance.new("ScrollingFrame")
    Terminal.Size = UDim2.new(0.5, 0, 0.25, 0)
    Terminal.Position = UDim2.new(0.25, 0, 0.7, 0)
    Terminal.BackgroundTransparency = 1
    Terminal.ScrollBarThickness = 0
    Terminal.Parent = Canvas
    
    local TermLayout = Instance.new("UIListLayout")
    TermLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    TermLayout.Parent = Terminal

    TweenService:Create(Logo, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    TweenService:Create(BarFill, TweenInfo.new(4), {Size = UDim2.new(1, 0, 1, 0)}):Play()

    task.spawn(function()
        local sys_logs = {
            "SCANNING_CORE_COMPONENTS...", "BYPASSING_ANTIVIRUS...", "ESTABLISHING_P2P_TUNNEL...",
            "DECRYPTING_SERVER_PACKETS...", "INJECTING_V16_ASSETS...", "SUCCESS_MEM_READ_0xAF",
            "INITIALIZING_UI_THREAD...", "CLEANING_REGISTRY_KEYS...", "BOOTING_SYSTEM..."
        }
        for i = 1, 100 do
            local msg = "root@ap6_hub:~# " .. sys_logs[math.random(1, #sys_logs)] .. " [" .. i .. "%]"
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 0, 18)
            l.BackgroundTransparency = 1
            l.Text = msg
            l.TextColor3 = Color3.fromRGB(0, 255, 120)
            l.Font = Enum.Font.Code
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = Terminal
            Terminal.CanvasPosition = Vector2.new(0, 99999)
            task.wait(0.03)
        end
    end)

    task.wait(4.5)
    for i = 1, 30 do
        Canvas.Position = UDim2.new(0, math.random(-20, 20), 0, math.random(-20, 20))
        task.wait(0.01)
    end
    
    TweenService:Create(Canvas, TweenInfo.new(0.8), {GroupTransparency = 1}):Play()
    task.wait(0.8)
    BootGui:Destroy()
    callback()
end

function lib:Notify(title, text)
    local NotifyGui = game:GetService("CoreGui"):FindFirstChild("AP6_NOTIF_HOLDER")
    if not NotifyGui then
        NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name = "AP6_NOTIF_HOLDER"
        NotifyGui.Parent = game:GetService("CoreGui")
        
        local Holder = Instance.new("Frame")
        Holder.Name = "Holder"
        Holder.Size = UDim2.new(0, 300, 1, -40)
        Holder.Position = UDim2.new(1, -310, 0, 20)
        Holder.BackgroundTransparency = 1
        Holder.Parent = NotifyGui
        
        local Layout = Instance.new("UIListLayout")
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Padding = UDim.new(0, 10)
        Layout.Parent = Holder
    end
    
    local MainNotif = Instance.new("CanvasGroup")
    MainNotif.Size = UDim2.new(1, 0, 0, 80)
    MainNotif.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    MainNotif.GroupTransparency = 1
    MainNotif.Position = UDim2.new(2, 0, 0, 0)
    MainNotif.Parent = NotifyGui.Holder
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainNotif
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = PresetColor
    UIStroke.Parent = MainNotif
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = ">> " .. title:upper()
    Title.TextColor3 = PresetColor
    Title.Font = Enum.Font.Code
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainNotif
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 0, 40)
    Content.Position = UDim2.new(0, 10, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Text = text
    Content.TextColor3 = Color3.new(1,1,1)
    Content.Font = Enum.Font.Code
    Content.TextSize = 12
    Content.TextWrapped = true
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.Parent = MainNotif
    
    TweenService:Create(MainNotif, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(5, function()
        local t = TweenService:Create(MainNotif, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {GroupTransparency = 1, Position = UDim2.new(2, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        MainNotif:Destroy()
    end)
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(0, 255, 255)

    local ui = Instance.new("ScreenGui")
    ui.Name = "AP6_UI"
    ui.Parent = game:GetService("CoreGui")
    
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    local TabHold = Instance.new("Frame")
    local TabHoldLayout = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")
    local TabFolder = Instance.new("Folder")
    local DragFrame = Instance.new("Frame")
    local SidebarLabel = Instance.new("TextLabel")

    Main.Name = "Main"
    Main.Parent = ui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 650, 0, 400)
    Main.ClipsDescendants = true

    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    MainStroke.Color = PresetColor
    MainStroke.Thickness = 2.5
    MainStroke.Parent = Main

    local MatrixLayer = Instance.new("Frame")
    MatrixLayer.Size = UDim2.new(1,0,1,0)
    MatrixLayer.BackgroundTransparency = 1
    MatrixLayer.ZIndex = 0
    MatrixLayer.Parent = Main
    
    spawn(function()
        while Main.Parent do
            local drop = Instance.new("TextLabel")
            drop.Position = UDim2.new(math.random(), 0, -0.1, 0)
            drop.Size = UDim2.new(0, 20, 0, 20)
            drop.Text = string.char(math.random(33, 126))
            drop.TextColor3 = PresetColor
            drop.TextTransparency = 0.9
            drop.Font = Enum.Font.Code
            drop.Parent = MatrixLayer
            TweenService:Create(drop, TweenInfo.new(math.random(3, 5)), {Position = UDim2.new(drop.Position.X.Scale, 0, 1.1, 0)}):Play()
            game.Debris:AddItem(drop, 5)
            wait(0.2)
        end
    end)

    DragFrame.Name = "DragFrame"
    DragFrame.Parent = Main
    DragFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    DragFrame.Size = UDim2.new(1, 0, 0, 50)
    
    local DragStroke = Instance.new("Frame")
    DragStroke.Size = UDim2.new(1, 0, 0, 1)
    DragStroke.Position = UDim2.new(0, 0, 1, 0)
    DragStroke.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    DragStroke.BorderSizePixel = 0
    DragStroke.Parent = DragFrame

    Title.Parent = DragFrame
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(0, 400, 1, 0)
    Title.Font = Enum.Font.Code
    Title.Text = text:upper()
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local MiniBtn = Instance.new("TextButton")
    MiniBtn.Size = UDim2.new(0, 30, 0, 30)
    MiniBtn.Position = UDim2.new(1, -75, 0.5, -15)
    MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MiniBtn.Text = "-"
    MiniBtn.TextColor3 = Color3.new(1,1,1)
    MiniBtn.Font = Enum.Font.Code
    MiniBtn.TextSize = 25
    MiniBtn.Parent = DragFrame
    Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.Code
    CloseBtn.TextSize = 25
    CloseBtn.Parent = DragFrame
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

    local RestoreBtn = Instance.new("TextButton")
    RestoreBtn.Size = UDim2.new(0, 60, 0, 60)
    RestoreBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
    RestoreBtn.BackgroundColor3 = Color3.fromRGB(10,10,12)
    RestoreBtn.Text = "AP6"
    RestoreBtn.TextColor3 = PresetColor
    RestoreBtn.Font = Enum.Font.Code
    RestoreBtn.TextSize = 18
    RestoreBtn.Visible = false
    RestoreBtn.Parent = ui
    Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(1,0)
    local ResStroke = Instance.new("UIStroke", RestoreBtn)
    ResStroke.Color = PresetColor
    ResStroke.Thickness = 2

    MiniBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.02, 0, 0.95, 0)}):Play()
        task.wait(0.6)
        Main.Visible = false
        RestoreBtn.Visible = true
    end)

    RestoreBtn.MouseButton1Click:Connect(function()
        RestoreBtn.Visible = false
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 650, 0, 400), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function() ui:Destroy() end)
    MakeDraggable(DragFrame, Main)

    TabHold.Name = "TabHold"
    TabHold.Parent = Main
    TabHold.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    TabHold.Position = UDim2.new(0, 0, 0, 50)
    TabHold.Size = UDim2.new(0, 180, 1, -50)
    
    local SidebarStroke = Instance.new("Frame")
    SidebarStroke.Size = UDim2.new(0, 1, 1, 0)
    SidebarStroke.Position = UDim2.new(1, 0, 0, 0)
    SidebarStroke.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SidebarStroke.BorderSizePixel = 0
    SidebarStroke.Parent = TabHold

    TabHoldLayout.Parent = TabHold
    TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabHoldLayout.Padding = UDim.new(0, 10)
    TabHoldLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    SidebarLabel.Parent = TabHold
    SidebarLabel.BackgroundTransparency = 1
    SidebarLabel.Size = UDim2.new(1, 0, 0, 50)
    SidebarLabel.Font = Enum.Font.Code
    SidebarLabel.Text = "Key System:\nComing Soon"
    SidebarLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    SidebarLabel.TextSize = 12
    SidebarLabel.LayoutOrder = 99

    TabFolder.Name = "TabFolder"
    TabFolder.Parent = Main

    local function CreateTab(text)
        local TabBtn = Instance.new("TextButton")
        local TabBtnCorner = Instance.new("UICorner")
        local TabBtnStroke = Instance.new("UIStroke")

        TabBtn.Parent = TabHold
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
        TabBtn.Font = Enum.Font.Code
        TabBtn.Text = text:upper()
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.TextSize = 13.000

        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn
        
        TabBtnStroke.Thickness = 1
        TabBtnStroke.Color = Color3.fromRGB(40,40,45)
        TabBtnStroke.Parent = TabBtn

        local Tab = Instance.new("ScrollingFrame")
        local TabLayout = Instance.new("UIListLayout")

        Tab.Name = text .. "Tab"
        Tab.Parent = TabFolder
        Tab.Active = true
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundTransparency = 1.000
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0, 195, 0, 65)
        Tab.Size = UDim2.new(0, 440, 0, 320)
        Tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        Tab.ScrollBarThickness = 2
        Tab.Visible = false

        TabLayout.Parent = Tab
        TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabLayout.Padding = UDim.new(0, 12)

        TabBtn.MouseButton1Click:Connect(
            function()
                for i, v in pairs(TabFolder:GetChildren()) do
                    v.Visible = false
                end
                for i, v in pairs(TabHold:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.TextColor3 = Color3.fromRGB(150, 150, 150)
                        v.UIStroke.Color = Color3.fromRGB(40,40,45)
                    end
                end
                Tab.Visible = true
                TabBtn.TextColor3 = PresetColor
                TabBtnStroke.Color = PresetColor
            end
        )
        
        if #TabFolder:GetChildren() == 1 then
            Tab.Visible = true
            TabBtn.TextColor3 = PresetColor
            TabBtnStroke.Color = PresetColor
        end

        local content = {}

        function content:Button(text, callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            local ButtonStroke = Instance.new("UIStroke")
            local Arrow = Instance.new("TextLabel")

            Button.Name = "Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            Button.Size = UDim2.new(1, -10, 0, 45)
            Button.Font = Enum.Font.Code
            Button.Text = "  " .. text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14.000
            Button.TextXAlignment = Enum.TextXAlignment.Left

            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            ButtonStroke.Thickness = 1.5
            ButtonStroke.Color = Color3.fromRGB(45, 45, 50)
            ButtonStroke.Parent = Button
            
            Arrow.Size = UDim2.new(0, 30, 1, 0)
            Arrow.Position = UDim2.new(1, -35, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = ">"
            Arrow.TextColor3 = PresetColor
            Arrow.Font = Enum.Font.Code
            Arrow.TextSize = 18
            Arrow.Parent = Button

            Button.MouseEnter:Connect(function() ButtonStroke.Color = PresetColor end)
            Button.MouseLeave:Connect(function() ButtonStroke.Color = Color3.fromRGB(45,45,50) end)

            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end

        function content:Toggle(text, default, callback)
            local Toggle = Instance.new("TextButton")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleStroke = Instance.new("UIStroke")
            local ToggleBox = Instance.new("Frame")
            local ToggleBoxCorner = Instance.new("UICorner")
            local ToggleDot = Instance.new("Frame")
            local ToggleDotCorner = Instance.new("UICorner")

            Toggle.Parent = Tab
            Toggle.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            Toggle.Size = UDim2.new(1, -10, 0, 45)
            Toggle.Font = Enum.Font.Code
            Toggle.Text = "  " .. text
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.TextSize = 14.000
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleCorner.Parent = Toggle
            ToggleStroke.Thickness = 1.5
            ToggleStroke.Color = Color3.fromRGB(45,45,50)
            ToggleStroke.Parent = Toggle

            ToggleBox.Size = UDim2.new(0, 40, 0, 20)
            ToggleBox.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            ToggleBox.Parent = Toggle
            ToggleBoxCorner.CornerRadius = UDim.new(1, 0)
            ToggleBoxCorner.Parent = ToggleBox

            ToggleDot.Size = UDim2.new(0, 16, 0, 16)
            ToggleDot.Position = UDim2.new(0, 2, 0.5, -8)
            ToggleDot.BackgroundColor3 = Color3.new(1, 1, 1)
            ToggleDot.Parent = ToggleBox
            ToggleDotCorner.CornerRadius = UDim.new(1, 0)
            ToggleDotCorner.Parent = ToggleDot

            local toggled = default or false
            local function update()
                local targetPos = toggled and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = toggled and PresetColor or Color3.new(1, 1, 1)
                TweenService:Create(ToggleDot, TweenInfo.new(0.3), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
                pcall(callback, toggled)
            end

            Toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                update()
            end)
            update()
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end

        function content:Slider(text, min, max, default, callback)
            local Slider = Instance.new("Frame")
            local SliderCorner = Instance.new("UICorner")
            local SliderTitle = Instance.new("TextLabel")
            local SliderBar = Instance.new("Frame")
            local SliderFill = Instance.new("Frame")
            local SliderValue = Instance.new("TextLabel")

            Slider.Parent = Tab
            Slider.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            Slider.Size = UDim2.new(1, -10, 0, 65)
            SliderCorner.Parent = Slider

            SliderTitle.Size = UDim2.new(1, -20, 0, 30)
            SliderTitle.Position = UDim2.new(0, 10, 0, 5)
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Font = Enum.Font.Code
            SliderTitle.Text = text
            SliderTitle.TextColor3 = Color3.new(1, 1, 1)
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            SliderTitle.Parent = Slider

            SliderBar.Size = UDim2.new(1, -20, 0, 6)
            SliderBar.Position = UDim2.new(0, 10, 0, 45)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            SliderBar.Parent = Slider
            Instance.new("UICorner", SliderBar)

            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = PresetColor
            SliderFill.Parent = SliderBar
            Instance.new("UICorner", SliderFill)

            SliderValue.Size = UDim2.new(0, 50, 0, 30)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Font = Enum.Font.Code
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = PresetColor
            SliderValue.TextSize = 14
            SliderValue.Parent = Slider

            local dragging = false
            local function update()
                local percent = math.clamp((Mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderValue.Text = tostring(value)
                pcall(callback, value)
            end

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update()
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update()
                end
            end)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end

        return content
    end

    function lib:Init(Database)
        self:Boot(function()
            local MainWin = self:Window("AP6 HUB // Universal", PresetColor, CloseBind)
            local GameTab = MainWin:Tab("Game List")
            for id, data in pairs(Database) do
                local current = (game.PlaceId == id)
                local btn_text = current and "[DETECTED] " .. data.name or "[LOCKED] " .. data.name
                GameTab:Button(btn_text, function()
                    if current then
                        self:Notify("SYSTEM", "Executing Payload for " .. data.name)
                        if data.url then loadstring(game:HttpGet(data.url))() end
                        if data.onExecute then data.onExecute() end
                    else
                        self:Notify("ERROR", "Incompatible game module.")
                    end
                end)
            end
            local Settings = MainWin:Tab("Settings")
            Settings:Slider("WalkSpeed", 16, 250, 16, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)
            Settings:Button("Destroy UI", function() ui:Destroy() end)
        end)
    end

    local tab_handler = {}
    function tab_handler:Tab(text)
        return CreateTab(text)
    end
    return tab_handler
end

return lib
