local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AP6Lib = {}


AP6Lib.Key = "Ap6S"
AP6Lib.Colors = {
    Primary = Color3.fromRGB(0, 255, 128),
    Secondary = Color3.fromRGB(255, 64, 64),
    Background = Color3.fromRGB(25, 25, 25)
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


function AP6Lib:CheckKey(inputKey, successCallback, failCallback)
    if inputKey == self.Key then
        successCallback()
        self:Confetti(LocalPlayer:WaitForChild("PlayerGui"))
    else
        failCallback()
    end
end

return AP6Lib
