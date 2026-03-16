local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local DogController = {}

local initialized = false
local COMMAND_COOLDOWN = 0.35

local commandMeta = {
    Follow = {
        label = "Seguir",
        key = "Z",
        accent = Color3.fromRGB(92, 168, 255),
    },
    Search = {
        label = "Buscar",
        key = "X",
        accent = Color3.fromRGB(255, 187, 92),
    },
    Retrieve = {
        label = "Cobrar",
        key = "C",
        accent = Color3.fromRGB(110, 214, 140),
    },
}

local uiState = {
    statusText = nil,
    messageText = nil,
    commandText = nil,
    pulse = nil,
}

local inputState = {
    bindings = {},
    lastSentAt = 0,
    lastCommand = "Idle",
}

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function createStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
end

local function createStatusGui()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("DogStatusGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DogStatusGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end

    local root = screenGui:FindFirstChild("Root")
    if root then
        return {
            root = root,
            statusText = root.Content.StatusText,
            messageText = root.Content.MessageText,
            commandText = root.Footer.CommandText,
            pulse = root.Accent,
        }
    end

    root = Instance.new("Frame")
    root.Name = "Root"
    root.AnchorPoint = Vector2.new(0.5, 0)
    root.Position = UDim2.new(0.5, 0, 0, 18)
    root.Size = UDim2.new(0, 620, 0, 152)
    root.BackgroundColor3 = Color3.fromRGB(17, 24, 30)
    root.BackgroundTransparency = 0.1
    root.BorderSizePixel = 0
    root.Parent = screenGui
    createCorner(root, 18)
    createStroke(root, Color3.fromRGB(124, 155, 178), 0.45, 1.2)

    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(1, 0, 0, 6)
    accent.BackgroundColor3 = Color3.fromRGB(110, 214, 140)
    accent.BorderSizePixel = 0
    accent.Parent = root
    createCorner(accent, 18)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 18, 0, 16)
    content.Size = UDim2.new(1, -36, 1, -56)
    content.Parent = root

    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, 0, 0, 26)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "COMPANERO DE CAZA"
    titleText.TextColor3 = Color3.fromRGB(247, 232, 205)
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = content

    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.BackgroundTransparency = 1
    statusText.Position = UDim2.new(0, 0, 0, 30)
    statusText.Size = UDim2.new(1, 0, 0, 46)
    statusText.Font = Enum.Font.GothamSemibold
    statusText.Text = "Inicializando perro..."
    statusText.TextColor3 = Color3.fromRGB(240, 244, 247)
    statusText.TextSize = 18
    statusText.TextWrapped = true
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    statusText.Parent = content

    local messageText = Instance.new("TextLabel")
    messageText.Name = "MessageText"
    messageText.BackgroundTransparency = 1
    messageText.Position = UDim2.new(0, 0, 0, 78)
    messageText.Size = UDim2.new(1, 0, 0, 20)
    messageText.Font = Enum.Font.Gotham
    messageText.Text = ""
    messageText.TextColor3 = Color3.fromRGB(188, 204, 216)
    messageText.TextSize = 15
    messageText.TextWrapped = true
    messageText.TextXAlignment = Enum.TextXAlignment.Left
    messageText.Parent = content

    local footer = Instance.new("Frame")
    footer.Name = "Footer"
    footer.BackgroundTransparency = 1
    footer.Position = UDim2.new(0, 18, 1, -38)
    footer.Size = UDim2.new(1, -36, 0, 24)
    footer.Parent = root

    local commandText = Instance.new("TextLabel")
    commandText.Name = "CommandText"
    commandText.BackgroundTransparency = 1
    commandText.Size = UDim2.new(1, 0, 1, 0)
    commandText.Font = Enum.Font.GothamMedium
    commandText.Text = "[Z] Seguir   [X] Buscar   [C] Cobrar"
    commandText.TextColor3 = Color3.fromRGB(247, 232, 205)
    commandText.TextSize = 14
    commandText.TextXAlignment = Enum.TextXAlignment.Left
    commandText.Parent = footer

    return {
        root = root,
        statusText = statusText,
        messageText = messageText,
        commandText = commandText,
        pulse = accent,
    }
end

local function buildStatusText(payload)
    local preyText = payload.activePreyName or "Sin presa marcada"
    local preyStateText = payload.activePreyState or "-"
    if payload.activePreyProgress and payload.activePreyState == "Detected" then
        preyStateText = string.format("%s %d%%", preyStateText, math.floor(payload.activePreyProgress * 100 + 0.5))
    end

    return string.format(
        "%s (%s)  |  Estado: %s  |  Orden: %s\nPresa: %s (%s)  |  Bolsa: %d  |  Monedas: %d",
        payload.dogName,
        payload.dogBreed,
        payload.dogState,
        payload.lastCommand,
        preyText,
        preyStateText,
        payload.baggedPrey,
        payload.coins
    )
end

local function setCommandHint(text)
    uiState.commandText.Text = text
end

local function pulseAccent(color)
    uiState.pulse.BackgroundColor3 = color
    local tween = TweenService:Create(
        uiState.pulse,
        TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = Color3.fromRGB(110, 214, 140)}
    )
    tween:Play()
end

local function updateStatus(payload)
    uiState.statusText.Text = buildStatusText(payload)
    uiState.messageText.Text = payload.message or ""
    inputState.lastCommand = payload.lastCommand or inputState.lastCommand
end

local function canSendCommand()
    return os.clock() - inputState.lastSentAt >= COMMAND_COOLDOWN
end

local function sendCommand(dogCommandRemote, commandName)
    local meta = commandMeta[commandName]
    if not canSendCommand() then
        setCommandHint("Esperando un instante antes del siguiente comando...")
        return
    end

    inputState.lastSentAt = os.clock()
    inputState.lastCommand = commandName

    if meta then
        uiState.messageText.Text = string.format("Orden enviada: %s", meta.label)
        setCommandHint(string.format("[%s] %s enviada", meta.key, meta.label))
        pulseAccent(meta.accent)
    end

    dogCommandRemote:FireServer(commandName)
end

local function bindCommand(keyCode, commandName)
    inputState.bindings[keyCode] = commandName
end

function DogController.init(replicatedStorage)
    if initialized then
        return
    end

    initialized = true

    local constants = require(replicatedStorage.Shared.Constants)
    local remotes = replicatedStorage:WaitForChild(constants.RemoteFolderName)
    local dogCommandRemote = remotes:WaitForChild(constants.DogCommandRemoteName)
    local dogStatusRemote = remotes:WaitForChild(constants.DogStatusRemoteName)
    local dogStatusRequestRemote = remotes:WaitForChild(constants.DogStatusRequestRemoteName)

    uiState = createStatusGui()
    uiState.statusText.Text = "Inicializando perro..."
    uiState.messageText.Text = "Conectando con el companero de caza..."
    setCommandHint("[Z] Seguir   [X] Buscar   [C] Cobrar")

    dogStatusRemote.OnClientEvent:Connect(function(payload)
        updateStatus(payload)
        setCommandHint("[Z] Seguir   [X] Buscar   [C] Cobrar")
    end)

    local initialPayload = dogStatusRequestRemote:InvokeServer()
    updateStatus(initialPayload)

    bindCommand(constants.InputBindings.Follow, constants.DogCommands.Follow)
    bindCommand(constants.InputBindings.Search, constants.DogCommands.Search)
    bindCommand(constants.InputBindings.Retrieve, constants.DogCommands.Retrieve)

    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end

        local commandName = inputState.bindings[input.KeyCode]
        if not commandName then
            return
        end

        sendCommand(dogCommandRemote, commandName)
    end)
end

return DogController
