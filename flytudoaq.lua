--// ✨ PAINEL FLY + VELOCIDADE + PULO INFINITO
--// Coloque como LocalScript em:
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local speedValue = 16
local flySpeed = 50
local flyEnabled = false
local infiniteJump = false
local minimized = false

local character
local humanoid
local root

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")
end

setupCharacter(player.Character or player.CharacterAdded:Wait())

player.CharacterAdded:Connect(function(char)
	setupCharacter(char)
end)

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "HSEditControls"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

--==================================================
-- TELA DE CARREGAMENTO
--==================================================

local loading = Instance.new("Frame")
loading.Size = UDim2.fromScale(1,1)
loading.BackgroundColor3 = Color3.fromRGB(8,8,12)
loading.Parent = gui

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1,0,0,60)
loadingTitle.Position = UDim2.new(0,0,0.38,0)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "HSEDIT CONTROLS"
loadingTitle.TextColor3 = Color3.new(1,1,1)
loadingTitle.TextScaled = true
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loading

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1,0,0,35)
loadingText.Position = UDim2.new(0,0,0.48,0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Carregando..."
loadingText.TextColor3 = Color3.fromRGB(180,180,180)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = loading

local barBack = Instance.new("Frame")
barBack.Size = UDim2.new(0.35,0,0,8)
barBack.Position = UDim2.new(0.325,0,0.56,0)
barBack.BackgroundColor3 = Color3.fromRGB(35,35,45)
barBack.BorderSizePixel = 0
barBack.Parent = loading

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1,0)
barCorner.Parent = barBack

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(80,140,255)
bar.BorderSizePixel = 0
bar.Parent = barBack

local barCorner2 = Instance.new("UICorner")
barCorner2.CornerRadius = UDim.new(1,0)
barCorner2.Parent = bar

TweenService:Create(
	bar,
	TweenInfo.new(1.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	{Size = UDim2.fromScale(1,1)}
):Play()

task.wait(2)

TweenService:Create(
	loading,
	TweenInfo.new(0.5, Enum.EasingStyle.Quart),
	{BackgroundTransparency = 1}
):Play()

for _,v in ipairs(loading:GetDescendants()) do
	if v:IsA("TextLabel") or v:IsA("Frame") then
		TweenService:Create(
			v,
			TweenInfo.new(0.4),
			{BackgroundTransparency = 1}
		):Play()

		if v:IsA("TextLabel") then
			TweenService:Create(
				v,
				TweenInfo.new(0.4),
				{TextTransparency = 1}
			):Play()
		end
	end
end

task.wait(0.5)
loading:Destroy()

--==================================================
-- PAINEL
--==================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,390,0,430)
main.Position = UDim2.new(0.5,-195,0.5,-215)
main.BackgroundColor3 = Color3.fromRGB(18,18,25)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65,65,85)
stroke.Thickness = 1.5
stroke.Parent = main

--==================================================
-- TITULO
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,0,55)
title.Position = UDim2.new(0,18,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ HSEdit Controls"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

--==================================================
-- MINIMIZAR
--==================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,35,0,35)
minimize.Position = UDim2.new(1,-80,0,10)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,52)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = main

Instance.new("UICorner",minimize).CornerRadius = UDim.new(0,9)

--==================================================
-- FECHAR
--==================================================

local close = Instance.new("TextButton")
close.Size = UDim2.new(0,35,0,35)
close.Position = UDim2.new(1,-40,0,10)
close.BackgroundColor3 = Color3.fromRGB(180,55,65)
close.Text = "×"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 24
close.Font = Enum.Font.GothamBold
close.Parent = main

Instance.new("UICorner",close).CornerRadius = UDim.new(0,9)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--==================================================
-- BOTÃO FLY
--==================================================

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(1,-40,0,48)
flyButton.Position = UDim2.new(0,20,0,70)
flyButton.BackgroundColor3 = Color3.fromRGB(40,40,52)
flyButton.Text = "🪽  FLY: OFF"
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.TextSize = 17
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = main

Instance.new("UICorner",flyButton).CornerRadius = UDim.new(0,10)

--==================================================
-- VELOCIDADE
--==================================================

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,-40,0,30)
speedLabel.Position = UDim2.new(0,20,0,135)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Velocidade: 16"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = main

local speedBack = Instance.new("Frame")
speedBack.Size = UDim2.new(1,-40,0,10)
speedBack.Position = UDim2.new(0,20,0,170)
speedBack.BackgroundColor3 = Color3.fromRGB(45,45,58)
speedBack.BorderSizePixel = 0
speedBack.Parent = main

Instance.new("UICorner",speedBack).CornerRadius = UDim.new(1,0)

local speedFill = Instance.new("Frame")
speedFill.Size = UDim2.new(speedValue/100,0,1,0)
speedFill.BackgroundColor3 = Color3.fromRGB(75,130,255)
speedFill.BorderSizePixel = 0
speedFill.Parent = speedBack

Instance.new("UICorner",speedFill).CornerRadius = UDim.new(1,0)

--==================================================
-- SLIDER VELOCIDADE
--==================================================

local draggingSpeed = false

local function updateSpeed(input)
	local x = math.clamp(
		input.Position.X - speedBack.AbsolutePosition.X,
		0,
		speedBack.AbsoluteSize.X
	)

	speedValue = math.floor((x / speedBack.AbsoluteSize.X) * 100)

	speedValue = math.clamp(speedValue,1,100)

	speedFill.Size = UDim2.new(speedValue/100,0,1,0)
	speedLabel.Text = "⚡ Velocidade: "..speedValue

	if humanoid then
		humanoid.WalkSpeed = speedValue
	end
end

speedBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		draggingSpeed = true
		updateSpeed(input)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSpeed and
		(input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then

		updateSpeed(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		draggingSpeed = false
	end
end)

--==================================================
-- PULO INFINITO
--==================================================

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(1,-40,0,48)
jumpButton.Position = UDim2.new(0,20,0,205)
jumpButton.BackgroundColor3 = Color3.fromRGB(40,40,52)
jumpButton.Text = "🦘  PULO INFINITO: OFF"
jumpButton.TextColor3 = Color3.new(1,1,1)
jumpButton.TextSize = 16
jumpButton.Font = Enum.Font.GothamBold
jumpButton.Parent = main

Instance.new("UICorner",jumpButton).CornerRadius = UDim.new(0,10)

jumpButton.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump

	if infiniteJump then
		jumpButton.Text = "🦘  PULO INFINITO: ON"
		jumpButton.BackgroundColor3 = Color3.fromRGB(45,120,75)
	else
		jumpButton.Text = "🦘  PULO INFINITO: OFF"
		jumpButton.BackgroundColor3 = Color3.fromRGB(40,40,52)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if infiniteJump and humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--==================================================
-- FLY
--==================================================

local bodyVelocity
local flyConnection

local function stopFly()
	flyEnabled = false

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if humanoid then
		humanoid.PlatformStand = false
	end

	flyButton.Text = "🪽  FLY: OFF"
	flyButton.BackgroundColor3 = Color3.fromRGB(40,40,52)
end

local function startFly()
	if not root or not humanoid then return end

	flyEnabled = true

	flyButton.Text = "🪽  FLY: ON"
	flyButton.BackgroundColor3 = Color3.fromRGB(45,120,75)

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = root

	flyConnection = RunService.RenderStepped:Connect(function()
		if not flyEnabled or not root then return end

		local camera = workspace.CurrentCamera
		local direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			direction += camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			direction -= camera.CFrame.LookVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			direction -= camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			direction += camera.CFrame.RightVector
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.new(0,1,0)
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			direction -= Vector3.new(0,1,0)
		end

		if direction.Magnitude > 0 then
			bodyVelocity.Velocity = direction.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.zero
		end
	end)
end

flyButton.MouseButton1Click:Connect(function()
	if flyEnabled then
		stopFly()
	else
		startFly()
	end
end)

--==================================================
-- MINIMIZAR
--==================================================

local originalSize = UDim2.new(0,390,0,430)
local minimizedSize = UDim2.new(0,390,0,60)

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		TweenService:Create(
			main,
			TweenInfo.new(0.25,Enum.EasingStyle.Quart),
			{Size = minimizedSize}
		):Play()

		minimize.Text = "+"
	else
		TweenService:Create(
			main,
			TweenInfo.new(0.25,Enum.EasingStyle.Quart),
			{Size = originalSize}
		):Play()

		minimize.Text = "—"
	end

	for _,obj in ipairs(main:GetChildren()) do
		if obj ~= title
		and obj ~= minimize
		and obj ~= close
		and not obj:IsA("UICorner")
		and not obj:IsA("UIStroke") then

			if obj:IsA("GuiObject") then
				obj.Visible = not minimized
			end
		end
	end

	title.Visible = true
	minimize.Visible = true
	close.Visible = true
end)

--==================================================
-- ARRASTAR PAINEL
--==================================================

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
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

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

--==================================================
-- RESPAWN
--==================================================

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)

	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")

	humanoid.WalkSpeed = speedValue

	if flyEnabled then
		stopFly()
	end
end)
