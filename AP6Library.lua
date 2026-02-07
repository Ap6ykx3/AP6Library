local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local AP6 = {}


AP6.Colors = {
    Background = Color3.fromRGB(10, 10, 12),
    Secondary = Color3.fromRGB(15, 15, 18),
    Primary = Color3.fromRGB(255, 0, 45),
    Accent = Color3.fromRGB(200, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Grey = Color3.fromRGB(150, 150, 150)
}

local Gui = Instance.new("ScreenGui")
Gui.Name = "AP6_TERMINATOR_UI"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 100
Gui.Parent = Player:WaitForChild("PlayerGui")


local NotifyHolder = Instance.new("Frame", Gui)
NotifyHolder.Size = UDim2.new(0, 300, 1, -40)
NotifyHolder.Position = UDim2.new(1, -310, 0, 20)
NotifyHolder.BackgroundTransparency = 1

local NotifyLayout = Instance.new("UIListLayout", NotifyHolder)
NotifyLayout.Padding = UDim.new(0, 10)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right


function AP6:Notify(title, text, time)
    time = time or 4

    local Frame = Instance.new("Frame", NotifyHolder)
    Frame.Size = UDim2.new(0, 0, 0, 70)
    Frame.BackgroundColor3 = AP6.Colors.Background
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 4)

    
    local StatusLine = Instance.new("Frame", Frame)
    StatusLine.Size = UDim2.new(0, 4, 1, 0)
    StatusLine.BackgroundColor3 = AP6.Colors.Primary
    StatusLine.BorderSizePixel = 0

    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = AP6.Colors.Primary
    UIStroke.Thickness = 1.2
    UIStroke.Transparency = 0.6

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, -30, 0, 25)
    Title.Position = UDim2.new(0, 15, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = title:upper()
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = AP6.Colors.Primary

    local Desc = Instance.new("TextLabel", Frame)
    Desc.Size = UDim2.new(1, -30, 0, 30)
    Desc.Position = UDim2.new(0, 15, 0, 32)
    Desc.BackgroundTransparency = 1
    Desc.Text = text
    Desc.Font = Enum.Font.GothamMedium
    Desc.TextSize = 12
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.TextColor3 = AP6.Colors.Text
    Desc.TextTransparency = 0.2

    
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 70)
    }):Play()

    task.delay(time, function()
        
        TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 70),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.45)
        Frame:Destroy()
    end)
end


function AP6:Confirm(title, text, callback)
    local Overlay = Instance.new("TextButton", Gui) 
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Text = ""
    Overlay.AutoButtonColor = false

    local Box = Instance.new("Frame", Overlay)
    Box.Size = UDim2.new(0, 340, 0, 190)
    Box.Position = UDim2.new(0.5, 0, 0.5, 0)
    Box.AnchorPoint = Vector2.new(0.5, 0.5)
    Box.BackgroundColor3 = AP6.Colors.Background
    Box.BorderSizePixel = 0
    
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = AP6.Colors.Primary
    Stroke.Thickness = 2

    local Header = Instance.new("Frame", Box)
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundColor3 = AP6.Colors.Secondary
    Header.BorderSizePixel = 0
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

    local T = Instance.new("TextLabel", Box)
    T.Size = UDim2.new(1, 0, 0, 35)
    T.Text = "  " .. title:upper()
    T.Font = Enum.Font.GothamBold
    T.TextSize = 15
    T.TextColor3 = AP6.Colors.Primary
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.BackgroundTransparency = 1

    local D = Instance.new("TextLabel", Box)
    D.Size = UDim2.new(1, -40, 0, 60)
    D.Position = UDim2.new(0, 20, 0, 55)
    D.Text = text
    D.Font = Enum.Font.Gotham
    D.TextSize = 14
    D.TextWrapped = true
    D.TextColor3 = AP6.Colors.Text
    D.BackgroundTransparency = 1

    
    local Yes = Instance.new("TextButton", Box)
    Yes.Size = UDim2.new(0.4, 0, 0, 38)
    Yes.Position = UDim2.new(0.08, 0, 1, -55)
    Yes.Text = "EXECUTE"
    Yes.Font = Enum.Font.GothamBold
    Yes.TextSize = 13
    Yes.BackgroundColor3 = AP6.Colors.Primary
    Yes.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Yes).CornerRadius = UDim.new(0, 4)

    
    local No = Instance.new("TextButton", Box)
    No.Size = UDim2.new(0.4, 0, 0, 38)
    No.Position = UDim2.new(0.52, 0, 1, -55)
    No.Text = "ABORT"
    No.Font = Enum.Font.GothamBold
    No.TextSize = 13
    No.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    No.TextColor3 = AP6.Colors.Grey
    Instance.new("UICorner", No).CornerRadius = UDim.new(0, 4)

    
    Box.UpdateSize = Box.Size
    Box.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(Overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(Box, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 340, 0, 190)}):Play()

    Yes.MouseButton1Click:Connect(function()
        if callback then callback() end
        Overlay:Destroy()
    end)

    No.MouseButton1Click:Connect(function()
        Overlay:Destroy()
    end)
end

return AP6
