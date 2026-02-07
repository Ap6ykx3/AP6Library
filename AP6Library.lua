local lib = {RainbowColorValue = 0, HueSelectionPosition = 0}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PresetColor = Color3.fromRGB(0, 255, 255)
local CloseBind = Enum.KeyCode.RightControl

coroutine.wrap(function()
    while wait() do
        lib.RainbowColorValue = lib.RainbowColorValue + 1 / 255
        lib.HueSelectionPosition = lib.HueSelectionPosition + 1
        if lib.RainbowColorValue >= 1 then lib.RainbowColorValue = 0 end
        if lib.HueSelectionPosition == 80 then lib.HueSelectionPosition = 0 end
    end
end)()

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

function lib:Boot(callback)
    local BootGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    BootGui.Name = "AP6_BOOTLOADER"
    BootGui.IgnoreGuiInset = true
    local Canvas = Instance.new("CanvasGroup", BootGui)
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundColor3 = Color3.new(0,0,0)
    local Logo = Instance.new("TextLabel", Canvas)
    Logo.Size = UDim2.new(1, 0, 0, 150)
    Logo.Position = UDim2.new(0, 0, 0.4, -75)
    Logo.BackgroundTransparency = 1
    Logo.Text = "AP6 HUB"
    Logo.TextColor3 = PresetColor
    Logo.Font = Enum.Font.Code
    Logo.TextSize = 140
    Logo.TextTransparency = 1
    Logo.TextScaled = true
    local BarBG = Instance.new("Frame", Canvas)
    BarBG.Size = UDim2.new(0.4, 0, 0, 4)
    BarBG.Position = UDim2.new(0.5, 0, 0.5, 60)
    BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BarBG.AnchorPoint = Vector2.new(0.5, 0.5)
    BarBG.BorderSizePixel = 0
    local BarFill = Instance.new("Frame", BarBG)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = PresetColor
    BarFill.BorderSizePixel = 0
    local Terminal = Instance.new("ScrollingFrame", Canvas)
    Terminal.Size = UDim2.new(0.5, 0, 0.25, 0)
    Terminal.Position = UDim2.new(0.25, 0, 0.7, 0)
    Terminal.BackgroundTransparency = 1
    Terminal.ScrollBarThickness = 0
    Instance.new("UIListLayout", Terminal).VerticalAlignment = 2
    TweenService:Create(Logo, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
    TweenService:Create(BarFill, TweenInfo.new(4), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.spawn(function()
        local logs = {"ACCESSING_SERVER", "BYPASSING_AC", "LOADING_UI", "CLEANING_LOGS", "SYSTEM_READY"}
        for i = 1, 100 do
            local l = Instance.new("TextLabel", Terminal)
            l.Size = UDim2.new(1, 0, 0, 18)
            l.BackgroundTransparency = 1
            l.Text = "ap6@root:~# " .. logs[math.random(1,#logs)] .. " ["..i.."%]"
            l.TextColor3 = Color3.fromRGB(0, 255, 120)
            l.Font = Enum.Font.Code
            l.TextSize = 13
            l.TextXAlignment = 0
            Terminal.CanvasPosition = Vector2.new(0, 9999)
            task.wait(0.02)
        end
    end)
    task.wait(4.2)
    for i = 1, 15 do
        Canvas.Position = UDim2.new(0, math.random(-8,8), 0, math.random(-8,8))
        task.wait(0.01)
    end
    TweenService:Create(Canvas, TweenInfo.new(0.6), {GroupTransparency = 1}):Play()
    task.wait(0.6)
    BootGui:Destroy()
    callback()
end

function lib:Notify(title, text)
    local NotifyGui = game:GetService("CoreGui"):FindFirstChild("AP6_NOTIF") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    NotifyGui.Name = "AP6_NOTIF"
    local Holder = NotifyGui:FindFirstChild("H") or Instance.new("Frame", NotifyGui)
    if not NotifyGui:FindFirstChild("H") then
        Holder.Name = "H"
        Holder.Size = UDim2.new(0, 300, 1, -40)
        Holder.Position = UDim2.new(1, -310, 0, 20)
        Holder.BackgroundTransparency = 1
        local L = Instance.new("UIListLayout", Holder)
        L.VerticalAlignment = 2
        L.Padding = UDim.new(0, 10)
    end
    local Box = Instance.new("CanvasGroup", Holder)
    Box.Size = UDim2.new(1, 0, 0, 85)
    Box.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    Box.GroupTransparency = 1
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", Box)
    s.Thickness = 2
    s.Color = PresetColor
    local t1 = Instance.new("TextLabel", Box)
    t1.Size = UDim2.new(1, -20, 0, 30)
    t1.Position = UDim2.new(0, 10, 0, 5)
    t1.BackgroundTransparency = 1
    t1.Text = ">> " .. title:upper()
    t1.TextColor3 = PresetColor
    t1.Font = Enum.Font.Code
    t1.TextSize = 15
    t1.TextXAlignment = 0
    local t2 = Instance.new("TextLabel", Box)
    t2.Size = UDim2.new(1, -20, 0, 45)
    t2.Position = UDim2.new(0, 10, 0, 35)
    t2.BackgroundTransparency = 1
    t2.Text = text
    t2.TextColor3 = Color3.new(1,1,1)
    t2.Font = Enum.Font.Code
    t2.TextSize = 12
    t2.TextWrapped = true
    t2.TextXAlignment = 0
    t2.TextYAlignment = 0
    TweenService:Create(Box, TweenInfo.new(0.5, 6), {GroupTransparency = 0}):Play()
    task.delay(5, function()
        local tw = TweenService:Create(Box, TweenInfo.new(0.5), {GroupTransparency = 1})
        tw:Play()
        tw.Completed:Wait()
        Box:Destroy()
    end)
end

function lib:Window(text, preset, closebind)
    CloseBind = closebind or Enum.KeyCode.RightControl
    PresetColor = preset or Color3.fromRGB(0, 255, 255)
    local ui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ui.Name = "AP6_UI_MAIN"
    local Main = Instance.new("Frame", ui)
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
    Main.Position = UDim2.new(0.5, -325, 0.5, -200)
    Main.Size = UDim2.new(0, 650, 0, 400)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MS = Instance.new("UIStroke", Main)
    MS.Color = PresetColor
    MS.Thickness = 2.5
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 50)
    Top.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    local Title = Instance.new("TextLabel", Top)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(1, -160, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Code
    Title.Text = text:upper()
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextSize = 16
    Title.TextXAlignment = 0
    local Mini = Instance.new("TextButton", Top)
    Mini.Size = UDim2.new(0, 30, 0, 30)
    Mini.Position = UDim2.new(1, -75, 0.5, -15)
    Mini.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Mini.Text = "-"
    Mini.TextColor3 = Color3.new(1,1,1)
    Mini.Font = Enum.Font.Code
    Mini.TextSize = 25
    Instance.new("UICorner", Mini).CornerRadius = UDim.new(1, 0)
    local Close = Instance.new("TextButton", Top)
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -40, 0.5, -15)
    Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    Close.Text = "×"
    Close.TextColor3 = Color3.new(1,1,1)
    Close.Font = Enum.Font.Code
    Close.TextSize = 25
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
    local Res = Instance.new("ImageButton", ui)
    Res.Size = UDim2.new(0, 65, 0, 65)
    Res.Position = UDim2.new(0.02, 0, 0.88, 0)
    Res.BackgroundColor3 = Color3.fromRGB(5,5,8)
    Res.Image = "rbxassetid://1469746722623328286"
    Res.Visible = false
    Instance.new("UICorner", Res).CornerRadius = UDim.new(1,0)
    local rs = Instance.new("UIStroke", Res)
    rs.Color = PresetColor
    rs.Thickness = 2
    Mini.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.5, 6), {Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.02, 0, 0.95, 0)}):Play()
        task.wait(0.5)
        Main.Visible = false
        Res.Visible = true
    end)
    Res.MouseButton1Click:Connect(function()
        Res.Visible = false
        Main.Visible = true
        TweenService:Create(Main, TweenInfo.new(0.5, 6), {Size = UDim2.new(0, 650, 0, 400), Position = UDim2.new(0.5, -325, 0.5, -200)}):Play()
    end)
    Close.MouseButton1Click:Connect(function() ui:Destroy() end)
    MakeDraggable(Top, Main)
    local TabHold = Instance.new("Frame", Main)
    TabHold.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    TabHold.Position = UDim2.new(0, 0, 0, 50)
    TabHold.Size = UDim2.new(0, 180, 1, -50)
    local TabHoldLayout = Instance.new("UIListLayout", TabHold)
    TabHoldLayout.Padding = UDim.new(0, 8)
    TabHoldLayout.HorizontalAlignment = 1
    local TabFolder = Instance.new("Folder", Main)
    local function CreateTab(n)
        local TabBtn = Instance.new("TextButton", TabHold)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        TabBtn.Text = n:upper()
        TabBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
        TabBtn.Font = Enum.Font.Code
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        local TabBtnStroke = Instance.new("UIStroke", TabBtn)
        TabBtnStroke.Color = Color3.fromRGB(40,40,45)
        local Tab = Instance.new("ScrollingFrame", TabFolder)
        Tab.Size = UDim2.new(0, 440, 0, 320)
        Tab.Position = UDim2.new(0, 195, 0, 65)
        Tab.BackgroundTransparency = 1
        Tab.Visible = false
        Tab.ScrollBarThickness = 2
        local TabLayout = Instance.new("UIListLayout", Tab)
        TabLayout.Padding = UDim.new(0, 10)
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(TabFolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabHold:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(140,140,140) v.UIStroke.Color = Color3.fromRGB(40,40,45) end end
            Tab.Visible = true
            TabBtn.TextColor3 = PresetColor
            TabBtnStroke.Color = PresetColor
        end)
        if #TabFolder:GetChildren() == 1 then Tab.Visible = true TabBtn.TextColor3 = PresetColor TabBtnStroke.Color = PresetColor end
        local c = {}
        function c:Button(txt, cb)
            local Button = Instance.new("TextButton", Tab)
            Button.Size = UDim2.new(1, -10, 0, 45)
            Button.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            Button.Text = "  " .. txt
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Code
            Button.TextSize = 14
            Button.TextXAlignment = 0
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            local s = Instance.new("UIStroke", Button)
            s.Color = Color3.fromRGB(45, 45, 50)
            Button.MouseButton1Click:Connect(cb)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end
        function c:Toggle(txt, def, cb)
            local st = def
            local bg = Instance.new("TextButton", Tab)
            bg.Size = UDim2.new(1, -10, 0, 45)
            bg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            bg.Text = "  " .. txt
            bg.TextColor3 = Color3.new(1,1,1)
            bg.Font = Enum.Font.Code
            bg.TextSize = 14
            bg.TextXAlignment = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
            local box = Instance.new("Frame", bg)
            box.Size = UDim2.new(0, 40, 0, 20)
            box.Position = UDim2.new(1, -50, 0.5, -10)
            box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            Instance.new("UICorner", box).CornerRadius = UDim.new(1,0)
            local dot = Instance.new("Frame", box)
            dot.Size = UDim2.new(0, 16, 0, 16)
            dot.Position = UDim2.new(0, 2, 0.5, -8)
            dot.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
            local function up()
                dot.Position = st and UDim2.new(0, 22, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                dot.BackgroundColor3 = st and PresetColor or Color3.new(1,1,1)
                cb(st)
            end
            bg.MouseButton1Click:Connect(function() st = not st up() end)
            up()
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end
        function c:Slider(txt, min, max, def, cb)
            local bg = Instance.new("Frame", Tab)
            bg.Size = UDim2.new(1, -10, 0, 65)
            bg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel", bg)
            lbl.Text = txt
            lbl.Size = UDim2.new(1, -20, 0, 30)
            lbl.Position = UDim2.new(0, 10, 0, 5)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.new(1,1,1)
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 14
            lbl.TextXAlignment = 0
            local bar = Instance.new("Frame", bg)
            bar.Size = UDim2.new(1, -20, 0, 6)
            bar.Position = UDim2.new(0, 10, 0, 45)
            bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = PresetColor
            local val = Instance.new("TextLabel", bg)
            val.Text = tostring(def)
            val.Size = UDim2.new(0, 50, 0, 30)
            val.Position = UDim2.new(1, -60, 0, 5)
            val.BackgroundTransparency = 1
            val.TextColor3 = PresetColor
            val.Font = Enum.Font.Code
            local drag = false
            local function up()
                local p = math.clamp((Mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max-min)*p)
                fill.Size = UDim2.new(p, 0, 1, 0)
                val.Text = tostring(v)
                cb(v)
            end
            bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true up() end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
            UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then up() end end)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end
        function c:Bind(txt, def, cb)
            local Key = def.Name
            local binding = false
            local bg = Instance.new("TextButton", Tab)
            bg.Size = UDim2.new(1, -10, 0, 45)
            bg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            bg.Text = "  " .. txt
            bg.TextColor3 = Color3.new(1,1,1)
            bg.Font = Enum.Font.Code
            bg.TextSize = 14
            bg.TextXAlignment = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
            local BindText = Instance.new("TextLabel", bg)
            BindText.Size = UDim2.new(0, 100, 1, 0)
            BindText.Position = UDim2.new(1, -110, 0, 0)
            BindText.BackgroundTransparency = 1
            BindText.Text = "[" .. Key .. "]"
            BindText.TextColor3 = PresetColor
            BindText.Font = Enum.Font.Code
            BindText.TextSize = 14
            BindText.TextXAlignment = 2
            bg.MouseButton1Click:Connect(function()
                BindText.Text = "[...]"
                binding = true
                local inputwait = game:GetService("UserInputService").InputBegan:wait()
                if inputwait.KeyCode.Name ~= "Unknown" then
                    Key = inputwait.KeyCode.Name
                    BindText.Text = "[" .. Key .. "]"
                    binding = false
                end
            end)
            game:GetService("UserInputService").InputBegan:connect(function(current, pressed)
                if not pressed and current.KeyCode.Name == Key and binding == false then
                    pcall(cb)
                end
            end)
            Tab.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y)
        end
        return c
    end
    local h = {}
    function h:Tab(n) return CreateTab(n) end
    function h:Init(db)
        lib:Boot(function()
            local Window = lib:Window("AP6 HUB", PresetColor, CloseBind)
            local Games = Window:Tab("Game List")
            for id, data in pairs(db) do
                local cur = (game.PlaceId == id)
                Games:Button(cur and ">> EXECUTE: "..data.name or data.name.." [LOCKED]", function()
                    if cur then
                        lib:Notify("SYSTEM", "Loading module: " .. data.name)
                        if data.url then loadstring(game:HttpGet(data.url))() end
                        if data.onExecute then data.onExecute() end
                    else
                        lib:Notify("ERROR", "Join the correct game.")
                    end
                end)
            end
            local Settings = Window:Tab("Settings")
            Settings:Bind("Close Menu", CloseBind, function() ui.Enabled = not ui.Enabled end)
            local Credits = Window:Tab("Credits")
            Credits:Button("Dev: AP6 Team", function() end)
            Credits:Button("Status: Operational", function() end)
        end)
    end
    return h
end
return lib
