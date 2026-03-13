local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Shared.Constants)
local DogService = require(ServerScriptService.Services.DogService)
local HuntService = require(ServerScriptService.Services.HuntService)
local EconomyService = require(ServerScriptService.Services.EconomyService)

local remotes = ReplicatedStorage:FindFirstChild(Constants.RemoteFolderName)
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = Constants.RemoteFolderName
    remotes.Parent = ReplicatedStorage
end

local dogCommandRemote = remotes:FindFirstChild(Constants.DogCommandRemoteName)
if not dogCommandRemote then
    dogCommandRemote = Instance.new("RemoteEvent")
    dogCommandRemote.Name = Constants.DogCommandRemoteName
    dogCommandRemote.Parent = remotes
end

local dogStatusRemote = remotes:FindFirstChild(Constants.DogStatusRemoteName)
if not dogStatusRemote then
    dogStatusRemote = Instance.new("RemoteEvent")
    dogStatusRemote.Name = Constants.DogStatusRemoteName
    dogStatusRemote.Parent = remotes
end

local dogStatusRequestRemote = remotes:FindFirstChild(Constants.DogStatusRequestRemoteName)
if not dogStatusRequestRemote then
    dogStatusRequestRemote = Instance.new("RemoteFunction")
    dogStatusRequestRemote.Name = Constants.DogStatusRequestRemoteName
    dogStatusRequestRemote.Parent = remotes
end

local huntService = HuntService.init()
local economyService = EconomyService.init()

DogService.init({
    dogCommandRemote = dogCommandRemote,
    dogStatusRemote = dogStatusRemote,
    dogStatusRequestRemote = dogStatusRequestRemote,
    huntService = huntService,
    economyService = economyService,
})
