-- The Onslaught - Client Initialization
require "InfectionConfig"
require "InfectionUtils"

InfectionClient = InfectionClient or {}

-- Client state
InfectionClient.onslaughtTriggered = false
InfectionClient.onslaughtComplete = false
InfectionClient.timeUntilOnslaught = 0
InfectionClient.timeRemainingInOnslaught = 0
InfectionClient.currentWave = 0

-- Initialize client
function InfectionClient.initialize()
    InfectionUtils.log("Initializing The Onslaught client...")
    
    -- Request status from server
    InfectionClient.requestStatus()
end

-- Request status from server
function InfectionClient.requestStatus()
    sendClientCommand("TheOnslaught", "RequestStatus", {})
end

-- Handle server responses
function InfectionClient.onServerCommand(module, command, args)
    if module ~= "TheOnslaught" then return end
    
    if command == "StatusResponse" then
        InfectionClient.onslaughtTriggered = args.onslaughtTriggered
        InfectionClient.onslaughtComplete = args.onslaughtComplete
        InfectionClient.timeUntilOnslaught = args.timeUntilOnslaught
        InfectionClient.timeRemainingInOnslaught = args.timeRemainingInOnslaught
        InfectionClient.currentWave = args.currentWave
    end
end

-- Periodic status update
function InfectionClient.everyTenMinutes()
    InfectionClient.requestStatus()
end

-- Initialize on game start
Events.OnGameStart.Add(InfectionClient.initialize)
Events.OnServerCommand.Add(InfectionClient.onServerCommand)
Events.EveryTenMinutes.Add(InfectionClient.everyTenMinutes)

return InfectionClient
