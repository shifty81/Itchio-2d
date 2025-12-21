-- The Onslaught - Defensive Structures System
require "InfectionConfig"
require "InfectionUtils"

DefensiveStructures = DefensiveStructures or {}

-- Track active turrets and traps
DefensiveStructures.activeTurrets = {}
DefensiveStructures.activeTraps = {}

-- Initialize defensive structures system
function DefensiveStructures.initialize()
    InfectionUtils.log("Defensive Structures system initialized")
end

-- Process turret attacks
function DefensiveStructures.updateTurrets()
    if not InfectionConfig.TurretsEnabled then
        return
    end
    
    -- Only during onslaught
    if not InfectionUtils.isOnslaughtActive() then
        return
    end
    
    local cell = getCell()
    local zombies = cell:getZombieList()
    
    -- Check each turret
    for _, turretData in ipairs(DefensiveStructures.activeTurrets) do
        DefensiveStructures.turretFire(turretData, zombies)
    end
end

-- Turret fires at nearby zombies
function DefensiveStructures.turretFire(turretData, zombies)
    local turretX = turretData.x
    local turretY = turretData.y
    local turretZ = turretData.z
    local range = InfectionConfig.TurretRange
    
    -- Find closest zombie in range
    local closestZombie = nil
    local closestDist = range + 1
    
    for i = 0, zombies:size() - 1 do
        local zombie = zombies:get(i)
        if zombie then
            local zombieX = zombie:getX()
            local zombieY = zombie:getY()
            local zombieZ = zombie:getZ()
            
            -- Same floor level
            if zombieZ == turretZ then
                local dist = math.sqrt((zombieX - turretX)^2 + (zombieY - turretY)^2)
                
                if dist < closestDist then
                    closestDist = dist
                    closestZombie = zombie
                end
            end
        end
    end
    
    -- Fire at closest zombie
    if closestZombie then
        -- Check ammo if required
        if InfectionConfig.TurretAmmoRequired and turretData.ammo <= 0 then
            return
        end
        
        -- Deal damage
        closestZombie:setHealth(closestZombie:getHealth() - InfectionConfig.TurretDamage)
        
        -- Consume ammo
        if InfectionConfig.TurretAmmoRequired then
            turretData.ammo = turretData.ammo - 1
        end
        
        InfectionUtils.log("Turret fired at zombie")
    end
end

-- Process trap effects
function DefensiveStructures.updateTraps()
    if not InfectionConfig.TrapsEnabled then
        return
    end
    
    local cell = getCell()
    local zombies = cell:getZombieList()
    
    -- Check each trap
    for _, trapData in ipairs(DefensiveStructures.activeTraps) do
        DefensiveStructures.checkTrapTrigger(trapData, zombies)
    end
end

-- Check if zombie triggers trap
function DefensiveStructures.checkTrapTrigger(trapData, zombies)
    local trapX = trapData.x
    local trapY = trapData.y
    local trapZ = trapData.z
    
    for i = 0, zombies:size() - 1 do
        local zombie = zombies:get(i)
        if zombie then
            local zombieX = math.floor(zombie:getX())
            local zombieY = math.floor(zombie:getY())
            local zombieZ = math.floor(zombie:getZ())
            
            -- Check if zombie is on trap
            if zombieX == trapX and zombieY == trapY and zombieZ == trapZ then
                DefensiveStructures.triggerTrap(trapData, zombie)
            end
        end
    end
end

-- Trigger trap effect on zombie
function DefensiveStructures.triggerTrap(trapData, zombie)
    local trapType = trapData.type
    
    if trapType == "snare" then
        -- Snare trap: slow and hold zombie
        zombie:setMovementSpeed(0.1)
        trapData.triggered = true
        InfectionUtils.log("Snare trap triggered!")
        
    elseif trapType == "spike" then
        -- Spike trap: deal damage
        zombie:setHealth(zombie:getHealth() - InfectionConfig.SpikeTrapDamage)
        trapData.uses = trapData.uses - 1
        InfectionUtils.log("Spike trap triggered!")
        
        -- Remove trap if uses exhausted
        if trapData.uses <= 0 then
            DefensiveStructures.removeTrap(trapData)
        end
        
    elseif trapType == "barbwire" then
        -- Barbwire: continuous damage and slow
        zombie:setMovementSpeed(zombie:getMovementSpeed() * InfectionConfig.BarbwireSlowFactor)
        zombie:setHealth(zombie:getHealth() - InfectionConfig.BarbwireDamage)
        InfectionUtils.log("Barbwire trap triggered!")
    end
end

-- Add a turret to the world
function DefensiveStructures.placeTurret(x, y, z, ammo)
    local turretData = {
        x = x,
        y = y,
        z = z,
        ammo = ammo or 500,
        active = true
    }
    
    table.insert(DefensiveStructures.activeTurrets, turretData)
    InfectionUtils.log("Turret placed at (" .. x .. ", " .. y .. ", " .. z .. ")")
    
    return turretData
end

-- Add a trap to the world
function DefensiveStructures.placeTrap(x, y, z, trapType)
    local trapData = {
        x = x,
        y = y,
        z = z,
        type = trapType,
        triggered = false,
        uses = 10  -- Number of times trap can be triggered
    }
    
    table.insert(DefensiveStructures.activeTraps, trapData)
    InfectionUtils.log(trapType .. " trap placed at (" .. x .. ", " .. y .. ", " .. z .. ")")
    
    return trapData
end

-- Remove a trap
function DefensiveStructures.removeTrap(trapData)
    for i, trap in ipairs(DefensiveStructures.activeTraps) do
        if trap == trapData then
            table.remove(DefensiveStructures.activeTraps, i)
            InfectionUtils.log("Trap removed")
            return
        end
    end
end

-- Update every few seconds
function DefensiveStructures.everyTenMinutes()
    DefensiveStructures.updateTurrets()
    DefensiveStructures.updateTraps()
end

-- Initialize on game start
Events.OnGameStart.Add(DefensiveStructures.initialize)
Events.EveryTenMinutes.Add(DefensiveStructures.everyTenMinutes)

return DefensiveStructures
