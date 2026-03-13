local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local DogController = {}

local ACTIONS = {
    Follow = "DogFollowAction",
    Search = "DogSearchAction",
    Retrieve = "DogRetrieveAction",
}

local function createStatusGui()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("DogStatusGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DogStatusGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    local statusLabel = screenGui:FindFirstChild("StatusLabel")
    if not statusLabel then
        statusLabel = Instance.new("TextLabel")
        statusLabel.Name = "StatusLabel"
        statusLabel.AnchorPoint = Vector2.new(0.5, 0)
        statusLabel.Position = UDim2.new(0.5, 0, 0, 20)
        statusLabel.Size = UDim2.new(0, 560, 0, 96)
        statusLabel.BackgroundColor3 = Color3.fromRGB(24, 33, 42)
        statusLabel.BackgroundTransparency = 0.2
        statusLabel.BorderSizePixel = 0
        statusLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
        statusLabel.TextStrokeTransparency = 0.7
        statusLabel.Font = Enum.Font.GothamSemibold
        statusLabel.TextSize = 18
        statusLabel.TextWrapped = true
        statusLabel.Parent = screenGui
    end

    return statusLabel
end

local function buildStatusText(payload)
    local preyText = payload.activePreyName or "Sin presa marcada"

    return string.format(
        "Perro: %s (%s)\nEstado: %s | Ultima orden: %s | Presa: %s | Bolsa: %d | Monedas: %d\n%s",
        payload.dogName,
        payload.dogBreed,
        payload.dogState,
        payload.lastCommand,
        preyText,
        payload.baggedPrey,
        payload.coins,
        payload.message
    )
end

local boundKeys = {}

local function sendCommand(dogCommandRemote, commandName)
    print(string.format("DogController sending command: %s", commandName))
    dogCommandRemote:FireServer(commandName)
end

local function bindCommand(actionName, keyCode, dogCommandRemote, commandName)
    boundKeys[keyCode] = commandName
end

function DogController.init(replicatedStorage)
    print("DogController init start")
    local constants = require(replicatedStorage.Shared.Constants)
    local remotes = replicatedStorage:WaitForChild(constants.RemoteFolderName)
    local dogCommandRemote = remotes:WaitForChild(constants.DogCommandRemoteName)
    local dogStatusRemote = remotes:WaitForChild(constants.DogStatusRemoteName)
    local dogStatusRequestRemote = remotes:WaitForChild(constants.DogStatusRequestRemoteName)
    local statusLabel = createStatusGui()

    statusLabel.Text = "Inicializando perro..."
    print("DogController remotes ready")

    dogStatusRemote.OnClientEvent:Connect(function(payload)
        print("DogController status update received", payload.lastCommand, payload.message)
        statusLabel.Text = buildStatusText(payload)
    end)

    local initialPayload = dogStatusRequestRemote:InvokeServer()
    statusLabel.Text = buildStatusText(initialPayload)
    print("DogController initial payload received")

    bindCommand(ACTIONS.Follow, constants.InputBindings.Follow, dogCommandRemote, constants.DogCommands.Follow)
    bindCommand(ACTIONS.Search, constants.InputBindings.Search, dogCommandRemote, constants.DogCommands.Search)
    bindCommand(ACTIONS.Retrieve, constants.InputBindings.Retrieve, dogCommandRemote, constants.DogCommands.Retrieve)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end

        local commandName = boundKeys[input.KeyCode]
        if not commandName then
            return
        end

        sendCommand(dogCommandRemote, commandName)
    end)

    statusLabel.Text = statusLabel.Text .. "\nControles listos: Z seguir, X buscar, C cobrar."
    print("DogController init complete")
end

return DogController
