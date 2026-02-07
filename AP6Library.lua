local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AP6Lib = {}


AP6Lib.Key = "Ap6S"
AP6Lib.Colors = {
    Primary = Color3.fromRGB(0, 255, 128),
    Secondary = Color3.fromRGB(255, 64, 64),
    Background = Color3.fromRGB(25, 25, 25)
}


AP6Lib.Icons = {
    Ready = "🟢",
    NotInGame = "🔴",
    Developing = "🔘"
}


function AP6Lib:FadeIn(guiObject, duration)
    guiObject.BackgroundTransparency = 1
    guiObject.Visible = true
    TweenService:Create(guiObject, TweenInfo.new(duration or 1), {BackgroundTransparency = 0}):Play()
end


function AP6Lib:FadeOut(guiObject, duration)
    TweenService:Create(guiObject, TweenInfo.new(duration or 1), {BackgroundTransparency = 1}):Play()
    task.wait(duration or 1)
    guiObject.Visible = false
end


function AP6Lib:Confetti(parent)
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxassetid://241876357"
    particle.Lifetime = NumberRange.new(2,3)
    particle.Rate = 50
    particle.Speed = NumberRange.new(10,20)
    particle.Parent = parent
    task.delay(3, function() particle.Enabled = false end)
end


function AP6Lib:Notify(title, content, duration)
    local msg = Instance.new("Hint")
    msg.Text = "✨ " .. title .. " | " .. content .. " ✨"
    msg.Parent = workspace
    task.delay(duration or 3, function() msg:Destroy() end)
end


function AP6Lib:CheckKey(inputKey, successCallback, failCallback)
    if inputKey == self.Key then
        successCallback()
        self:Confetti(LocalPlayer:WaitForChild("PlayerGui"))
    else
        failCallback()
    end
end


function AP6Lib:MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end


function AP6Lib:BindToggle(guiObject)
    local visible = true
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
            visible = not visible
            if visible then
                self:FadeIn(guiObject, 0.5)
            else
                self:FadeOut(guiObject, 0.5)
            end
        end
    end)
end

return AP6Lib
