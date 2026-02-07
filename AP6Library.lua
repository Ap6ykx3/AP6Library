local AP6 = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer

AP6.Colors = {
	Background = Color3.fromRGB(18,18,24),
	Primary = Color3.fromRGB(80,90,130),
	Secondary = Color3.fromRGB(140,140,160),
	Accent = Color3.fromRGB(180,140,255),
	Text = Color3.fromRGB(235,235,245)
}

AP6.Icons = {
	Ready = "🟢",
	NotInGame = "🔵",
	Developing = "🟣"
}

local function tween(o,p,t)
	TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play()
end

function AP6:Blur(state)
	if state then
		if not Lighting:FindFirstChild("AP6Blur") then
			local b = Instance.new("BlurEffect")
			b.Name = "AP6Blur"
			b.Size = 0
			b.Parent = Lighting
			tween(b,{Size=18},1)
		end
	else
		local b = Lighting:FindFirstChild("AP6Blur")
		if b then
			tween(b,{Size=0},0.5)
			task.delay(0.6,function() b:Destroy() end)
		end
	end
end

function AP6:PlaySound(id,vol)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://"..id
	s.Volume = vol or 1
	s.Parent = SoundService
	s:Play()
	game.Debris:AddItem(s,5)
end

function AP6:Loading()
	local gui = Instance.new("ScreenGui")
	gui.IgnoreGuiInset = true
	gui.Parent = Player.PlayerGui

	local bg = Instance.new("Frame",gui)
	bg.Size = UDim2.fromScale(1,1)
	bg.BackgroundColor3 = AP6.Colors.Background
	bg.BackgroundTransparency = 1

	local title = Instance.new("TextLabel",bg)
	title.Size = UDim2.new(1,0,0,200)
	title.Position = UDim2.fromScale(0,0.4)
	title.Text = "AP6 HUB"
	title.TextColor3 = AP6.Colors.Text
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.BackgroundTransparency = 1
	title.TextTransparency = 1

	self:Blur(true)
	self:PlaySound(9118823101,0.4)

	tween(bg,{BackgroundTransparency=0},1)
	tween(title,{TextTransparency=0},1.2)

	task.wait(2.8)

	tween(bg,{BackgroundTransparency=1},1)
	tween(title,{TextTransparency=1},1)

	task.wait(1.1)
	self:Blur(false)
	gui:Destroy()
end

function AP6:Notify(t,d,ti)
	local gui = Instance.new("ScreenGui",Player.PlayerGui)

	local f = Instance.new("Frame",gui)
	f.Size = UDim2.new(0,0,0,60)
	f.Position = UDim2.new(1,-20,1,-80)
	f.AnchorPoint = Vector2.new(1,1)
	f.BackgroundColor3 = AP6.Colors.Primary
	f.ClipsDescendants = true
	Instance.new("UICorner",f).CornerRadius = UDim.new(0,12)

	local txt = Instance.new("TextLabel",f)
	txt.Size = UDim2.new(1,-20,1,0)
	txt.Position = UDim2.new(0,10,0,0)
	txt.TextWrapped = true
	txt.TextXAlignment = Left
	txt.Text = t.."\n"..d
	txt.TextColor3 = AP6.Colors.Text
	txt.Font = Enum.Font.Gotham
	txt.TextSize = 14
	txt.BackgroundTransparency = 1

	tween(f,{Size=UDim2.new(0,320,0,60)},0.5)
	self:PlaySound(9118826041,0.3)

	task.wait(ti or 3)
	tween(f,{Size=UDim2.new(0,0,0,60)},0.4)
	task.wait(0.5)
	gui:Destroy()
end

function AP6:FadeIn(o,t)
	o.BackgroundTransparency = 1
	tween(o,{BackgroundTransparency=0},t)
end

function AP6:MakeDraggable(f)
	local d=false;local s;local p
	f.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then
			d=true;s=i.Position;p=f.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if d and i.UserInputType==Enum.UserInputType.MouseMovement then
			local delta=i.Position-s
			f.Position=UDim2.new(p.X.Scale,p.X.Offset+delta.X,p.Y.Scale,p.Y.Offset+delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then d=false end
	end)
end

function AP6:BindToggle(f,key)
	key = key or Enum.KeyCode.RightControl
	UserInputService.InputBegan:Connect(function(i,g)
		if not g and i.KeyCode==key then
			f.Visible = not f.Visible
		end
	end)
end

function AP6:CheckKey(k,ok,bad)
	self:Loading()
	local gui = Instance.new("ScreenGui",Player.PlayerGui)

	local f = Instance.new("Frame",gui)
	f.Size = UDim2.new(0,360,0,180)
	f.Position = UDim2.fromScale(0.5,0.5)
	f.AnchorPoint = Vector2.new(0.5,0.5)
	f.BackgroundColor3 = AP6.Colors.Background
	Instance.new("UICorner",f).CornerRadius = UDim.new(0,16)

	local box = Instance.new("TextBox",f)
	box.Size = UDim2.new(1,-40,0,40)
	box.Position = UDim2.new(0,20,0,70)
	box.PlaceholderText = "Enter Key"
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextColor3 = AP6.Colors.Text
	box.BackgroundColor3 = AP6.Colors.Primary
	Instance.new("UICorner",box).CornerRadius = UDim.new(0,8)

	local b = Instance.new("TextButton",f)
	b.Size = UDim2.new(0.5,-25,0,36)
	b.Position = UDim2.new(0.25,0,1,-50)
	b.Text = "Unlock"
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = AP6.Colors.Accent
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)

	b.MouseButton1Click:Connect(function()
		if box.Text == k then
			gui:Destroy()
			ok()
		else
			self:PlaySound(138186576,0.5)
			if bad then bad() end
		end
	end)
end

return AP6
