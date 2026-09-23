--// =========================================
--//      MEU ADMIN - GITHUB VERSION
--//      Para teste no seu próprio jogo
--// =========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- remover versão anterior
pcall(function()
    playerGui:FindFirstChild("MeuAdminGitHub"):Destroy()
end)

--// =========================================
--// GUI
--// =========================================

local gui = Instance.new("ScreenGui")
gui.Name = "MeuAdminGitHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--// LOADING
local loading = Instance.new("Frame")
loading.Size = UDim2.fromScale(1,1)
loading.BackgroundColor3 = Color3.fromRGB(5,5,8)
loading.Parent = gui

local loadingTitle = Instance.new("TextLabel")
loadingTitle.AnchorPoint = Vector2.new(.5,.5)
loadingTitle.Position = UDim2.fromScale(.5,.43)
loadingTitle.Size = UDim2.new(0,500,0,70)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "🔥 MEU ADMIN"
loadingTitle.TextColor3 = Color3.new(1,1,1)
loadingTitle.TextScaled = true
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loading

local loadingText = Instance.new("TextLabel")
loadingText.AnchorPoint = Vector2.new(.5,.5)
loadingText.Position = UDim2.fromScale(.5,.51)
loadingText.Size = UDim2.new(0,400,0,35)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Carregando..."
loadingText.TextColor3 = Color3.fromRGB(180,180,180)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = loading

local barBack = Instance.new("Frame")
barBack.AnchorPoint = Vector2.new(.5,.5)
barBack.Position = UDim2.fromScale(.5,.59)
barBack.Size = UDim2.new(0,500,0,14)
barBack.BackgroundColor3 = Color3.fromRGB(35,35,40)
barBack.BorderSizePixel = 0
barBack.Parent = loading

Instance.new("UICorner",barBack).CornerRadius = UDim.new(1,0)

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,255,170)
bar.BorderSizePixel = 0
bar.Parent = barBack

Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

for i = 1,100 do
    bar.Size = UDim2.new(i/100,0,1,0)
    loadingText.Text = "Carregando... "..i.."%"
    task.wait(.015)
end

task.wait(.25)

TweenService:Create(
    loading,
    TweenInfo.new(.5),
    {BackgroundTransparency = 1}
):Play()

for _,v in ipairs(loading:GetDescendants()) do
    if v:IsA("TextLabel") then
        TweenService:Create(
            v,
            TweenInfo.new(.4),
            {TextTransparency = 1}
        ):Play()
    end
end

task.wait(.5)
loading:Destroy()

--// =========================================
--// MAIN
--// =========================================

local main = Instance.new("Frame")
main.Size = UDim2.new(0,520,0,600)
main.Position = UDim2.new(.5,-260,.5,-300)
main.BackgroundColor3 = Color3.fromRGB(18,18,23)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Parent = main

-- RGB
task.spawn(function()
    local hue = 0

    while main.Parent do
        hue = (hue + .004) % 1
        stroke.Color = Color3.fromHSV(hue,1,1)
        task.wait()
    end
end)

--// HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(25,25,32)
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Position = UDim2.new(0,18,0,0)
title.Size = UDim2.new(1,-130,1,0)
title.BackgroundTransparency = 1
title.Text = "🔥 MEU ADMIN"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- fechar
local close = Instance.new("TextButton")
close.Position = UDim2.new(1,-50,0,10)
close.Size = UDim2.new(0,38,0,35)
close.Text = "X"
close.TextSize = 20
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(180,40,40)
close.Parent = header

Instance.new("UICorner",close).CornerRadius = UDim.new(0,8)

-- minimizar
local mini = Instance.new("TextButton")
mini.Position = UDim2.new(1,-95,0,10)
mini.Size = UDim2.new(0,38,0,35)
mini.Text = "-"
mini.TextSize = 25
mini.TextColor3 = Color3.new(1,1,1)
mini.BackgroundColor3 = Color3.fromRGB(50,50,60)
mini.Parent = header

Instance.new("UICorner",mini).CornerRadius = UDim.new(0,8)

--// DRAG
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and
    (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// =========================================
--// CONTENT
--// =========================================

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.new(0,10,0,65)
scroll.Size = UDim2.new(1,-20,1,-75)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scroll

local function updateCanvas()
    scroll.CanvasSize = UDim2.new(
        0,0,0,
        layout.AbsoluteContentSize.Y + 15
    )
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

--// =========================================
--// BOTÃO
--// =========================================

local function Button(text)
    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1,-20,0,45)
    b.BackgroundColor3 = Color3.fromRGB(35,35,45)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = true
    b.Parent = scroll

    Instance.new("UICorner",b).CornerRadius = UDim.new(0,9)

    return b
end

local function Section(text)
    local s = Instance.new("TextLabel")

    s.Size = UDim2.new(1,-20,0,35)
    s.BackgroundTransparency = 1
    s.Text = text
    s.TextColor3 = Color3.fromRGB(0,255,170)
    s.TextSize = 20
    s.Font = Enum.Font.GothamBold
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = scroll

    return s
end

--// =========================================
--// STATUS
--// =========================================

local god = false
local farm = false
local fly = false
local invisible = false

local function SetStatus(button,name,state)
    button.Text = name .. ": " .. (state and "ON 🟢" or "OFF 🔴")
end

--// =========================================
--// GOD MODE
--// =========================================

Section("🛡️ PROTEÇÃO")

local godButton = Button("🛡️ GOD MODE: OFF 🔴")

godButton.MouseButton1Click:Connect(function()
    god = not god
    SetStatus(godButton,"🛡️ GOD MODE",god)

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum and god then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

-- proteção local
RunService.Heartbeat:Connect(function()
    if god then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if hum then
            if hum.Health > 0 then
                hum.Health = hum.MaxHealth
            end
        end
    end
end)

-- reaplica ao renascer
player.CharacterAdded:Connect(function(char)
    task.wait(1)

    if god then
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end
end)

--// =========================================
--// FARM
--// =========================================

Section("🤖 FARM")

local farmButton = Button("🤖 AUTO FARM: OFF 🔴")

farmButton.MouseButton1Click:Connect(function()
    farm = not farm
    SetStatus(farmButton,"🤖 AUTO FARM",farm)
end)

-- Loop base para o seu jogo.
-- Aqui você pode ligar a lógica específica dos NPCs/objetivos.
task.spawn(function()
    while task.wait(.2) do
        if farm then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                -- Procura NPCs próximos no Workspace
                for _,obj in ipairs(workspace:GetDescendants()) do

                    if obj:IsA("Model")
                    and obj ~= char
                    and obj:FindFirstChildOfClass("Humanoid")
                    and obj:FindFirstChild("HumanoidRootPart") then

                        local hum = obj:FindFirstChildOfClass("Humanoid")
                        local enemyRoot = obj:FindFirstChild("HumanoidRootPart")

                        if hum.Health > 0 then
                            -- aproxima do NPC
                            root.CFrame =
                                enemyRoot.CFrame * CFrame.new(0,0,5)

                            break
                        end
                    end
                end
            end
        end
    end
end)

--// =========================================
--// MOVIMENTO
--// =========================================

Section("⚡ MOVIMENTO")

local speedButton = Button("⚡ SPEED")

speedButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.WalkSpeed = 100
    end
end)

local jumpButton = Button("🦘 SUPER JUMP")

jumpButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = 150
    end
end)

local flyButton = Button("🪽 FLY: OFF 🔴")

flyButton.MouseButton1Click:Connect(function()
    fly = not fly
    SetStatus(flyButton,"🪽 FLY",fly)

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not root then return end

    if fly then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "MeuFly"
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = root

        task.spawn(function()
            while fly and bv.Parent do
                local cam = workspace.CurrentCamera
                local move = Vector3.zero

                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    move += cam.CFrame.LookVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    move -= cam.CFrame.LookVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    move -= cam.CFrame.RightVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    move += cam.CFrame.RightVector
                end

                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    move += Vector3.new(0,1,0)
                end

                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    move -= Vector3.new(0,1,0)
                end

                bv.Velocity = move * 80

                task.wait()
            end

            if bv then
                bv:Destroy()
            end
        end)
    else
        local old = root:FindFirstChild("MeuFly")

        if old then
            old:Destroy()
        end
    end
end)

--// =========================================
--// OUTROS
--// =========================================

Section("✨ EFEITOS")

local invisibleButton = Button("👻 INVISÍVEL: OFF 🔴")

invisibleButton.MouseButton1Click:Connect(function()
    invisible = not invisible
    SetStatus(invisibleButton,"👻 INVISÍVEL",invisible)

    local char = player.Character
    if not char then return end

    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.LocalTransparencyModifier = invisible and 1 or 0
        elseif v:IsA("Decal") then
            v.Transparency = invisible and 1 or 0
        end
    end
end)

local healButton = Button("❤️ HEAL")

healButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.Health = hum.MaxHealth
    end
end)

local resetButton = Button("🔄 RESET")

resetButton.MouseButton1Click:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        hum.Health = 0
    end
end)

--// =========================================
--// MINIMIZAR
--// =========================================

local floating = Instance.new("TextButton")
floating.Size = UDim2.new(0,65,0,65)
floating.Position = UDim2.new(0,20,.5,-32)
floating.BackgroundColor3 = Color3.fromRGB(20,20,25)
floating.Text = "🔥"
floating.TextSize = 32
floating.Visible = false
floating.Parent = gui

Instance.new("UICorner",floating).CornerRadius = UDim.new(1,0)

local floatingStroke = Instance.new("UIStroke")
floatingStroke.Thickness = 3
floatingStroke.Parent = floating

task.spawn(function()
    local hue = 0

    while floating.Parent do
        hue = (hue + .005) % 1
        floatingStroke.Color = Color3.fromHSV(hue,1,1)
        task.wait()
    end
end)

mini.MouseButton1Click:Connect(function()
    main.Visible = false
    floating.Visible = true
end)

floating.MouseButton1Click:Connect(function()
    main.Visible = true
    floating.Visible = false
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--// botão flutuante arrastável
local floatDragging = false
local floatStart
local floatPos

floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        floatDragging = true
        floatStart = input.Position
        floatPos = floating.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                floatDragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if floatDragging and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - floatStart

        floating.Position = UDim2.new(
            floatPos.X.Scale,
            floatPos.X.Offset + delta.X,
            floatPos.Y.Scale,
            floatPos.Y.Offset + delta.Y
        )
    end
end)

--// tecla P
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.P then
        main.Visible = not main.Visible
        floating.Visible = not main.Visible
    end
end)

print("🔥 MEU ADMIN GITHUB CARREGADO!")
