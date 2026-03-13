local EconomyService = {}

function EconomyService.init()
    local service = {}

    function service:awardCoins(profile, amount)
        profile.coins += amount

        return profile.coins
    end

    return service
end

return EconomyService
