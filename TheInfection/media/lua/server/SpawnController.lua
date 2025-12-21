-- The Onslaught - Enhanced Spawn Controller with Wave System
require "InfectionConfig"
require "InfectionUtils"

SpawnController = SpawnController or {}

-- Initialize spawn controller
function SpawnController.initialize()
    InfectionUtils.log("Spawn Controller initialized")
end

-- Main spawn logic for onslaught
function SpawnController.processSpawning()
    -- Only spawn during active onslaught
    if not InfectionUtils.isOnslaughtActive() then
        return
    end
    
    local modData = InfectionUtils.getGlobalModData()
    local currentTime = InfectionUtils.getGameTimeHours()
    
    -- Check if it's time for the next wave
    if currentTime >= modData.nextWaveTime then
        SpawnController.spawnWave()
        
        -- Schedule next wave
        modData.currentWave = modData.currentWave + 1
        modData.nextWaveTime = currentTime + InfectionConfig.WaveIntervalHours
        
        InfectionUtils.log("Wave " .. modData.currentWave .. " spawned. Next wave at " .. modData.nextWaveTime)
    end
end

-- Spawn a wave of zombies
function SpawnController.spawnWave()
    local modData = InfectionUtils.getGlobalModData()
    local waveNumber = modData.currentWave + 1
    
    -- Calculate zombies for this wave (increases with wave number)
    local baseAmount = InfectionConfig.BaseZombiesPerWave
    local multiplier = InfectionConfig.SpawnRateMultiplier
    local waveBonus = (waveNumber - 1) * 10  -- Each wave adds 10 more zombies
    local totalZombies = math.floor((baseAmount + waveBonus) * multiplier)
    
    InfectionUtils.log("Spawning Wave " .. waveNumber .. " with " .. totalZombies .. " zombies")
    
    -- Notify players
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        player:Say("WAVE " .. waveNumber .. " INCOMING! " .. totalZombies .. " zombies approaching!")
    end
    
    -- Spawn around each player
    if players:size() > 0 then
        local zombiesPerPlayer = math.floor(totalZombies / players:size())
        
        for i = 0, players:size() - 1 do
            local player = players:get(i)
            SpawnController.spawnAroundPlayer(player, zombiesPerPlayer)
        end
    end
end

-- Spawn zombies around a specific player
function SpawnController.spawnAroundPlayer(player, amount)
    local playerX = player:getX()
    local playerY = player:getY()
    local playerZ = player:getZ()
    local spawnRadius = InfectionConfig.AttackRadius
    
    for i = 1, amount do
        -- Random angle and distance
        local angle = ZombRand(360) * math.pi / 180
        local distance = spawnRadius + ZombRand(20) - 10  -- Slight variance
        
        local spawnX = playerX + math.cos(angle) * distance
        local spawnY = playerY + math.sin(angle) * distance
        
        -- Spawn zombie with variety
        SpawnController.spawnZombieWithVariety(spawnX, spawnY, playerZ)
    end
end

-- Spawn a zombie with random attributes
function SpawnController.spawnZombieWithVariety(x, y, z)
    local outfits = {
        "Naked", "Swimmer", "ConstructionWorker", 
        "Police", "Fireman", "Doctor", "Nurse",
        "Clerk", "Cook", "Postal"
    }
    
    local outfit = outfits[ZombRand(#outfits) + 1]
    
    -- Spawn the zombie
    local zombie = addZombiesInOutfit(x, y, z, outfit, 0, 1)
    
    return zombie
end

-- Clean up after onslaught (leave only stragglers)
function SpawnController.cleanupStragglers()
    if not InfectionUtils.isOnslaughtComplete() then
        return
    end
    
    if not InfectionConfig.OnlyStragglers then
        return
    end
    
    local cell = getCell()
    local zombies = cell:getZombieList()
    local zombieCount = zombies:size()
    
    -- If more than max stragglers, remove some
    if zombieCount > InfectionConfig.StragglersAmount then
        local toRemove = zombieCount - InfectionConfig.StragglersAmount
        
        for i = 0, toRemove - 1 do
            local zombie = zombies:get(i)
            if zombie then
                zombie:removeFromWorld()
                zombie:removeFromSquare()
            end
        end
        
        InfectionUtils.log("Cleaned up " .. toRemove .. " zombies, leaving " .. InfectionConfig.StragglersAmount .. " stragglers")
    end
end

-- Update every 10 minutes
function SpawnController.everyTenMinutes()
    SpawnController.processSpawning()
end

-- Update every hour
function SpawnController.everyHour()
    if InfectionUtils.isOnslaughtComplete() then
        SpawnController.cleanupStragglers()
    end
end

-- Initialize on game start
Events.OnGameStart.Add(SpawnController.initialize)
Events.EveryTenMinutes.Add(SpawnController.everyTenMinutes)
Events.EveryHours.Add(SpawnController.everyHour)

return SpawnController
