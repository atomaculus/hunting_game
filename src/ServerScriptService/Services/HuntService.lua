local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PreyConfig = require(ReplicatedStorage.Shared.Config.Prey)

local HuntService = {}

local orderedPreyKeys = { "Pigeon", "Duck", "Hare", "Deer", "Boar" }

function HuntService.init()
    local service = {
        nextPreyIndex = 1,
    }

    print("HuntService initialized")

    function service:getNextPrey()
        local preyKey = orderedPreyKeys[self.nextPreyIndex]
        local prey = PreyConfig[preyKey]

        self.nextPreyIndex += 1
        if self.nextPreyIndex > #orderedPreyKeys then
            self.nextPreyIndex = 1
        end

        return prey
    end

    return service
end

return HuntService
