# Technical Implementation Guide

This document provides detailed technical information for implementing advanced features of "The Infection" mod.

## Table of Contents

1. [Wall Detection and Safe Zones](#wall-detection-and-safe-zones)
2. [Wall-Bashing AI Behavior](#wall-bashing-ai-behavior)
3. [Advanced Spawn Systems](#advanced-spawn-systems)
4. [Client-Server Communication](#client-server-communication)
5. [Performance Optimization](#performance-optimization)
6. [Save/Load Persistence](#saveload-persistence)

---

## Wall Detection and Safe Zones

### Overview

Safe zones are areas enclosed by player-built walls that prevent zombie spawning. Detecting these zones requires analyzing the game world to find enclosed spaces.

### Approach 1: Grid-Based Detection

This method divides the map into a grid and marks cells as "inside" or "outside" walls.

**Create `media/lua/server/SafeZoneDetector.lua`:**

```lua
-- Safe Zone Detection System
require "InfectionConfig"
require "InfectionUtils"

SafeZoneDetector = SafeZoneDetector or {}
SafeZoneDetector.safeZones = {}
SafeZoneDetector.gridSize = 10  -- Check every 10 tiles

-- Check if a tile has a wall
function SafeZoneDetector.isWall(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    if not square then return false end
    
    -- Check for player-built walls
    if square:HasStairs() or square:HaveWall() then
        return true
    end
    
    -- Check for door frames and doors
    if square:getDoorFrame() or square:getDoor() then
        return true
    end
    
    -- Check for window frames and windows
    if square:getWindow() or square:getWindowFrame() then
        return true
    end
    
    return false
end

-- Flood fill algorithm to detect enclosed areas
function SafeZoneDetector.floodFill(startX, startY, z, maxSize)
    local visited = {}
    local queue = {{x = startX, y = startY}}
    local area = {}
    local enclosed = true
    
    while #queue > 0 and #area < maxSize do
        local current = table.remove(queue, 1)
        local key = current.x .. "," .. current.y
        
        if not visited[key] then
            visited[key] = true
            table.insert(area, {x = current.x, y = current.y})
            
            -- Check adjacent tiles
            local directions = {{0,1}, {1,0}, {0,-1}, {-1,0}}
            for _, dir in ipairs(directions) do
                local newX = current.x + dir[1]
                local newY = current.y + dir[2]
                local newKey = newX .. "," .. newY
                
                if not visited[newKey] then
                    if SafeZoneDetector.isWall(newX, newY, z) then
                        -- Wall found, boundary of safe zone
                    else
                        -- Check if we've gone too far (not enclosed)
                        if math.abs(newX - startX) > 100 or math.abs(newY - startY) > 100 then
                            enclosed = false
                            break
                        end
                        table.insert(queue, {x = newX, y = newY})
                    end
                end
            end
            
            if not enclosed then
                break
            end
        end
    end
    
    return enclosed and area or nil
end

-- Detect all safe zones on the map
function SafeZoneDetector.detectSafeZones()
    InfectionUtils.log("Detecting safe zones...")
    SafeZoneDetector.safeZones = {}
    
    -- Get player positions as starting points
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        local playerX = math.floor(player:getX())
        local playerY = math.floor(player:getY())
        local playerZ = math.floor(player:getZ())
        
        -- Check if player is in an enclosed area
        local safeZone = SafeZoneDetector.floodFill(playerX, playerY, playerZ, 1000)
        if safeZone then
            table.insert(SafeZoneDetector.safeZones, {
                tiles = safeZone,
                z = playerZ,
                owner = player:getUsername()
            })
            InfectionUtils.log("Safe zone detected for " .. player:getUsername() .. " (" .. #safeZone .. " tiles)")
        end
    end
end

-- Check if a point is in any safe zone
function SafeZoneDetector.isInSafeZone(x, y, z)
    if not InfectionConfig.SafeZoneEnabled then
        return false
    end
    
    for _, zone in ipairs(SafeZoneDetector.safeZones) do
        if zone.z == z then
            for _, tile in ipairs(zone.tiles) do
                if tile.x == x and tile.y == y then
                    return true
                end
            end
        end
    end
    
    return false
end

-- Update safe zones periodically
function SafeZoneDetector.everyHour()
    SafeZoneDetector.detectSafeZones()
end

-- Initialize
Events.EveryHours.Add(SafeZoneDetector.everyHour)

return SafeZoneDetector
```

### Approach 2: Ray Casting Method

A simpler but less accurate method using ray casting from spawn points.

```lua
-- Check if point is enclosed by casting rays in all directions
function SafeZoneDetector.isEnclosed(x, y, z, maxDistance)
    local directions = {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1},
        {1, 1}, {1, -1}, {-1, 1}, {-1, -1}
    }
    
    local wallCount = 0
    for _, dir in ipairs(directions) do
        local foundWall = false
        for distance = 1, maxDistance do
            local checkX = x + (dir[1] * distance)
            local checkY = y + (dir[2] * distance)
            
            if SafeZoneDetector.isWall(checkX, checkY, z) then
                foundWall = true
                wallCount = wallCount + 1
                break
            end
        end
    end
    
    -- Enclosed if walls found in most directions
    return wallCount >= 6
end
```

---

## Wall-Bashing AI Behavior

### Overview

Modify zombie AI to specifically target and attack player-built structures.

### Implementation

**Create `media/lua/server/WallAttackAI.lua`:**

```lua
-- Wall Attack AI System
require "InfectionConfig"
require "InfectionUtils"

WallAttackAI = WallAttackAI or {}
WallAttackAI.zombieTargets = {}

-- Find nearest player structure
function WallAttackAI.findNearestStructure(zombie)
    local zombieX = zombie:getX()
    local zombieY = zombie:getY()
    local zombieZ = zombie:getZ()
    
    local nearestDist = 999999
    local nearestSquare = nil
    local searchRadius = InfectionConfig.AttackRadius
    
    -- Search area around zombie
    for dx = -searchRadius, searchRadius do
        for dy = -searchRadius, searchRadius do
            local checkX = math.floor(zombieX + dx)
            local checkY = math.floor(zombieY + dy)
            local square = getCell():getGridSquare(checkX, checkY, zombieZ)
            
            if square then
                -- Check if square has player-built structures
                if WallAttackAI.hasPlayerStructure(square) then
                    local dist = math.sqrt(dx*dx + dy*dy)
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestSquare = square
                    end
                end
            end
        end
    end
    
    return nearestSquare, nearestDist
end

-- Check if square has player-built structures
function WallAttackAI.hasPlayerStructure(square)
    -- Check for walls
    if square:HaveWall() then
        return true
    end
    
    -- Check for doors
    local door = square:getDoor()
    if door and door:isBarricaded() then
        return true
    end
    
    -- Check for windows
    local window = square:getWindow()
    if window and window:isBarricaded() then
        return true
    end
    
    -- Check for furniture/constructions
    local objects = square:getObjects()
    for i = 0, objects:size() - 1 do
        local obj = objects:get(i)
        if instanceof(obj, "IsoThumpable") then
            return true
        end
    end
    
    return false
end

-- Make zombie attack structure
function WallAttackAI.attackStructure(zombie, square)
    if not square then return end
    
    -- Find attackable object
    local target = nil
    
    -- Priority: Doors > Windows > Walls > Furniture
    local door = square:getDoor()
    if door then
        target = door
    else
        local window = square:getWindow()
        if window then
            target = window
        else
            local objects = square:getObjects()
            for i = 0, objects:size() - 1 do
                local obj = objects:get(i)
                if instanceof(obj, "IsoThumpable") then
                    target = obj
                    break
                end
            end
        end
    end
    
    if target then
        -- Make zombie thump the target
        zombie:setTarget(target)
        zombie:pathToCharacter()
        
        -- Apply damage with multiplier
        local baseDamage = 1
        local damage = baseDamage * InfectionConfig.WallDamageMultiplier
        target:Thump(zombie, damage)
        
        -- Sound effect
        zombie:getEmitter():playSound("ZombieThumpGeneric")
    end
end

-- Update zombie behavior
function WallAttackAI.onZombieUpdate(zombie)
    if not InfectionConfig.ZombiesAttackWalls then
        return
    end
    
    -- Only after infection
    if not InfectionUtils.isInfectionTriggered() then
        return
    end
    
    -- Check every few updates (performance)
    if ZombRand(100) > 10 then
        return
    end
    
    -- Don't override if zombie has player target
    local targetChar = zombie:getTarget()
    if targetChar and instanceof(targetChar, "IsoPlayer") then
        return
    end
    
    -- Find and attack nearest structure
    local targetSquare, distance = WallAttackAI.findNearestStructure(zombie)
    if targetSquare and distance < InfectionConfig.AttackRadius then
        WallAttackAI.attackStructure(zombie, targetSquare)
    end
end

-- Hook into zombie updates
Events.OnZombieUpdate.Add(WallAttackAI.onZombieUpdate)

return WallAttackAI
```

### Optimization

For better performance with many zombies:

```lua
-- Batch processing with update intervals
WallAttackAI.updateCounter = 0
WallAttackAI.zombiesToUpdate = {}

function WallAttackAI.queueZombieUpdate(zombie)
    table.insert(WallAttackAI.zombiesToUpdate, zombie)
end

function WallAttackAI.processBatch()
    WallAttackAI.updateCounter = WallAttackAI.updateCounter + 1
    
    -- Process batch every 10 ticks
    if WallAttackAI.updateCounter % 10 == 0 then
        for i = 1, math.min(50, #WallAttackAI.zombiesToUpdate) do
            local zombie = table.remove(WallAttackAI.zombiesToUpdate, 1)
            if zombie then
                WallAttackAI.updateZombieBehavior(zombie)
            end
        end
    end
end

Events.OnTick.Add(WallAttackAI.processBatch)
```

---

## Advanced Spawn Systems

### Wave System with Escalation

**Enhanced `SpawnController.lua`:**

```lua
-- Wave configuration
SpawnController.waves = {
    {number = 1, size = 50, delay = 30},
    {number = 2, size = 75, delay = 25},
    {number = 3, size = 100, delay = 20},
    {number = 4, size = 150, delay = 15},
    {number = 5, size = 200, delay = 10}
}

-- Get wave configuration
function SpawnController.getWaveConfig(waveNumber)
    for _, wave in ipairs(SpawnController.waves) do
        if wave.number == waveNumber then
            return wave
        end
    end
    
    -- Default for waves beyond configuration
    return {
        number = waveNumber,
        size = 200 + (waveNumber - 5) * 50,
        delay = 10
    }
end

-- Spawn with variety
function SpawnController.spawnZombieWithVariety(x, y, z)
    local outfits = {
        "Naked", "Swimmer", "ConstructionWorker", 
        "Police", "Fireman", "Doctor", "Cook"
    }
    
    local outfit = outfits[ZombRand(#outfits) + 1]
    
    -- Random stats
    local speedMultiplier = 0.8 + (ZombRandFloat(0.4))
    local strengthMultiplier = 0.8 + (ZombRandFloat(0.4))
    
    -- Spawn zombie
    local zombie = addZombiesInOutfit(x, y, z, 1, outfit, 0, false, false, false, false, speedMultiplier)
    
    return zombie
end

-- Spawn special infected (boss zombies)
function SpawnController.spawnSpecialInfected(x, y, z, type)
    local zombie = nil
    
    if type == "Tank" then
        -- High health, slow, strong
        zombie = addZombiesInOutfit(x, y, z, 1, "ConstructionWorker", 0, false, false, false, false, 0.5)
        if zombie then
            zombie:setHealth(zombie:getHealth() * 3)
        end
    elseif type == "Runner" then
        -- Fast, low health
        zombie = addZombiesInOutfit(x, y, z, 1, "Naked", 0, false, true, false, false, 2.0)
    elseif type == "Spitter" then
        -- Ranged attacker (placeholder)
        zombie = addZombiesInOutfit(x, y, z, 1, "Doctor", 0, false, false, false, false, 1.0)
    end
    
    return zombie
end

-- Enhanced wave spawning
function SpawnController.spawnEnhancedWave()
    local config = SpawnController.getWaveConfig(SpawnController.waveNumber)
    
    InfectionUtils.log("Spawning enhanced wave #" .. SpawnController.waveNumber)
    
    -- Notify players
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        player:Say("Wave " .. SpawnController.waveNumber .. " incoming! (" .. config.size .. " enemies)")
    end
    
    -- Spawn around each player
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        local zombiesPerPlayer = math.floor(config.size / players:size())
        
        -- 90% normal zombies
        for j = 1, zombiesPerPlayer * 0.9 do
            local angle = ZombRand(360) * math.pi / 180
            local distance = InfectionConfig.AttackRadius + ZombRand(20)
            local x = player:getX() + math.cos(angle) * distance
            local y = player:getY() + math.sin(angle) * distance
            
            if not SafeZoneDetector.isInSafeZone(math.floor(x), math.floor(y), player:getZ()) then
                SpawnController.spawnZombieWithVariety(x, y, player:getZ())
            end
        end
        
        -- 10% special infected
        for j = 1, zombiesPerPlayer * 0.1 do
            local types = {"Tank", "Runner", "Spitter"}
            local type = types[ZombRand(#types) + 1]
            
            local angle = ZombRand(360) * math.pi / 180
            local distance = InfectionConfig.AttackRadius + ZombRand(20)
            local x = player:getX() + math.cos(angle) * distance
            local y = player:getY() + math.sin(angle) * distance
            
            if not SafeZoneDetector.isInSafeZone(math.floor(x), math.floor(y), player:getZ()) then
                SpawnController.spawnSpecialInfected(x, y, player:getZ(), type)
            end
        end
    end
    
    -- Schedule next wave
    SpawnController.nextWaveTime = InfectionUtils.getGameTimeHours() + (config.delay / 60)
end
```

---

## Client-Server Communication

### Protocol Implementation

**Server commands:**

```lua
-- Server handling client requests
function InfectionServer.onClientCommand(module, command, player, args)
    if module ~= "TheInfection" then return end
    
    if command == "RequestInfectionStatus" then
        local modData = InfectionUtils.getGlobalModData()
        sendServerCommand(player, module, "InfectionStatusResponse", {
            triggered = modData.infectionTriggered,
            timeRemaining = InfectionTimer.getTimeRemaining(),
            waveNumber = SpawnController.waveNumber
        })
    elseif command == "RequestSafeZoneCheck" then
        local x, y, z = args.x, args.y, args.z
        local isSafe = SafeZoneDetector.isInSafeZone(x, y, z)
        sendServerCommand(player, module, "SafeZoneResponse", {
            x = x, y = y, z = z, safe = isSafe
        })
    end
end

Events.OnClientCommand.Add(InfectionServer.onClientCommand)
```

**Client requests:**

```lua
-- Client requesting data from server
function InfectionClient.requestInfectionStatus()
    sendClientCommand("TheInfection", "RequestInfectionStatus", {})
end

function InfectionClient.onServerCommand(module, command, args)
    if module ~= "TheInfection" then return end
    
    if command == "InfectionStatusResponse" then
        InfectionClient.triggered = args.triggered
        InfectionClient.timeRemaining = args.timeRemaining
        InfectionClient.waveNumber = args.waveNumber
    elseif command == "SafeZoneResponse" then
        -- Update local safe zone knowledge
    end
end

Events.OnServerCommand.Add(InfectionClient.onServerCommand)
```

---

## Performance Optimization

### Spatial Partitioning

```lua
-- Divide map into chunks for efficient querying
SpatialGrid = {}
SpatialGrid.cellSize = 50
SpatialGrid.grid = {}

function SpatialGrid.getCellKey(x, y)
    local cellX = math.floor(x / SpatialGrid.cellSize)
    local cellY = math.floor(y / SpatialGrid.cellSize)
    return cellX .. "," .. cellY
end

function SpatialGrid.addZombie(zombie)
    local key = SpatialGrid.getCellKey(zombie:getX(), zombie:getY())
    if not SpatialGrid.grid[key] then
        SpatialGrid.grid[key] = {}
    end
    table.insert(SpatialGrid.grid[key], zombie)
end

function SpatialGrid.getZombiesNear(x, y, radius)
    local zombies = {}
    local minX = x - radius
    local maxX = x + radius
    local minY = y - radius
    local maxY = y + radius
    
    -- Check relevant cells
    for cx = math.floor(minX / SpatialGrid.cellSize), math.floor(maxX / SpatialGrid.cellSize) do
        for cy = math.floor(minY / SpatialGrid.cellSize), math.floor(maxY / SpatialGrid.cellSize) do
            local key = cx .. "," .. cy
            if SpatialGrid.grid[key] then
                for _, zombie in ipairs(SpatialGrid.grid[key]) do
                    table.insert(zombies, zombie)
                end
            end
        end
    end
    
    return zombies
end
```

### Update Throttling

```lua
-- Limit updates based on distance from players
function OptimizationManager.shouldUpdateZombie(zombie)
    local players = getOnlinePlayers()
    local minDist = 999999
    
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        local dist = math.sqrt(
            (zombie:getX() - player:getX())^2 + 
            (zombie:getY() - player:getY())^2
        )
        minDist = math.min(minDist, dist)
    end
    
    -- Update frequency based on distance
    if minDist < 30 then
        return true  -- Every frame
    elseif minDist < 60 then
        return ZombRand(10) < 5  -- 50% of frames
    elseif minDist < 100 then
        return ZombRand(10) < 2  -- 20% of frames
    else
        return ZombRand(100) < 1  -- 1% of frames
    end
end
```

---

## Save/Load Persistence

### Saving Mod Data

```lua
-- Save infection state
function InfectionPersistence.save()
    local modData = InfectionUtils.getGlobalModData()
    
    -- ModData is automatically saved by the game
    -- Just ensure all important data is in modData
    
    InfectionUtils.log("Saving infection state: triggered=" .. tostring(modData.infectionTriggered))
end

-- Load infection state
function InfectionPersistence.load()
    local modData = InfectionUtils.getGlobalModData()
    
    -- Restore state
    if modData.infectionTriggered then
        InfectionUtils.log("Loading: Infection already triggered")
        SpawnController.activate()
        ZombieRemoval.restoreSandboxSettings()
    else
        InfectionUtils.log("Loading: Pre-infection state")
        ZombieRemoval.adjustSandboxSettings()
    end
end

Events.OnSave.Add(InfectionPersistence.save)
Events.OnLoad.Add(InfectionPersistence.load)
```

### Player-Specific Data

```lua
-- Save player progress
function InfectionPersistence.savePlayerData(player)
    local playerData = InfectionUtils.getPlayerModData(player)
    
    -- Player-specific achievements, stats, etc.
    playerData.wavessurvived = SpawnController.waveNumber
    playerData.zombiesKilled = player:getZombieKills()
    playerData.daysSurvived = math.floor(InfectionUtils.getGameTimeHours() / 24)
end

Events.OnPlayerDeath.Add(InfectionPersistence.savePlayerData)
```

---

## Conclusion

This technical guide provides the foundation for implementing advanced features of "The Infection" mod. Use these examples as starting points and adapt them to your specific needs. Remember to test thoroughly and optimize for performance, especially in multiplayer scenarios.

For additional help, consult:
- Project Zomboid Lua API documentation
- Community forums for specific issues
- Other mod source code for reference implementations
