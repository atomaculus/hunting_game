local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DogController = require(ReplicatedStorage.Client.DogController)

local ok, err = xpcall(function()
    DogController.init(ReplicatedStorage)
end, debug.traceback)

if not ok then
    warn("ClientBootstrap failed:\n" .. tostring(err))
end
