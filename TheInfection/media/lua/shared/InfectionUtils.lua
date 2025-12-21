-- The Onslaught - Shared Utility Functions
InfectionUtils = InfectionUtils or {}

-- Logging function
function InfectionUtils.log(message)
    if InfectionConfig.DebugMode then
        print("[The Onslaught] " .. tostring(message))
    end
end

-- Get global mod data
function InfectionUtils.getGlobalModData()
    local modData = ModData.getOrCreate("TheOnslaught")
    
    -- Initialize defaults if not set
    if modData.onslaughtTriggered == nil then
        modData.onslaughtTriggered = false
    end
    if modData.onslaughtStartTime == nil then
        modData.onslaughtStartTime = 0
    end
    if modData.onslaughtComplete == nil then
        modData.onslaughtComplete = false
    end
    if modData.setupPhaseStartTime == nil then
        modData.setupPhaseStartTime = 0
    end
    if modData.currentWave == nil then
        modData.currentWave = 0
    end
    if modData.nextWaveTime == nil then
        modData.nextWaveTime = 0
    end
    
    return modData
end

-- Get player-specific mod data
function InfectionUtils.getPlayerModData(player)
    local modData = player:getModData()
    if not modData.TheOnslaught then
        modData.TheOnslaught = {}
    end
    return modData.TheOnslaught
end

-- Get current game time in hours
function InfectionUtils.getGameTimeHours()
    local gameTime = getGameTime()
    return gameTime:getWorldAgeHours()
end

-- Check if onslaught is active
function InfectionUtils.isOnslaughtActive()
    local modData = InfectionUtils.getGlobalModData()
    
    if not modData.onslaughtTriggered or modData.onslaughtComplete then
        return false
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local elapsedHours = currentTime - modData.onslaughtStartTime
    
    return elapsedHours < InfectionConfig.OnslaughtDurationHours
end

-- Check if onslaught has completed
function InfectionUtils.isOnslaughtComplete()
    local modData = InfectionUtils.getGlobalModData()
    return modData.onslaughtComplete == true
end

-- Check if in setup phase
function InfectionUtils.isInSetupPhase()
    local modData = InfectionUtils.getGlobalModData()
    return not modData.onslaughtTriggered
end

-- Get time remaining until onslaught
function InfectionUtils.getTimeUntilOnslaught()
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.onslaughtTriggered then
        return 0
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local targetTime = modData.setupPhaseStartTime + (InfectionConfig.DaysUntilOnslaught * 24)
    local remaining = targetTime - currentTime
    
    return math.max(0, remaining)
end

-- Get time remaining in onslaught
function InfectionUtils.getTimeRemainingInOnslaught()
    local modData = InfectionUtils.getGlobalModData()
    
    if not modData.onslaughtTriggered or modData.onslaughtComplete then
        return 0
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local elapsedHours = currentTime - modData.onslaughtStartTime
    local remaining = InfectionConfig.OnslaughtDurationHours - elapsedHours
    
    return math.max(0, remaining)
end

-- Format time as string
function InfectionUtils.formatTime(hours)
    local days = math.floor(hours / 24)
    local remainingHours = math.floor(hours % 24)
    local minutes = math.floor((hours % 1) * 60)
    
    if days > 0 then
        return string.format("%dd %dh %dm", days, remainingHours, minutes)
    elseif remainingHours > 0 then
        return string.format("%dh %dm", remainingHours, minutes)
    else
        return string.format("%dm", minutes)
    end
end

return InfectionUtils
