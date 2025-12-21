-- The Onslaught - Timer and Event Controller
require "InfectionConfig"
require "InfectionUtils"

InfectionTimer = InfectionTimer or {}

-- Check and trigger onslaught if time is up
function InfectionTimer.checkOnslaughtTimer()
    local modData = InfectionUtils.getGlobalModData()
    
    -- Skip if onslaught already triggered
    if modData.onslaughtTriggered then
        return
    end
    
    local timeRemaining = InfectionUtils.getTimeUntilOnslaught()
    
    -- Send warnings at key intervals
    if timeRemaining > 0 then
        -- Warning at 24 hours
        if timeRemaining <= 24 and timeRemaining > 23.9 then
            InfectionTimer.sendWarning("WARNING: The Onslaught begins in 24 hours! Prepare your defenses!")
        end
        -- Warning at 6 hours
        if timeRemaining <= 6 and timeRemaining > 5.9 then
            InfectionTimer.sendWarning("WARNING: The Onslaught begins in 6 hours!")
        end
        -- Warning at 1 hour
        if timeRemaining <= 1 and timeRemaining > 0.9 then
            InfectionTimer.sendWarning("WARNING: The Onslaught begins in 1 hour!")
        end
    end
    
    -- Trigger onslaught when time is up
    if timeRemaining <= 0 then
        InfectionTimer.triggerOnslaught()
    end
end

-- Trigger the onslaught event
function InfectionTimer.triggerOnslaught()
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.onslaughtTriggered then
        return  -- Already triggered
    end
    
    InfectionUtils.log("ONSLAUGHT TRIGGERED!")
    
    modData.onslaughtTriggered = true
    modData.onslaughtStartTime = InfectionUtils.getGameTimeHours()
    modData.currentWave = 0
    modData.nextWaveTime = modData.onslaughtStartTime
    
    -- Notify all players
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        player:Say("THE ONSLAUGHT HAS BEGUN! 18 hours of hell await...")
    end
    
    InfectionUtils.log("Onslaught will last for " .. InfectionConfig.OnslaughtDurationHours .. " hours")
end

-- Check if onslaught should end
function InfectionTimer.checkOnslaughtEnd()
    local modData = InfectionUtils.getGlobalModData()
    
    if not modData.onslaughtTriggered or modData.onslaughtComplete then
        return
    end
    
    local timeRemaining = InfectionUtils.getTimeRemainingInOnslaught()
    
    -- Send warnings
    if timeRemaining <= 2 and timeRemaining > 1.9 then
        InfectionTimer.sendWarning("The Onslaught will end in 2 hours. Hold the line!")
    end
    if timeRemaining <= 0.5 and timeRemaining > 0.4 then
        InfectionTimer.sendWarning("The Onslaught will end in 30 minutes!")
    end
    
    -- End onslaught
    if timeRemaining <= 0 then
        InfectionTimer.endOnslaught()
    end
end

-- End the onslaught event
function InfectionTimer.endOnslaught()
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.onslaughtComplete then
        return  -- Already ended
    end
    
    InfectionUtils.log("ONSLAUGHT COMPLETE!")
    
    modData.onslaughtComplete = true
    
    -- Notify all players
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        player:Say("The Onslaught has ended! Only stragglers remain. You are safe... for now.")
    end
end

-- Send warning to all players
function InfectionTimer.sendWarning(message)
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        player:Say(message)
    end
    InfectionUtils.log(message)
end

-- Update every hour
function InfectionTimer.everyHour()
    InfectionTimer.checkOnslaughtTimer()
    InfectionTimer.checkOnslaughtEnd()
end

-- Update every 10 minutes for more precise timing
function InfectionTimer.everyTenMinutes()
    InfectionTimer.checkOnslaughtTimer()
    InfectionTimer.checkOnslaughtEnd()
end

-- Initialize
Events.EveryHours.Add(InfectionTimer.everyHour)
Events.EveryTenMinutes.Add(InfectionTimer.everyTenMinutes)

return InfectionTimer
