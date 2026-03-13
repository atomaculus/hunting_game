local Constants = {}

Constants.RemoteFolderName = "Remotes"
Constants.DogCommandRemoteName = "DogCommand"
Constants.DogStatusRemoteName = "DogStatus"
Constants.DogStatusRequestRemoteName = "DogStatusRequest"

Constants.DogCommands = {
    Follow = "Follow",
    Search = "Search",
    Retrieve = "Retrieve",
}

Constants.DogState = {
    Healthy = "Healthy",
    Hungry = "Hungry",
    Exhausted = "Exhausted",
}

Constants.DefaultDogName = "Labrador cobrador"
Constants.DefaultDogBreedKey = "LabradorRetriever"
Constants.DefaultCoins = 0

Constants.InputBindings = {
    Follow = Enum.KeyCode.Z,
    Search = Enum.KeyCode.X,
    Retrieve = Enum.KeyCode.C,
}

return Constants
