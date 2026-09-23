-- ==========================================
-- MEU ADMIN - SERVER
-- Coloque em ServerScriptService
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("MeuAdminRemote")

if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "MeuAdminRemote"
	remote.Parent = ReplicatedStorage
end

local GOD = {}

local function getCharacter(player)
	return player and player.Character
end

local function getHumanoid(player)
	local char = getCharacter(player)
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
	local char = getCharacter(player)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function setGod(player, enabled)
	GOD[player] = enabled

	local humanoid = getHumanoid(player)
	if not humanoid then return end

	if enabled then
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge

		if not humanoid:FindFirstChild("MeuAdminGod") then
			local marker = Instance.new("BoolValue")
			marker.Name = "MeuAdminGod"
			marker.Value = true
			marker.Parent = humanoid
		end
	else
		humanoid.MaxHealth = 100
		humanoid.Health = math.min(humanoid.Health, 100)

		local marker = humanoid:FindFirstChild("MeuAdminGod")
		if marker then
			marker:Destroy()
		end
	end
end

local function findPlayer(name)
	if not name or name == "" then
		return nil
	end

	name = string.lower(name)

	for _, player in ipairs(Players:GetPlayers()) do
		if string.lower(player.Name) == name
			or string.lower(player.DisplayName) == name then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if string.sub(string.lower(player.Name), 1, #name) == name then
			return player
		end
	end

	return nil
end

local function explodeTarget(target)
	local root = getRoot(target)
	local humanoid = getHumanoid(target)

	if root then
		local explosion = Instance.new("Explosion")
		explosion.Position = root.Position
		explosion.BlastRadius = 8
		explosion.BlastPressure = 500000
		explosion.DestroyJointRadiusPercent = 1
		explosion.Parent = workspace
	end

	if humanoid then
		humanoid.Health = 0
	end
end

local function killTarget(target)
	local humanoid = getHumanoid(target)

	if humanoid then
		humanoid.Health = 0
	end
end

local function bringTarget(target, admin)
	local targetRoot = getRoot(target)
	local adminRoot = getRoot(admin)

	if targetRoot and adminRoot then
		targetRoot.CFrame =
			adminRoot.CFrame * CFrame.new(0, 0, -4)
	end
end

local function flingTarget(target)
	local root = getRoot(target)

	if root then
		root.AssemblyLinearVelocity =
			Vector3.new(
				math.random(-100,100),
				180,
				math.random(-100,100)
			)
	end
end

local function damageTarget(target, damage)
	local humanoid = getHumanoid(target)

	if not humanoid then
		return false
	end

	if GOD[target] then
		return false
	end

	humanoid:TakeDamage(damage)

	return true
end

-- DANO DO FARM
remote.OnServerEvent:Connect(function(player, action, targetName)

	if action == "GOD" then
		setGod(player, targetName == true)
		return
	end

	if action == "FARM_DAMAGE" then
		local target = findPlayer(targetName)

		if target and target ~= player then
			damageTarget(target, 25)
		end

		return
	end

	if action == "KILL" then
		local target = findPlayer(targetName)

		if target and target ~= player then
			killTarget(target)
		end

		return
	end

	if action == "EXPLODE" then
		local target = findPlayer(targetName)

		if target and target ~= player then
			explodeTarget(target)
		end

		return
	end

	if action == "BRING" then
		local target = findPlayer(targetName)

		if target and target ~= player then
			bringTarget(target, player)
		end

		return
	end

	if action == "FLING" then
		local target = findPlayer(targetName)

		if target and target ~= player then
			flingTarget(target)
		end

		return
	end

	if action == "RESET" then
		local humanoid = getHumanoid(player)

		if humanoid and not GOD[player] then
			humanoid.Health = 0
		end

		return
	end
end)

-- GOD CONTINUA DEPOIS DE MORRER/RESPAWNAR
Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(function(character)

		task.wait(0.5)

		if GOD[player] then
			setGod(player, true)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	GOD[player] = nil
end)
