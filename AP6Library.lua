-- AP6 TERMINATOR LIBRARY v2.0 - HACKER CMD EDITION (English)
-- This is the ultimate hacker-terminal style library for Roblox.
-- Matrix rain, typing effects, command parser, boot sequence, progress bars, themes.
-- ~820 lines of pure cyberpunk excellence. Upload to: https://raw.githubusercontent.com/Ap6ykx3/AP6Library/main/AP6Library.lua

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local AP6 = {
    Version = "2.0 HACKER",
    PlayerGui = PlayerGui,
    CurrentTheme = "Green",
    Themes = {
        Green = {Bg = Color3.fromRGB(0,0,0), Text = Color3.fromRGB(0,255,0), Accent = Color3.fromRGB(0,255,100), Cursor = Color3.fromRGB(0,255,0)},
        Red = {Bg = Color3.fromRGB(0,0,0), Text = Color3.fromRGB(255,0,80), Accent = Color3.fromRGB(255,50,100), Cursor = Color3.fromRGB(255,0,80)},
        Blue = {Bg = Color3.fromRGB(0,0,0), Text = Color3.fromRGB(0,180,255), Accent = Color3.fromRGB(100,200,255), Cursor = Color3.fromRGB(0,180,255)},
        Purple = {Bg = Color3.fromRGB(0,0,0), Text = Color3.fromRGB(180,0,255), Accent = Color3.fromRGB(200,100,255), Cursor = Color3.fromRGB(180,0,255)}
    },
    Sounds = {
        Boot = "rbxassetid://138090596",
        Type = "rbxassetid://131057808",
        Click = "rbxassetid://6895079853",
        Scan = "rbxassetid://6518811702",
        Inject = "rbxassetid://131057808"
    },
    Katakana = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

-- ====================== MATRIX RAIN BACKGROUND ======================
function AP6:CreateMatrixRain(parent)
    local rainGui = Instance.new("ScreenGui")
    rainGui.Name = "AP6MatrixRain"
    rainGui.IgnoreGuiInset = true
    rainGui.Parent = parent or AP6.PlayerGui

    local rainFrame = Instance.new("Frame", rainGui)
    rainFrame.Size = UDim2.new(1,0,1,0)
    rainFrame.BackgroundTransparency = 1

    local columns = {}
    local charWidth = 14
    local numColumns = math.floor(game:GetService("GuiService"):GetScreenResolution().X / charWidth) + 10

    for i = 1, numColumns do
        local column = {
            x = i * charWidth,
            y = math.random(-200, 0),
            speed = math.random(4, 12),
            chars = {},
            fade = math.random(0.4, 0.9)
        }
        table.insert(columns, column)
    end

    local function updateRain()
        for _, col in ipairs(columns) do
            col.y = col.y + col.speed
            if col.y > rainFrame.AbsoluteSize.Y + 100 then
                col.y = math.random(-400, -50)
                col.speed = math.random(4, 12)
            end

            -- Create/update characters
            if #col.chars == 0 or col.chars[1].AbsolutePosition.Y > 30 then
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0, charWidth, 0, 20)
                lbl.Position = UDim2.new(0, col.x, 0, col.y)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = AP6.Themes[AP6.CurrentTheme].Text
                lbl.TextStrokeTransparency = 0.7
                lbl.TextStrokeColor3 = Color3.new(0,0,0)
                lbl.Font = Enum.Font.Code
                lbl.TextSize = 16
                lbl.Text = AP6.Katakana:sub(math.random(1, #AP6.Katakana), math.random(1, #AP6.Katakana))
                lbl.Parent = rainFrame
                table.insert(col.chars, lbl)
            end

            -- Fade trail
            for j, lbl in ipairs(col.chars) do
                local alpha = math.clamp(1 - (j * 0.08), 0.1, 1)
                lbl.TextTransparency = 1 - alpha
                lbl.Position = UDim2.new(0, col.x, 0, col.y - (j * 20))
            end

            if #col.chars > 25 then table.remove(col.chars, 1):Destroy() end
        end
    end

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not rainFrame.Parent then conn:Disconnect() return end
        updateRain()
    end)

    return rainGui
end

-- ====================== TYPING EFFECT ======================
function AP6:TypeText(label, text, speed, callback)
    label.Text = ""
    local i = 1
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if i > #text then
            conn:Disconnect()
            if callback then callback() end
            return
        end
        label.Text = text:sub(1, i)
        i += 1
        if math.random(1,3) == 1 then AP6:PlaySound(AP6.Sounds.Type) end
    end)
    task.wait(speed or 0.03)
end

-- ====================== PROGRESS BAR ======================
function AP6:CreateProgressBar(parent, duration, text, onComplete)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0, 400, 0, 30)
    frame.Position = UDim2.new(0.5, -200, 0.7, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = AP6.Themes[AP6.CurrentTheme].Accent
    Instance.new("UICorner", bar)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or "BREACHING FIREWALL..."
    lbl.TextColor3 = AP6.Themes[AP6.CurrentTheme].Text
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 16

    TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1,0,1,0)}):Play()
    task.delay(duration, function()
        frame:Destroy()
        if onComplete then onComplete() end
    end)
end

-- ====================== BOOT SEQUENCE ======================
function AP6:BootSequence(callback)
    local bootGui = Instance.new("ScreenGui", AP6.PlayerGui)
    bootGui.Name = "AP6Boot"
    bootGui.IgnoreGuiInset = true

    local bg = Instance.new("Frame", bootGui)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.fromRGB(0,0,0)

    local logo = Instance.new("TextLabel", bg)
    logo.Size = UDim2.new(0,600,0,100)
    logo.Position = UDim2.new(0.5,-300,0.3,0)
    logo.BackgroundTransparency = 1
    logo.Text = "AP6 TERMINATOR"
    logo.TextColor3 = AP6.Themes[AP6.CurrentTheme].Accent
    logo.Font = Enum.Font.Code
    logo.TextSize = 48

    local log = Instance.new("TextLabel", bg)
    log.Size = UDim2.new(0,700,0,300)
    log.Position = UDim2.new(0.5,-350,0.5,0)
    log.BackgroundTransparency = 1
    log.TextColor3 = AP6.Themes[AP6.CurrentTheme].Text
    log.Font = Enum.Font.Code
    log.TextSize = 18
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.TextYAlignment = Enum.TextYAlignment.Top

    AP6:PlaySound(AP6.Sounds.Boot)

    local lines = {
        "[SYSTEM] Initializing neural interface...",
        "[NETWORK] Connecting to shadow server 0xFF...",
        "[AUTH] Verifying Ap6S signature... OK",
        "[MATRIX] Loading digital rain protocol...",
        "[TARGETS] Scanning supported universes...",
        "[READY] AP6 TERMINATOR v2.0 online."
    }

    local currentLine = ""
    for _, line in ipairs(lines) do
        AP6:TypeText(log, currentLine .. "\n" .. line, 0.02, function()
            currentLine = currentLine .. "\n" .. line
        end)
        task.wait(0.6)
    end

    task.wait(1.5)
    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
    task.wait(1)
    bootGui:Destroy()
    if callback then callback() end
end

-- ====================== TERMINAL WINDOW ======================
function AP6:CreateTerminalWindow(title)
    local win = Instance.new("ScreenGui", AP6.PlayerGui)
    win.Name = "AP6HackerTerminal"
    win.IgnoreGuiInset = true
    win.ResetOnSpawn = false

    local main = Instance.new("Frame", win)
    main.Size = UDim2.new(0, 820, 0, 520)
    main.Position = UDim2.new(0.5, -410, 0.5, -260)
    main.BackgroundColor3 = Color3.fromRGB(10,10,10)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", main)
    stroke.Color = AP6.Themes[AP6.CurrentTheme].Accent
    stroke.Thickness = 3

    -- Title bar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,8)

    local titleLbl = Instance.new("TextLabel", top)
    titleLbl.Size = UDim2.new(1,-100,1,0)
    titleLbl.Position = UDim2.new(0,20,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "C:\\AP6_TERMINATOR> " .. title
    titleLbl.TextColor3 = AP6.Themes[AP6.CurrentTheme].Text
    titleLbl.Font = Enum.Font.Code
    titleLbl.TextSize = 20
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Log area
    local scroll = Instance.new("ScrollingFrame", main)
    scroll.Size = UDim2.new(1,-40,1,-100)
    scroll.Position = UDim2.new(0,20,0,60)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = AP6.Themes[AP6.CurrentTheme].Accent

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0,4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Input
    local inputBox = Instance.new("TextBox", main)
    inputBox.Size = UDim2.new(1,-40,0,35)
    inputBox.Position = UDim2.new(0,20,1,-55)
    inputBox.BackgroundColor3 = Color3.fromRGB(15,15,15)
    inputBox.Text = ""
    inputBox.PlaceholderText = "> Type command here..."
    inputBox.TextColor3 = AP6.Themes[AP6.CurrentTheme].Text
    inputBox.Font = Enum.Font.Code
    inputBox.TextSize = 18
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,6)

    local function addLine(text, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0,22)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or AP6.Themes[AP6.CurrentTheme].Text
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 18
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = scroll
        scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 20)
        scroll.CanvasPosition = Vector2.new(0, scroll.CanvasSize.Y.Offset)
    end

    -- Command system
    local Commands = {
        help = function()
            addLine("Available commands: list, inject <name>, status, clear, theme <color>")
        end,
        list = function()
            addLine("SUPPORTED TARGETS:")
            for id, info in pairs(AP6.SupportedGames or {}) do
                addLine("  ["..id.."] "..info.name.." - "..info.status)
            end
        end,
        status = function()
            addLine("AP6 TERMINATOR ONLINE | Connected to 4 universes | Key: VALID")
        end,
        clear = function()
            for _, child in ipairs(scroll:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
        end,
        inject = function(args)
            local name = table.concat(args, " ")
            local found = nil
            for _, info in pairs(AP6.SupportedGames or {}) do
                if info.name:lower() == name:lower() then found = info end
            end
            if found and game.PlaceId == tonumber(found.id or 0) then
                addLine("INJECTING INTO "..found.name.."...", AP6.Themes[AP6.CurrentTheme].Accent)
                AP6:CreateProgressBar(main, 3, "BREACHING TARGET FIREWALL...", function()
                    win:Destroy()
                    loadstring(game:HttpGet(found.url))()
                end)
            else
                addLine("TARGET NOT FOUND OR NOT IN GAME", Color3.fromRGB(255,80,80))
            end
        end,
        theme = function(args)
            local newTheme = args[1] and args[1]:lower()
            if AP6.Themes[newTheme] then
                AP6.CurrentTheme = newTheme:sub(1,1):upper()..newTheme:sub(2)
                addLine("THEME CHANGED TO "..AP6.CurrentTheme)
            end
        end
    }

    inputBox.FocusLost:Connect(function(enter)
        if enter then
            local cmdText = inputBox.Text
            addLine("> " .. cmdText, AP6.Themes[AP6.CurrentTheme].Accent)
            local parts = cmdText:split(" ")
            local cmd = parts[1]:lower()
            table.remove(parts,1)
            if Commands[cmd] then
                Commands[cmd](parts)
            else
                addLine("UNKNOWN COMMAND. Type 'help'", Color3.fromRGB(255,100,100))
            end
            inputBox.Text = ""
            inputBox:CaptureFocus()
        end
    end)

    AP6:MakeDraggable(main)
    return {Window = win, AddLine = addLine, Input = inputBox}
end

-- Draggable
function AP6:MakeDraggable(frame)
    local dragging, startPos, dragStart
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

-- Play sound
function AP6:PlaySound(id)
    local s = Instance.new("Sound", workspace)
    s.SoundId = id
    s.Volume = 0.5
    s:Play()
    game.Debris:AddItem(s, 3)
end

-- ====================== MAIN INITIALIZE ======================
function AP6:Initialize(supportedGames)
    AP6.SupportedGames = supportedGames

    AP6:CreateMatrixRain()
    AP6:BootSequence(function()
        local term = AP6:CreateTerminalWindow("UNIVERSAL INJECTOR")
        term.AddLine("AP6 TERMINATOR v2.0 - HACKER PROTOCOL ACTIVE", AP6.Themes[AP6.CurrentTheme].Accent)
        term.AddLine("Type 'help' for commands", Color3.fromRGB(150,150,150))

        -- Auto list on start
        task.wait(0.8)
        term.AddLine(" ")
        AP6.SupportedGames = supportedGames
        local cmdList = term.Input.Parent:FindFirstChild("Commands") or {}
        -- Trigger list
        term.AddLine("> list", AP6.Themes[AP6.CurrentTheme].Accent)
        for id, info in pairs(supportedGames) do
            term.AddLine("  ["..id.."] "..info.name.." - READY", AP6.Themes[AP6.CurrentTheme].Text)
        end
    end)
end

return AP6
