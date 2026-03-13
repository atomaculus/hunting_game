local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Constants = require(ReplicatedStorage.Shared.Constants)
local DogConfig = require(ReplicatedStorage.Shared.Config.Dogs)

local DogService = {}

local validCommands = {
    [Constants.DogCommands.Follow] = true,
    [Constants.DogCommands.Search] = true,
    [Constants.DogCommands.Retrieve] = true,
}

local function getCharacterRootPart(player)
    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getWorldOffsetForCommand(commandName)
    if commandName == Constants.DogCommands.Search then
        return Constants.WorldDog.SearchOffset
    end

    if commandName == Constants.DogCommands.Retrieve then
        return Constants.WorldDog.RetrieveOffset
    end

    return Constants.WorldDog.FollowOffset
end

local function getTargetPosition(rootPart, offset)
    local targetPosition = rootPart.Position
        + rootPart.CFrame.RightVector * offset.X
        + rootPart.CFrame.LookVector * offset.Z

    return Vector3.new(targetPosition.X, rootPart.Position.Y - 2.2, targetPosition.Z)
end

local function getDogTargetPosition(player, profile)
    if profile.lastCommand == Constants.DogCommands.Search and profile.activePrey and profile.activePrey.instance then
        local preyInstance = profile.activePrey.instance
        if preyInstance.Parent then
            local orbitOffset = Constants.WorldPrey.DogSearchOrbitOffset
            local targetPosition = preyInstance.Position + Vector3.new(orbitOffset.X, 0, orbitOffset.Z)
            return Vector3.new(targetPosition.X, preyInstance.Position.Y - 0.5, targetPosition.Z), preyInstance.Position - targetPosition
        end
    end

    local rootPart = getCharacterRootPart(player)
    if not rootPart then
        return nil, nil
    end

    local offset = getWorldOffsetForCommand(profile.lastCommand)
    return getTargetPosition(rootPart, offset), rootPart.CFrame.LookVector
end

local function createDogModel(profile, player)
    local model = Instance.new("Model")
    model.Name = string.format("%sDog", player.Name)

    local body = Instance.new("Part")
    body.Name = "Body"
    body.Size = Vector3.new(2.6, 1.4, 3.4)
    body.Color = Color3.fromRGB(214, 180, 108)
    body.Material = Enum.Material.SmoothPlastic
    body.CanCollide = false
    body.Anchored = true
    body.TopSurface = Enum.SurfaceType.Smooth
    body.BottomSurface = Enum.SurfaceType.Smooth
    body.Parent = model

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1.4, 1.2, 1.2)
    head.Color = Color3.fromRGB(235, 207, 144)
    head.Material = Enum.Material.SmoothPlastic
    head.CanCollide = false
    head.Anchored = true
    head.TopSurface = Enum.SurfaceType.Smooth
    head.BottomSurface = Enum.SurfaceType.Smooth
    head.Parent = model

    local nose = Instance.new("Part")
    nose.Name = "Nose"
    nose.Size = Vector3.new(0.45, 0.35, 0.35)
    nose.Color = Color3.fromRGB(44, 36, 31)
    nose.Material = Enum.Material.SmoothPlastic
    nose.CanCollide = false
    nose.Anchored = true
    nose.TopSurface = Enum.SurfaceType.Smooth
    nose.BottomSurface = Enum.SurfaceType.Smooth
    nose.Parent = model

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "StatusBillboard"
    billboard.Size = UDim2.fromOffset(180, 52)
    billboard.StudsOffset = Constants.WorldDog.BillboardStudsOffset
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 80
    billboard.Parent = body

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 0.2
    label.BackgroundColor3 = Color3.fromRGB(16, 24, 32)
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(244, 236, 219)
    label.TextStrokeTransparency = 0.65
    label.TextWrapped = true
    label.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label

    model.PrimaryPart = body
    model:SetAttribute("DogOwnerUserId", player.UserId)
    model:SetAttribute("DogBreed", profile.dogBreed)

    return model
end

local function placeDogModel(model, targetPosition, facingDirection)
    local body = model.PrimaryPart
    local head = model:FindFirstChild("Head")
    local nose = model:FindFirstChild("Nose")
    if not body then
        return
    end

    local flatFacing = Vector3.new(facingDirection.X, 0, facingDirection.Z)
    if flatFacing.Magnitude < 0.001 then
        flatFacing = Vector3.new(0, 0, -1)
    else
        flatFacing = flatFacing.Unit
    end

    local targetCFrame = CFrame.lookAt(targetPosition, targetPosition + flatFacing)
    body.CFrame = targetCFrame

    if head then
        local headCFrame = targetCFrame:ToWorldSpace(CFrame.new(0, 0.2, -2.1))
        head.CFrame = headCFrame

        if nose then
            nose.CFrame = headCFrame:ToWorldSpace(CFrame.new(0, -0.1, -0.75))
        end
    end
end

local function updateBillboard(profile)
    local dogModel = profile.dogModel
    if not dogModel or not dogModel.PrimaryPart then
        return
    end

    local billboard = dogModel.PrimaryPart:FindFirstChild("StatusBillboard")
    local label = billboard and billboard:FindFirstChild("Label")
    if not label then
        return
    end

    local preyName = profile.activePrey and profile.activePrey.definition.displayName or "Sin presa"
    label.Text = string.format("%s\n%s | %s\n%s", profile.dogName, profile.dogState, profile.lastCommand, preyName)
end

local function buildInitialProfile()
    local dogDefinition = DogConfig[Constants.DefaultDogBreedKey]

    return {
        dogName = Constants.DefaultDogName,
        dogBreed = dogDefinition.displayName,
        dogState = Constants.DogState.Healthy,
        lastCommand = Constants.DogCommands.Follow,
        activePrey = nil,
        baggedPrey = 0,
        coins = Constants.DefaultCoins,
        dogModel = nil,
    }
end

local function buildStatusPayload(profile, message)
    return {
        dogName = profile.dogName,
        dogBreed = profile.dogBreed,
        dogState = profile.dogState,
        lastCommand = profile.lastCommand,
        activePreyName = profile.activePrey and profile.activePrey.definition.displayName or nil,
        baggedPrey = profile.baggedPrey,
        coins = profile.coins,
        message = message,
    }
end

local function ensureProfile(playerProfiles, player)
    local profile = playerProfiles[player]
    if not profile then
        profile = buildInitialProfile()
        playerProfiles[player] = profile
    end

    return profile
end

local function sendStatus(statusRemote, player, profile, message)
    statusRemote:FireClient(player, buildStatusPayload(profile, message))
end

function DogService.init(dependencies)
    local dogCommandRemote = dependencies.dogCommandRemote
    local dogStatusRemote = dependencies.dogStatusRemote
    local dogStatusRequestRemote = dependencies.dogStatusRequestRemote
    local huntService = dependencies.huntService
    local economyService = dependencies.economyService
    local playerProfiles = {}
    local dogFolder = Workspace:FindFirstChild(Constants.WorldDogFolderName)
    if not dogFolder then
        dogFolder = Instance.new("Folder")
        dogFolder.Name = Constants.WorldDogFolderName
        dogFolder.Parent = Workspace
    end

    local function destroyDogModel(profile)
        if profile.dogModel then
            profile.dogModel:Destroy()
            profile.dogModel = nil
        end
    end

    local function spawnDogForPlayer(player, profile)
        destroyDogModel(profile)

        local rootPart = getCharacterRootPart(player)
        if not rootPart then
            return
        end

        local dogModel = createDogModel(profile, player)
        dogModel.Parent = dogFolder
        profile.dogModel = dogModel

        local spawnPosition = getTargetPosition(rootPart, Constants.WorldDog.SpawnOffset)
        placeDogModel(dogModel, spawnPosition, rootPart.CFrame.LookVector)
        updateBillboard(profile)
    end

    local function setupPlayer(player)
        local profile = ensureProfile(playerProfiles, player)

        player.CharacterAdded:Connect(function(character)
            character:WaitForChild("HumanoidRootPart", 10)
            spawnDogForPlayer(player, profile)
        end)

        if player.Character then
            task.defer(function()
                local character = player.Character
                if character then
                    character:WaitForChild("HumanoidRootPart", 10)
                    spawnDogForPlayer(player, profile)
                end
            end)
        end

        sendStatus(dogStatusRemote, player, profile, "Perro equipado. Z seguir, X buscar, C cobrar.")
    end

    Players.PlayerAdded:Connect(setupPlayer)

    for _, player in Players:GetPlayers() do
        setupPlayer(player)
    end

    Players.PlayerRemoving:Connect(function(player)
        local profile = playerProfiles[player]
        if profile then
            destroyDogModel(profile)
        end
        huntService:clearActiveTarget(player)
        playerProfiles[player] = nil
    end)

    dogStatusRequestRemote.OnServerInvoke = function(player)
        local profile = ensureProfile(playerProfiles, player)
        return buildStatusPayload(profile, "Conectado. Z seguir, X buscar, C cobrar.")
    end

    dogCommandRemote.OnServerEvent:Connect(function(player, commandName)
        if not validCommands[commandName] then
            warn(string.format("Invalid dog command from %s: %s", player.Name, tostring(commandName)))
            return
        end

        local profile = ensureProfile(playerProfiles, player)
        profile.lastCommand = commandName

        local message

        if commandName == Constants.DogCommands.Follow then
            huntService:clearActiveTarget(player)
            profile.activePrey = nil
            profile.dogState = Constants.DogState.Healthy
            message = string.format("%s vuelve a tu lado y espera la siguiente orden.", profile.dogName)
        elseif commandName == Constants.DogCommands.Search then
            local activeTarget, errorMessage = huntService:createSearchTarget(player)
            if activeTarget then
                profile.activePrey = activeTarget
                profile.dogState = Constants.DogState.Healthy
                message = string.format(
                    "%s marco una presa en el mundo: %s. Acercate y usa C para cobrar.",
                    profile.dogName,
                    profile.activePrey.definition.displayName
                )
            else
                profile.activePrey = nil
                message = string.format("%s no pudo marcar una presa. %s", profile.dogName, errorMessage)
            end
        elseif commandName == Constants.DogCommands.Retrieve then
            local dogPosition = profile.dogModel and profile.dogModel.PrimaryPart and profile.dogModel.PrimaryPart.Position
            local prey, errorMessage = huntService:retrieveActiveTarget(player, dogPosition)
            if prey then
                profile.activePrey = nil
                profile.baggedPrey += 1
                local totalCoins = economyService:awardCoins(profile, prey.sellValue)
                message = string.format(
                    "%s cobro %s. Bolsa: %d presa(s). Monedas: %d.",
                    profile.dogName,
                    prey.displayName,
                    profile.baggedPrey,
                    totalCoins
                )
            else
                message = string.format("%s no pudo cobrar. %s", profile.dogName, errorMessage)
            end
        end

        updateBillboard(profile)
        sendStatus(dogStatusRemote, player, profile, message)
    end)

    RunService.Heartbeat:Connect(function(deltaTime)
        for player, profile in playerProfiles do
            local dogModel = profile.dogModel
            local body = dogModel and dogModel.PrimaryPart
            local targetPosition, facingDirection = getDogTargetPosition(player, profile)
            if body and targetPosition and facingDirection then

                local toTarget = targetPosition - body.Position
                if toTarget.Magnitude > Constants.WorldDog.TeleportDistance then
                    placeDogModel(dogModel, targetPosition, facingDirection)
                elseif toTarget.Magnitude > 0.05 then
                    local step = math.min(toTarget.Magnitude, Constants.WorldDog.FollowSpeed * deltaTime)
                    local nextPosition = body.Position + toTarget.Unit * step
                    local moveFacingDirection = toTarget.Magnitude > 0.4 and toTarget.Unit or facingDirection
                    placeDogModel(dogModel, nextPosition, moveFacingDirection)
                else
                    placeDogModel(dogModel, body.Position, facingDirection)
                end
            end
        end
    end)
end

return DogService
