-- The Onslaught - Zombie Removal System (Pre-Onslaught)
require "InfectionConfig"
require "InfectionUtils"

ZombieRemoval = ZombieRemoval or {}
ZombieRemoval.originalSettings = {}

-- Adjust sandbox settings to remove zombies
function ZombieRemoval.adjustSandboxSettings()
    if not InfectionConfig.RemoveZombiesPreOnslaught then
        return
    end
    
    InfectionUtils.log("Adjusting sandbox settings to remove zombies...")
    
    local options = getSandboxOptions()
    
    -- Store original settings
    ZombieRemoval.originalSettings.zombiePopulation = options:getZombieCount()
    ZombieRemoval.originalSettings.zombieRespawn = options:getZombieRespawn()
    
    -- Set to zero
    options:set("ZombieCount", 0)
    options:set("ZombieRespawn", 0)
    
    InfectionUtils.log("Sandbox settings adjusted")
end

-- Restore sandbox settings after onslaught triggers
function ZombieRemoval.restoreSandboxSettings()
    InfectionUtils.log("Restoring sandbox settings...")
    
    local options = getSandboxOptions()
    
    if InfectionConfig.UseSandboxPopulation and ZombieRemoval.originalSettings.zombiePopulation then
        options:set("ZombieCount", ZombieRemoval.originalSettings.zombiePopulation)
    else
        options:set("ZombieCount", 4)  -- Default
    end
    
    -- Keep respawn disabled during onslaught (handled by spawn controller)
    options:set("ZombieRespawn", 0)
    
    InfectionUtils.log("Sandbox settings restored")
end

-- Remove any zombies that spawn during setup phase
function ZombieRemoval.onZombieUpdate(zombie)
    if not InfectionConfig.RemoveZombiesPreOnslaught then
        return
    end
    
    -- Only remove during setup phase
    if not InfectionUtils.isInSetupPhase() then
        return
    end
    
    -- Remove the zombie
    zombie:removeFromWorld()
    zombie:removeFromSquare()
    InfectionUtils.log("Removed zombie during setup phase")
end

-- Remove all existing zombies on game start
function ZombieRemoval.removeAllZombies()
    if not InfectionConfig.RemoveZombiesPreOnslaught then
        return
    end
    
    if not InfectionUtils.isInSetupPhase() then
        return
    end
    
    InfectionUtils.log("Removing all existing zombies...")
    
    local cell = getCell()
    local zombies = cell:getZombieList()
    local count = 0
    
    for i = zombies:size() - 1, 0, -1 do
        local zombie = zombies:get(i)
        if zombie then
            zombie:removeFromWorld()
            zombie:removeFromSquare()
            count = count + 1
        end
    end
    
    InfectionUtils.log("Removed " .. count .. " zombies")
end

-- Initialize
function ZombieRemoval.initialize()
    if InfectionUtils.isInSetupPhase() then
        ZombieRemoval.adjustSandboxSettings()
        ZombieRemoval.removeAllZombies()
    end
end

-- Check every hour
function ZombieRemoval.everyHour()
    if InfectionUtils.isInSetupPhase() then
        ZombieRemoval.removeAllZombies()
    end
end

-- Initialize on game start
Events.OnGameStart.Add(ZombieRemoval.initialize)
Events.EveryHours.Add(ZombieRemoval.everyHour)
Events.OnZombieUpdate.Add(ZombieRemoval.onZombieUpdate)

return ZombieRemoval
