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

Constants.PreyState = {
    Detected = "Detected",
    Retrievable = "Retrievable",
}

Constants.DefaultDogName = "Labrador cobrador"
Constants.DefaultDogBreedKey = "LabradorRetriever"
Constants.DefaultCoins = 0
Constants.WorldDogFolderName = "Dogs"
Constants.WorldPreyFolderName = "ActivePrey"

Constants.WorldDog = {
    SpawnOffset = Vector3.new(4, 0, 4),
    FollowOffset = Vector3.new(-3, 0, 5),
    SearchOffset = Vector3.new(0, 0, 10),
    RetrieveOffset = Vector3.new(2, 0, 7),
    FollowSpeed = 18,
    TeleportDistance = 60,
    BillboardStudsOffset = Vector3.new(0, 4.5, 0),
}

Constants.WorldPrey = {
    SearchDistanceMin = 18,
    SearchDistanceMax = 30,
    SearchLateralSpread = 12,
    ActivationDistance = 6,
    MarkDurationSeconds = 3.5,
    ProgressSteps = 10,
    RetrieveDistance = 10,
    BillboardStudsOffset = Vector3.new(0, 3.5, 0),
    DogSearchOrbitOffset = Vector3.new(-4, 0, 3),
}

Constants.InputBindings = {
    Follow = Enum.KeyCode.Z,
    Search = Enum.KeyCode.X,
    Retrieve = Enum.KeyCode.C,
}

return Constants
