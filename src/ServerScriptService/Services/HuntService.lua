local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Constants = require(ReplicatedStorage.Shared.Constants)
local PreyConfig = require(ReplicatedStorage.Shared.Config.Prey)

local HuntService = {}

local orderedPreyKeys = { "Pigeon", "Duck", "Hare", "Deer", "Boar" }

local preyVisualsByType = {
    Bird = {
        color = Color3.fromRGB(163, 181, 198),
        size = Vector3.new(1.8, 1.2, 2.2),
    },
    SmallGame = {
        color = Color3.fromRGB(181, 124, 88),
        size = Vector3.new(2.2, 1.6, 2.8),
    },
    BigGame = {
        color = Color3.fromRGB(124, 83, 58),
        size = Vector3.new(3.4, 2.4, 4.4),
    },
}

local function getCharacterRootPart(player)
    local character = player.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getGroundPosition(position)
    local rayOrigin = position + Vector3.new(0, 24, 0)
    local rayDirection = Vector3.new(0, -120, 0)
    local result = Workspace:Raycast(rayOrigin, rayDirection)
    if result then
        return result.Position
    end

    return position
end

local function createPreyInstance(preyDefinition, ownerUserId, spawnPosition)
    local visual = preyVisualsByType[preyDefinition.preyType] or preyVisualsByType.SmallGame

    local part = Instance.new("Part")
    part.Name = string.format("%sTarget", preyDefinition.id)
    part.Shape = Enum.PartType.Block
    part.Size = visual.size
    part.Color = visual.color
    part.Material = Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = false
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.CFrame = CFrame.new(spawnPosition + Vector3.new(0, visual.size.Y * 0.5, 0))
    part:SetAttribute("OwnerUserId", ownerUserId)
    part:SetAttribute("PreyId", preyDefinition.id)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PreyBillboard"
    billboard.Size = UDim2.fromOffset(160, 44)
    billboard.StudsOffset = Constants.WorldPrey.BillboardStudsOffset
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 80
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 0.2
    label.BackgroundColor3 = Color3.fromRGB(27, 35, 26)
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.fromRGB(244, 236, 219)
    label.TextSize = 14
    label.TextWrapped = true
    label.Text = string.format("%s\nObjetivo detectado", preyDefinition.displayName)
    label.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label

    return part
end

function HuntService.init()
    local service = {
        nextPreyIndex = 1,
        activeTargets = {},
    }
    local preyFolder = Workspace:FindFirstChild(Constants.WorldPreyFolderName)
    if not preyFolder then
        preyFolder = Instance.new("Folder")
        preyFolder.Name = Constants.WorldPreyFolderName
        preyFolder.Parent = Workspace
    end

    function service:getNextPrey()
        local preyKey = orderedPreyKeys[self.nextPreyIndex]
        local prey = PreyConfig[preyKey]

        self.nextPreyIndex += 1
        if self.nextPreyIndex > #orderedPreyKeys then
            self.nextPreyIndex = 1
        end

        return prey
    end

    function service:clearActiveTarget(player)
        local activeTarget = self.activeTargets[player]
        if not activeTarget then
            return
        end

        if activeTarget.instance then
            activeTarget.instance:Destroy()
        end

        self.activeTargets[player] = nil
    end

    function service:createSearchTarget(player)
        self:clearActiveTarget(player)

        local rootPart = getCharacterRootPart(player)
        if not rootPart then
            return nil, "No se encontro al jugador en el mundo."
        end

        local preyDefinition = self:getNextPrey()
        local distance = math.random(Constants.WorldPrey.SearchDistanceMin, Constants.WorldPrey.SearchDistanceMax)
        local lateral = math.random(-Constants.WorldPrey.SearchLateralSpread, Constants.WorldPrey.SearchLateralSpread)
        local rawPosition = rootPart.Position
            + rootPart.CFrame.LookVector * distance
            + rootPart.CFrame.RightVector * lateral
        local groundPosition = getGroundPosition(rawPosition)
        local preyInstance = createPreyInstance(preyDefinition, player.UserId, groundPosition)
        preyInstance.Parent = preyFolder

        local activeTarget = {
            definition = preyDefinition,
            instance = preyInstance,
            position = preyInstance.Position,
        }

        self.activeTargets[player] = activeTarget

        return activeTarget
    end

    function service:retrieveActiveTarget(player, dogPosition)
        local activeTarget = self.activeTargets[player]
        if not activeTarget then
            return nil, "No hay una presa activa en el mundo."
        end

        local instance = activeTarget.instance
        if not instance or not instance.Parent then
            self.activeTargets[player] = nil
            return nil, "La presa activa ya no existe en el mundo."
        end

        if dogPosition and (instance.Position - dogPosition).Magnitude > Constants.WorldPrey.RetrieveDistance then
            return nil, string.format(
                "La presa esta demasiado lejos del perro. Acercate y proba de nuevo."
            )
        end

        local preyDefinition = activeTarget.definition
        self:clearActiveTarget(player)

        return preyDefinition
    end

    return service
end

return HuntService
