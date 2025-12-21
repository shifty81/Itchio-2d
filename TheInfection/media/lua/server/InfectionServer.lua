-- The Onslaught - Server Initialization
require "InfectionConfig"
require "InfectionUtils"

InfectionServer = InfectionServer or {}

-- Initialize server systems
function InfectionServer.initialize()
    InfectionUtils.log("Initializing The Onslaught server systems...")
    
    -- Get or create mod data
    local modData = InfectionUtils.getGlobalModData()
    
    -- If this is a new game, initialize setup phase
    if modData.setupPhaseStartTime == 0 then
        modData.setupPhaseStartTime = InfectionUtils.getGameTimeHours()
        InfectionUtils.log("Setup phase started at " .. modData.setupPhaseStartTime .. " hours")
    end
    
    InfectionUtils.log("Server initialization complete")
end

-- Handle client commands
function InfectionServer.onClientCommand(module, command, player, args)
    if module ~= "TheOnslaught" then return end
    
    if command == "RequestStatus" then
        local modData = InfectionUtils.getGlobalModData()
        sendServerCommand(player, module, "StatusResponse", {
            onslaughtTriggered = modData.onslaughtTriggered,
            onslaughtComplete = modData.onslaughtComplete,
            timeUntilOnslaught = InfectionUtils.getTimeUntilOnslaught(),
            timeRemainingInOnslaught = InfectionUtils.getTimeRemainingInOnslaught(),
            currentWave = modData.currentWave
        })
    end
end

-- Initialize on game start
Events.OnGameStart.Add(InfectionServer.initialize)
Events.OnClientCommand.Add(InfectionServer.onClientCommand)

return InfectionServer
