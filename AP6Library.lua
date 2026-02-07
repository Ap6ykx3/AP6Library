-- AP6 NEURONET v3.0 - ULTIMATE HACKER OS LIBRARY
-- Sube esto exactamente a: https://raw.githubusercontent.com/Ap6ykx3/AP6Library/main/AP6Library.lua
-- Esto es lo más cercano a un "juego" hacker que puedes tener en Roblox sin lag.

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    PlayerGui = PlayerGui,
    SupportedGames = {},
    NeonGreen = Color3.fromRGB(0, 255, 120),
    Cyan = Color3.fromRGB(0, 255, 255),
    DarkBg = Color3.fromRGB(5, 5, 8),
    Sounds = {
        Type = "rbxassetid://131057808",
        Scan = "rbxassetid://6518811702",
        Boot = "rbxassetid://138090596",
        Inject = "rbxassetid://6895079853"
    }
}

-- ====================== MATRIX RAIN (OPTIMIZADO, SIN LAG) ======================
function AP6:MatrixRain()
    local gui = Instance.new("ScreenGui")
    gui.Name = "NEURONET_RAIN"
    gui.IgnoreGuiInset = true
    gui.Parent = AP6.PlayerGui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.95
    frame.BackgroundColor3 = Color3.new(0,0,0)

    local columns = {}
    local charSize = 16
    local cols = math.floor(workspace.CurrentCamera.ViewportSize.X / charSize) + 5

    for i = 1, cols do
        table.insert(columns, {
            x = i * charSize,
            y = math.random(-500, 0),
            speed = math.random(6, 14),
            chars = {}
        })
    end

    local katakana = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not frame.Parent then conn:Disconnect() return end
        for _, col in ipairs(columns) do
            col.y += col.speed
            if col.y > frame.AbsoluteSize.Y + 200 then
                col.y = math.random(-600, -100)
                col.speed = math.random(6, 14)
            end

            -- Nuevo carácter
            if #col.chars == 0 or col.chars[#col.chars].AbsolutePosition.Y > charSize then
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0, charSize, 0, charSize)
                lbl.Position = UDim2.new(0, col.x, 0, col.y)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = AP6.NeonGreen
                lbl.Text = katakana:sub(math.random(1, #katakana), math.random(1, #katakana))
                lbl.Font = Enum.Font.Code
                lbl.TextSize = charSize - 2
                lbl.TextTransparency = 0.3
                lbl.Parent = frame
                table.insert(col.chars, lbl)
            end

            -- Fade trail
            for i, lbl in ipairs(col.chars) do
                lbl.Position = UDim2.new(0, col.x, 0, col.y - (i-1)*charSize)
                lbl.TextTransparency = 0.1 + (i-1)*0.07
            end

            if #col.chars > 35 then
                col.chars[1]:Destroy()
                table.remove(col.chars, 1)
            end
        end
    end)
end

-- ====================== BOOT SEQUENCE CON MÓDULOS ======================
function AP6:BootSequence(callback)
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "NEURONET_BOOT"
    gui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = AP6.DarkBg

    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0, 600, 0, 120)
    logo.Position = UDim2.new(0.5, -300, 0.25, 0)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6 NEURONET"
    logo.TextColor3 = AP6.Cyan
    logo.Font = Enum.Font.Code
    logo.TextSize = 62
    logo.TextStrokeTransparency = 0.6

    local subtitle = Instance.new("TextLabel", bg)
    subtitle.Size = UDim2.new(0, 600, 0, 40)
    subtitle.Position = UDim2.new(0.5, -300, 0.38, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "TERMINATOR v3.0 - SHADOW PROTOCOL"
    subtitle.TextColor3 = AP6.NeonGreen
    subtitle.Font = Enum.Font.Code
    subtitle.TextSize = 24

    local console = Instance.new("TextLabel", bg)
    console.Size = UDim2.new(0.7, 0, 0.4, 0)
    console.Position = UDim2.new(0.15, 0, 0.55, 0)
    console.BackgroundTransparency = 1
    console.TextColor3 = AP6.NeonGreen
    console.Font = Enum.Font.Code
    console.TextSize = 19
    console.TextXAlignment = Enum.TextXAlignment.Left
    console.TextYAlignment = Enum.TextYAlignment.Top

    AP6:PlaySound(AP6.Sounds.Boot)

    local modules = {
        "[CORE] Initializing ShadowNet connection...",
        "[NET] Establishing encrypted tunnel to 0xDEADBEEF...",
        "[PAYLOAD] Loading exploit database...",
        "[VISUAL] Activating overlay engine...",
        "[ANTI] Bypassing Byfron detection layer...",
        "[READY] NEURONET ONLINE - All modules loaded."
    }

    local text = ""
    for _, line in ipairs(modules) do
        AP6:TypeText(console, text .. line .. "\n", 0.02)
        text = text .. line .. "\n"
        task.wait(0.55)
    end

    task.wait(1.8)
    TweenService:Create(bg, TweenInfo.new(0.9), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    gui:Destroy()
    callback()
end

function AP6:TypeText(label, fullText, speed)
    label.Text = ""
    local i = 1
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if i > #fullText then conn:Disconnect() return end
        label.Text = fullText:sub(1, i)
        i += 1
        if math.random(1,4) == 1 then AP6:PlaySound(AP6.Sounds.Type) end
    end)
end

-- ====================== MAIN INTERFACE ======================
function AP6:CreateInterface()
    local gui = Instance.new("ScreenGui", AP6.PlayerGui)
    gui.Name = "NEURONET"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 980, 0, 620)
    main.Position = UDim2.new(0.5, -490, 0.5, -310)
    main.BackgroundColor3 = AP6.DarkBg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = AP6.Cyan
    stroke.Thickness = 3

    -- Header
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1,0,0,50)
    header.BackgroundColor3 = Color3.fromRGB(10,10,15)
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0.6,0,1,0)
    title.Position = UDim2.new(0,30,0,0)
    title.BackgroundTransparency = 1
    title.Text = "AP6 NEURONET  •  TERMINATOR v3.0"
    title.TextColor3 = AP6.Cyan
    title.Font = Enum.Font.Code
    title.TextSize = 26
    title.TextXAlignment = Enum.TextXAlignment.Left

    local status = Instance.new("TextLabel", header)
    status.Size = UDim2.new(0.3,0,1,0)
    status.Position = UDim2.new(0.7,0,0,0)
    status.BackgroundTransparency = 1
    status.Text = "CONNECTED • KEY: VALID • BYFRON: BYPASSED"
    status.TextColor3 = AP6.NeonGreen
    status.Font = Enum.Font.Code
    status.TextSize = 18

    -- Sidebar Modules
    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 220, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(8,8,12)

    local modTitle = Instance.new("TextLabel", sidebar)
    modTitle.Size = UDim2.new(1,0,0,40)
    modTitle.BackgroundTransparency = 1
    modTitle.Text = "LOADED MODULES"
    modTitle.TextColor3 = AP6.NeonGreen
    modTitle.Font = Enum.Font.Code
    modTitle.TextSize = 20

    local mods = {"ShadowNet", "Payload DB", "ESP Engine", "Aimbot Core", "Anti-Detection"}
    for i, m in ipairs(mods) do
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1,-20,0,45)
        btn.Position = UDim2.new(0,10,0,50 + (i-1)*55)
        btn.BackgroundColor3 = Color3.fromRGB(15,15,20)
        btn.Text = "▶ " .. m
        btn.TextColor3 = AP6.NeonGreen
        btn.Font = Enum.Font.Code
        btn.TextSize = 18
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    end

    -- Targets
    local targetsFrame = Instance.new("ScrollingFrame", main)
    targetsFrame.Size = UDim2.new(0.65,0,1,-120)
    targetsFrame.Position = UDim2.new(0.24,0,0,60)
    targetsFrame.BackgroundTransparency = 1
    targetsFrame.ScrollBarThickness = 6
    targetsFrame.ScrollBarImageColor3 = AP6.Cyan

    local layout = Instance.new("UIListLayout", targetsFrame)
    layout.Padding = UDim.new(0,16)

    for placeId, info in pairs(AP6.SupportedGames) do
        local card = Instance.new("Frame", targetsFrame)
        card.Size = UDim2.new(1,0,0,90)
        card.BackgroundColor3 = Color3.fromRGB(12,12,18)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

        local icon = Instance.new("TextLabel", card)
        icon.Size = UDim2.new(0,60,1,0)
        icon.Text = "▶"
        icon.TextColor3 = AP6.Cyan
        icon.Font = Enum.Font.Code
        icon.TextSize = 50
        icon.BackgroundTransparency = 1

        local name = Instance.new("TextLabel", card)
        name.Size = UDim2.new(1,-90,0,50)
        name.Position = UDim2.new(0,70,0,10)
        name.BackgroundTransparency = 1
        name.Text = info.name
        name.TextColor3 = AP6.NeonGreen
        name.Font = Enum.Font.Code
        name.TextSize = 24
        name.TextXAlignment = Enum.TextXAlignment.Left

        local breachBtn = Instance.new("TextButton", card)
        breachBtn.Size = UDim2.new(0,140,0,40)
        breachBtn.Position = UDim2.new(1,-160,0.5,-20)
        breachBtn.BackgroundColor3 = AP6.Cyan
        breachBtn.Text = "BREACH TARGET"
        breachBtn.TextColor3 = Color3.new(0,0,0)
        breachBtn.Font = Enum.Font.GothamBold
        breachBtn.TextSize = 16
        Instance.new("UICorner", breachBtn).CornerRadius = UDim.new(0,8)

        breachBtn.MouseButton1Click:Connect(function()
            AP6:PlaySound(AP6.Sounds.Inject)
            AP6:BreachSequence(info)
        end)
    end

    targetsFrame.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 40)

    -- Console log
    local consoleFrame = Instance.new("Frame", main)
    consoleFrame.Size = UDim2.new(0.65,0,0,150)
    consoleFrame.Position = UDim2.new(0.24,0,1,-170)
    consoleFrame.BackgroundColor3 = Color3.fromRGB(8,8,12)
    Instance.new("UICorner", consoleFrame).CornerRadius = UDim.new(0,12)

    local consoleLog = Instance.new("TextLabel", consoleFrame)
    consoleLog.Size = UDim2.new(1,-20,1,-20)
    consoleLog.Position = UDim2.new(0,10,0,10)
    consoleLog.BackgroundTransparency = 1
    consoleLog.Text = "[NEURONET] Ready for injection.\nType 'help' in chat for commands."
    consoleLog.TextColor3 = AP6.NeonGreen
    consoleLog.Font = Enum.Font.Code
    consoleLog.TextSize = 17
    consoleLog.TextXAlignment = Enum.TextXAlignment.Left
    consoleLog.TextYAlignment = Enum.TextYAlignment.Top

    AP6:MakeDraggable(main)
    return gui
end

function AP6:BreachSequence(info)
    local breachGui = Instance.new("ScreenGui", AP6.PlayerGui)
    breachGui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", breachGui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    bg.BackgroundTransparency = 0.4

    local panel = Instance.new("Frame", breachGui)
    panel.Size = UDim2.new(0, 620, 0, 380)
    panel.Position = UDim2.new(0.5, -310, 0.5, -190)
    panel.BackgroundColor3 = AP6.DarkBg
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0,16)

    local log = Instance.new("TextLabel", panel)
    log.Size = UDim2.new(1,-40,1,-80)
    log.Position = UDim2.new(0,20,0,20)
    log.BackgroundTransparency = 1
    log.TextColor3 = AP6.NeonGreen
    log.Font = Enum.Font.Code
    log.TextSize = 18
    log.TextXAlignment = Enum.TextXAlignment.Left

    local lines = {
        "[BREACH] Connecting to target " .. info.name .. "...",
        "[FIREWALL] Bypassing Roblox anti-cheat...",
        "[PAYLOAD] Uploading AP6 core...",
        "[EXPLOIT] Injecting universal script...",
        "[SUCCESS] Target compromised."
    }

    local full = ""
    for _, l in ipairs(lines) do
        AP6:TypeText(log, full .. l .. "\n", 0.03)
        full = full .. l .. "\n"
        task.wait(0.6)
    end

    task.wait(2)
    breachGui:Destroy()
    loadstring(game:HttpGet(info.url))()
end

function AP6:MakeDraggable(frame)
    -- (código draggable estándar, igual que antes)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function AP6:PlaySound(id)
    local s = Instance.new("Sound", workspace)
    s.SoundId = id
    s.Volume = 0.5
    s:Play()
    game.Debris:AddItem(s, 3)
end

-- ====================== INIT ======================
function AP6:Init(games)
    AP6.SupportedGames = games
    AP6:MatrixRain()
    AP6:BootSequence(function()
        AP6:CreateInterface()
    end)
end

return AP6
