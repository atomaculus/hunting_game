local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Shared.Constants)
local DogConfig = require(ReplicatedStorage.Shared.Config.Dogs)

local DogService = {}

local validCommands = {
    [Constants.DogCommands.Follow] = true,
    [Constants.DogCommands.Search] = true,
    [Constants.DogCommands.Retrieve] = true,
}

local function buildInitialProfile()
    local dogDefinition = DogConfig[Constants.DefaultDogBreedKey]

    return {
        dogName = Constants.DefaultDogName,
        dogBreed = dogDefinition.displayName,
        dogState = Constants.DogState.Healthy,
        lastCommand = "Idle",
        activePrey = nil,
        baggedPrey = 0,
        coins = Constants.DefaultCoins,
    }
end

local function buildStatusPayload(profile, message)
    return {
        dogName = profile.dogName,
        dogBreed = profile.dogBreed,
        dogState = profile.dogState,
        lastCommand = profile.lastCommand,
        activePreyName = profile.activePrey and profile.activePrey.displayName or nil,
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

    local function setupPlayer(player)
        local profile = ensureProfile(playerProfiles, player)
        sendStatus(dogStatusRemote, player, profile, "Perro equipado. Z seguir, X buscar, C cobrar.")
    end

    Players.PlayerAdded:Connect(setupPlayer)

    for _, player in Players:GetPlayers() do
        setupPlayer(player)
    end

    Players.PlayerRemoving:Connect(function(player)
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
            profile.activePrey = nil
            profile.dogState = Constants.DogState.Healthy
            message = string.format("%s vuelve a tu lado y espera la siguiente orden.", profile.dogName)
        elseif commandName == Constants.DogCommands.Search then
            profile.activePrey = huntService:getNextPrey()
            profile.dogState = Constants.DogState.Healthy
            message = string.format(
                "%s detecto una presa: %s. Usa C para cobrar.",
                profile.dogName,
                profile.activePrey.displayName
            )
        elseif commandName == Constants.DogCommands.Retrieve then
            if profile.activePrey then
                local prey = profile.activePrey
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
                message = string.format("%s no tiene una presa marcada para cobrar.", profile.dogName)
            end
        end

        sendStatus(dogStatusRemote, player, profile, message)
    end)
end

return DogService
