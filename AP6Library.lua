local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Theme = {
        Main = Color3.fromRGB(8, 8, 12),
        Secondary = Color3.fromRGB(12, 12, 20),
        Accent = Color3.fromRGB(0, 255, 150),
        Cyan = Color3.fromRGB(0, 255, 255),
        Red = Color3.fromRGB(255, 50, 70),
        Orange = Color3.fromRGB(255, 160, 0),
        Outline = Color3.fromRGB(40, 40, 55),
        Text = Color3.fromRGB(255, 255, 255),
        DarkText = Color3.fromRGB(150, 150, 160)
    },
    Executor = (identifyexecutor and identifyexecutor()) or "Unknown Kernel",
    IsRunning = true
}

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

function AP6:GetSfx(id)
    local s = Create("Sound", {
        SoundId = "rbxassetid://" .. tostring(id),
        Volume = 0.5,
        Parent = SoundService
    })
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

function AP6:SmoothTween(obj, time, goal, style)
    local t = TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

function AP6:CreateConfetti()
    local g = Create("ScreenGui", {Name = "AP6_FX", DisplayOrder = 999}, PlayerGui)
    for i = 1, 120 do
        task.spawn(function()
            local p = Create("Frame", {
                Size = UDim2.new(0, math.random(5, 12), 0, math.random(5, 12)),
                Position = UDim2.new(math.random(), 0, -0.1, 0),
                BackgroundColor3 = Color3.fromHSV(math.random(), 0.7, 1),
                BorderSizePixel = 0,
                Rotation = math.random(0, 360)
            }, g)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, p)
            
            local t = self:SmoothTween(p, math.random(2, 5), {
                Position = UDim2.new(p.Position.X.Scale + math.random(-0.2, 0.2), 0, 1.1, 0),
                Rotation = math.random(0, 1500)
            })
            t.Completed:Wait()
            p:Destroy()
        end)
    end
    task.delay(6, function() g:Destroy() end)
end

function AP6:Notify(title, msg, dur)
    local g = PlayerGui:FindFirstChild("AP6_NOTIF_HOST") or Create("ScreenGui", {Name = "AP6_NOTIF_HOST", IgnoreGuiInset = true}, PlayerGui)
    local h = g:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.size(0, 320, 1, -40), Position = UDim2.new(1, -330, 0, 20), BackgroundTransparency = 1}, g)
    if not h:FindFirstChild("UIListLayout") then 
        Create("UIListLayout", {VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 12)}, h)
    end

    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 0, 80), BackgroundColor3 = self.Theme.Secondary, GroupTransparency = 1}, h)
    Create("UICorner", {CornerRadius = UDim.new(0, 8)}, c)
    Create("UIStroke", {Color = self.Theme.Accent, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1.5}, c)

    Create("TextLabel", {Size = UDim2.new(1, -30, 0, 30), Position = UDim2.new(0, 15, 0, 10), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = self.Theme.Accent, Font = Enum.Font.Code, TextSize = 14, TextXAlignment = 0}, c)
    Create("TextLabel", {Size = UDim2.new(1, -30, 0, 35), Position = UDim2.new(0, 15, 0, 35), BackgroundTransparency = 1, Text = msg, TextColor3 = self.Theme.Text, Font = Enum.Font.Code, TextSize = 11, TextXAlignment = 0, TextWrapped = true}, c)

    self:GetSfx(6543431344)
    self:SmoothTween(c, 0.6, {GroupTransparency = 0})
    task.delay(dur or 4, function()
        self:SmoothTween(c, 0.6, {GroupTransparency = 1}).Completed:Wait()
        c:Destroy()
    end)
end

function AP6:Boot(callback)
    local g = Create("ScreenGui", {IgnoreGuiInset = true}, PlayerGui)
    local c = Create("CanvasGroup", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0), GroupTransparency = 0}, g)
    
    local logo = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 100), Position = UDim2.new(0, 0, 0.45, -50), BackgroundTransparency = 1, Text = "AP6_EXECUTIVE_OS", TextColor3 = self.Theme.Cyan, Font = Enum.Font.Code, TextSize = 70, TextTransparency = 1}, c)
    local barFrame = Create("Frame", {Size = UDim2.new(0, 450, 0, 2), Position = UDim2.new(0.5, -225, 0.5, 30), BackgroundColor3 = self.Theme.Outline, BorderSizePixel = 0}, c)
    local fill = Create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = self.Theme.Accent, BorderSizePixel = 0}, barFrame)
    local log = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, 45), BackgroundTransparency = 1, Text = "AUTHENTICATING...", TextColor3 = self.Theme.DarkText, Font = Enum.Font.Code, TextSize = 12, TextTransparency = 1}, c)

    self:GetSfx(1324546452)
    self:SmoothTween(logo, 1.2, {TextTransparency = 0})
    self:SmoothTween(log, 1.2, {TextTransparency = 0})
    
    local stages = {"INITIALIZING_KERNEL", "BYPASSING_INTEGRITY", "STAGING_UI_ENVIRONMENT", "READY_FOR_INJECTION"}
    for i, stage in ipairs(stages) do
        log.Text = "> " .. stage .. "..."
        self:SmoothTween(fill, 0.7, {Size = UDim2.new(i/#stages, 0, 1, 0)}).Completed:Wait()
        task.wait(0.2)
    end

    self:GetSfx(5236242203)
    self:SmoothTween(c, 1, {GroupTransparency = 1}).Completed:Wait()
    g:Destroy()
    callback()
end

function AP6:Init(games)
    self:Boot(function()
        self:CreateConfetti()
        self:Notify("SUCCESS", "System Authorized: " .. self.Executor, 5)

        local mainGui = Create("ScreenGui", {Name = "AP6_HUB"}, PlayerGui)
        local frame = Create("CanvasGroup", {Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 0.5, -240), BackgroundColor3 = self.Theme.Main, GroupTransparency = 1}, mainGui)
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}, frame)
        local frameStroke = Create("UIStroke", {Color = self.Theme.Outline, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)

        local topBar = Create("Frame", {Size = UDim2.new(1, 0, 0, 55), BackgroundColor3 = self.Theme.Secondary, BorderSizePixel = 0}, frame)
        Create("TextLabel", {Size = UDim2.new(1, -150, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Text = "AP6 HUB // " .. self.Executor:upper(), TextColor3 = self.Theme.Cyan, Font = Enum.Font.Code, TextSize = 15, TextXAlignment = 0}, topBar)

        local close = Create("TextButton", {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(1, -55, 0, 0), Text = "X", BackgroundColor3 = self.Theme.Red, TextColor3 = self.Theme.Text, Font = Enum.Font.Code, TextSize = 22, BorderSizePixel = 0, AutoButtonColor = false}, topBar)
        local min = Create("TextButton", {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(1, -110, 0, 0), Text = "—", BackgroundColor3 = self.Theme.Outline, TextColor3 = self.Theme.Text, Font = Enum.Font.Code, TextSize = 22, BorderSizePixel = 0, AutoButtonColor = false}, topBar)

        local sidebar = Create("Frame", {Size = UDim2.new(0, 200, 1, -55), Position = UDim2.new(0, 0, 0, 55), BackgroundColor3 = Color3.fromRGB(6, 6, 10), BorderSizePixel = 0}, frame)
        local scroll = Create("ScrollingFrame", {Size = UDim2.new(1, -230, 1, -85), Position = UDim2.new(0, 215, 0, 70), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = self.Theme.Accent}, frame)
        Create("UIListLayout", {Padding = UDim.new(0, 12)}, scroll)

        -- [ LEGEND SECTION ]
        local legCont = Create("Frame", {Size = UDim2.new(1, -30, 1, -40), Position = UDim2.new(0, 15, 0, 20), BackgroundTransparency = 1}, sidebar)
        Create("UIListLayout", {Padding = UDim.new(0, 20)}, legCont)
        Create("TextLabel", {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "STATUS LEGEND", TextColor3 = self.Theme.Accent, Font = Enum.Font.Code, TextSize = 16, TextXAlignment = 0}, legCont)

        local function AddStatusInfo(color, txt)
            local row = Create("Frame", {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1}, legCont)
            local d = Create("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0, 0, 0.5, -6), BackgroundColor3 = color, BorderSizePixel = 0}, row)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, d)
            Create("TextLabel", {Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 25, 0, 0), BackgroundTransparency = 1, Text = txt, TextColor3 = self.Theme.DarkText, Font = Enum.Font.Code, TextSize = 12, TextXAlignment = 0}, row)
        end

        AddStatusInfo(self.Theme.Accent, "Authorized Game")
        AddStatusInfo(self.Theme.Red, "Unverified Environment")
        AddStatusInfo(self.Theme.Orange, "Under Maintenance")

        -- [ GAMES INJECTION ]
        for id, data in pairs(games) do
            local isMatch = (tonumber(id) == game.PlaceId)
            local dotCol = isMatch and self.Theme.Accent or (data.Maintenance and self.Theme.Orange or self.Theme.Red)
            
            local card = Create("Frame", {Size = UDim2.new(1, -10, 0, 75), BackgroundColor3 = self.Theme.Secondary}, scroll)
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}, card)
            local cardStroke = Create("UIStroke", {Color = isMatch and self.Theme.Accent or self.Theme.Outline, Thickness = 1.5}, card)

            local statusDot = Create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 15, 0.5, -7), BackgroundColor3 = dotCol, BorderSizePixel = 0}, card)
            Create("UICorner", {CornerRadius = UDim.new(1, 0)}, statusDot)
            
            if isMatch then
                task.spawn(function()
                    while task.wait(0.7) do
                        self:SmoothTween(statusDot, 0.4, {BackgroundTransparency = 0.6}).Completed:Wait()
                        self:SmoothTween(statusDot, 0.4, {BackgroundTransparency = 0}).Completed:Wait()
                    end
                end)
            end

            Create("TextLabel", {Size = UDim2.new(1, -180, 1, 0), Position = UDim2.new(0, 45, 0, 0), BackgroundTransparency = 1, Text = data.name:upper(), TextColor3 = self.Theme.Text, Font = Enum.Font.Code, TextSize = 14, TextXAlignment = 0}, card)

            local inject = Create("TextButton", {Size = UDim2.new(0, 110, 0, 38), Position = UDim2.new(1, -125, 0.5, -19), BackgroundColor3 = isMatch and self.Theme.Accent or Color3.fromRGB(20, 20, 30), Text = isMatch and "INJECT" or "LOCKED", TextColor3 = isMatch and Color3.new(0,0,0) or self.Theme.DarkText, Font = Enum.Font.Code, TextSize = 13, AutoButtonColor = false}, card)
            Create("UICorner", {CornerRadius = UDim.new(0, 6)}, inject)

            inject.MouseButton1Click:Connect(function()
                if isMatch then
                    self:GetSfx(12222242)
                    if data.onExecute then data.onExecute() end
                    if data.url then loadstring(game:HttpGet(data.url))() end
                else
                    self:Notify("ERROR", "Access Denied: Game ID Mismatch", 3)
                end
            end)
        end

        local isMinimized = false
        min.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            self:SmoothTween(frame, 0.6, {Size = isMinimized and UDim2.new(0, 700, 0, 55) or UDim2.new(0, 700, 0, 480)})
            scroll.Visible = not isMinimized
            sidebar.Visible = not isMinimized
        end)

        close.MouseButton1Click:Connect(function()
            self:GetSfx(1324546452)
            self:SmoothTween(frame, 0.7, {GroupTransparency = 1}).Completed:Wait()
            mainGui:Destroy()
        end)

        -- [ DRAGGABLE LOGIC ]
        local dragging, startPos, dragStart
        topBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = frame.Position end end)
        UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

        self:SmoothTween(frame, 1.2, {GroupTransparency = 0})
    end)
end

return AP6
