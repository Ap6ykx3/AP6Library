local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(10, 10, 14),
        Secondary = Color3.fromRGB(15, 15, 22),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 65, 65),
        Outline = Color3.fromRGB(40, 40, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Executor = (identifyexecutor and identifyexecutor()) or "Standard Environment"
}

function AP6:Tween(obj, time, goal)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local anim = TweenService:Create(obj, info, goal)
    anim:Play()
    return anim
end

function AP6:Confetti()
    local container = Instance.new("ScreenGui", PlayerGui)
    container.Name = "AP6_FX"
    for i = 1, 75 do
        task.spawn(function()
            local p = Instance.new("Frame", container)
            p.Size = UDim2.new(0, math.random(5, 10), 0, math.random(5, 10))
            p.Position = UDim2.new(math.random(), 0, -0.1, 0)
            p.BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1)
            p.BorderSizePixel = 0
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            
            local drift = math.random(-150, 150) / 1000
            local fall = self:Tween(p, math.random(2, 4), {
                Position = UDim2.new(p.Position.X.Scale + drift, 0, 1.1, 0),
                Rotation = math.random(0, 720)
            })
            fall.Completed:Wait()
            p:Destroy()
        end)
    end
    task.delay(5, function() container:Destroy() end)
end

function AP6:Notify(title, msg, dur)
    local gui = PlayerGui:FindFirstChild("AP6_NOTIF_SYSTEM") or Instance.new("ScreenGui", PlayerGui)
    gui.Name = "AP6_NOTIF_SYSTEM"
    gui.IgnoreGuiInset = true

    local holder = gui:FindFirstChild("Holder") or Instance.new("Frame", gui)
    holder.Name = "Holder"
    holder.Size = UDim2.new(0, 300, 1, -20)
    holder.Position = UDim2.new(1, -310, 0, 10)
    holder.BackgroundTransparency = 1
    
    if not holder:FindFirstChild("Layout") then
        local l = Instance.new("UIListLayout", holder)
        l.Name = "Layout"
        l.VerticalAlignment = Enum.VerticalAlignment.Bottom
        l.Padding = UDim.new(0, 10)
    end

    local card = Instance.new("CanvasGroup", holder)
    card.Size = UDim2.new(1, 0, 0, 75)
    card.BackgroundColor3 = self.Theme.Secondary
    card.GroupTransparency = 1
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = self.Theme.Accent
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local tHeader = Instance.new("TextLabel", card)
    tHeader.Size = UDim2.new(1, -20, 0, 30)
    tHeader.Position = UDim2.new(0, 12, 0, 8)
    tHeader.BackgroundTransparency = 1
    tHeader.Text = title:upper()
    tHeader.TextColor3 = self.Theme.Accent
    tHeader.Font = Enum.Font.Code
    tHeader.TextSize = 14
    tHeader.TextXAlignment = Enum.TextXAlignment.Left

    local tBody = Instance.new("TextLabel", card)
    tBody.Size = UDim2.new(1, -24, 0, 30)
    tBody.Position = UDim2.new(0, 12, 0, 35)
    tBody.BackgroundTransparency = 1
    tBody.Text = msg
    tBody.TextColor3 = Color3.new(1, 1, 1)
    tBody.Font = Enum.Font.Code
    tBody.TextSize = 11
    tBody.TextXAlignment = Enum.TextXAlignment.Left
    tBody.TextWrapped = true

    self:Tween(card, 0.5, {GroupTransparency = 0})
    task.delay(dur or 3, function()
        local close = self:Tween(card, 0.5, {GroupTransparency = 1})
        close.Completed:Wait()
        card:Destroy()
    end)
end

function AP6:Boot(callback)
    local screen = Instance.new("ScreenGui", PlayerGui)
    screen.IgnoreGuiInset = true
    
    local canvas = Instance.new("CanvasGroup", screen)
    canvas.Size = UDim2.new(1, 0, 1, 0)
    canvas.BackgroundColor3 = Color3.fromRGB(2, 2, 4)
    canvas.GroupTransparency = 0

    local logo = Instance.new("TextLabel", canvas)
    logo.Size = UDim2.new(1, 0, 0, 100)
    logo.Position = UDim2.new(0, 0, 0.4, -50)
    logo.BackgroundTransparency = 1
    logo.Text = "SYSTEM_LOADER_V4"
    logo.TextColor3 = self.Theme.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 50
    logo.TextTransparency = 1

    local barBg = Instance.new("Frame", canvas)
    barBg.Size = UDim2.new(0, 300, 0, 4)
    barBg.Position = UDim2.new(0.5, -150, 0.5, 20)
    barBg.BackgroundColor3 = self.Theme.Outline
    barBg.BorderSizePixel = 0
    
    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = self.Theme.Accent
    barFill.BorderSizePixel = 0

    self:Tween(logo, 1, {TextTransparency = 0})
    local load = self:Tween(barFill, 2.5, {Size = UDim2.new(1, 0, 1, 0)})
    load.Completed:Wait()
    
    task.wait(0.5)
    local fade = self:Tween(canvas, 0.8, {GroupTransparency = 1})
    fade.Completed:Wait()
    screen:Destroy()
    callback()
end

function AP6:Init(games)
    self:Boot(function()
        self:Confetti()
        self:Notify("AUTHORIZED", "Identity: " .. Player.Name, 4)

        local mainGui = Instance.new("ScreenGui", PlayerGui)
        mainGui.Name = "AP6_HUB"
        
        local frame = Instance.new("CanvasGroup", mainGui)
        frame.Size = UDim2.new(0, 600, 0, 400)
        frame.Position = UDim2.new(0.5, -300, 0.5, -200)
        frame.BackgroundColor3 = self.Theme.Main
        frame.GroupTransparency = 1
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = self.Theme.Outline
        frameStroke.Thickness = 2
        frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local topBar = Instance.new("Frame", frame)
        topBar.Size = UDim2.new(1, 0, 0, 45)
        topBar.BackgroundColor3 = self.Theme.Secondary
        topBar.BorderSizePixel = 0

        local title = Instance.new("TextLabel", topBar)
        title.Size = UDim2.new(1, -150, 1, 0)
        title.Position = UDim2.new(0, 20, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "TERMINAL // " .. self.Executor:upper()
        title.TextColor3 = self.Theme.Cyan
        title.Font = Enum.Font.Code
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left

        local closeBtn = Instance.new("TextButton", topBar)
        closeBtn.Size = UDim2.new(0, 45, 0, 45)
        closeBtn.Position = UDim2.new(1, -45, 0, 0)
        closeBtn.Text = "✕"
        closeBtn.BackgroundColor3 = self.Theme.Red
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Font = Enum.Font.Code
        closeBtn.TextSize = 18
        closeBtn.BorderSizePixel = 0

        local minBtn = Instance.new("TextButton", topBar)
        minBtn.Size = UDim2.new(0, 45, 0, 45)
        minBtn.Position = UDim2.new(1, -90, 0, 0)
        minBtn.Text = "—"
        minBtn.BackgroundColor3 = self.Theme.Outline
        minBtn.TextColor3 = Color3.new(1, 1, 1)
        minBtn.Font = Enum.Font.Code
        minBtn.TextSize = 18
        minBtn.BorderSizePixel = 0

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1, -30, 1, -70)
        scroll.Position = UDim2.new(0, 15, 0, 60)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 2
        scroll.ScrollBarImageColor3 = self.Theme.Accent
        
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 12)

        for id, data in pairs(games) do
            local isCurrent = (tonumber(id) == game.PlaceId)
            local item = Instance.new("Frame", scroll)
            item.Size = UDim2.new(1, -10, 0, 60)
            item.BackgroundColor3 = self.Theme.Secondary
            Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
            local itemStroke = Instance.new("UIStroke", item)
            itemStroke.Color = isCurrent and self.Theme.Accent or self.Theme.Outline
            itemStroke.Thickness = 1

            local nameLabel = Instance.new("TextLabel", item)
            nameLabel.Size = UDim2.new(1, -140, 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = data.name:upper()
            nameLabel.TextColor3 = isCurrent and Color3.new(1, 1, 1) or Color3.fromRGB(130, 130, 140)
            nameLabel.Font = Enum.Font.Code
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local execBtn = Instance.new("TextButton", item)
            execBtn.Size = UDim2.new(0, 110, 0, 34)
            execBtn.Position = UDim2.new(1, -125, 0.5, -17)
            execBtn.BackgroundColor3 = isCurrent and self.Theme.Accent or Color3.fromRGB(30, 30, 35)
            execBtn.Text = isCurrent and "LAUNCH" or "LOCKED"
            execBtn.TextColor3 = isCurrent and Color3.new(0, 0, 0) or Color3.fromRGB(90, 90, 90)
            execBtn.Font = Enum.Font.Code
            execBtn.TextSize = 12
            Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0, 4)

            execBtn.MouseButton1Click:Connect(function()
                if isCurrent then
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                else
                    self:Notify("SECURITY", "Incompatible Simulation Environment", 3)
                end
            end)
        end

        local minimized = false
        minBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            local targetSize = minimized and UDim2.new(0, 600, 0, 45) or UDim2.new(0, 600, 0, 400)
            self:Tween(frame, 0.5, {Size = targetSize})
            scroll.Visible = not minimized
        end)

        closeBtn.MouseButton1Click:Connect(function()
            local hide = self:Tween(frame, 0.5, {GroupTransparency = 1})
            hide.Completed:Wait()
            mainGui:Destroy()
        end)

        -- Draggable Logic
        local drag, startPos, dragStart
        topBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                dragStart = i.Position
                startPos = frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
        end)

        self:Tween(frame, 0.8, {GroupTransparency = 0})
    end)
end

return AP6
