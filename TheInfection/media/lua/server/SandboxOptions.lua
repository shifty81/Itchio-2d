-- The Onslaught - Sandbox Options Configuration
require "InfectionConfig"

-- Load sandbox options into configuration
function InfectionConfig.loadSandboxOptions()
    local options = getSandboxOptions()
    
    if not options then
        return
    end
    
    -- Setup Phase
    local setupDays = options:getOptionByName("TheOnslaught.SetupPhaseDays")
    if setupDays then
        InfectionConfig.DaysUntilOnslaught = setupDays:getValue()
    end
    
    -- Onslaught Duration
    local onslaughtHours = options:getOptionByName("TheOnslaught.OnslaughtHours")
    if onslaughtHours then
        InfectionConfig.OnslaughtDurationHours = onslaughtHours:getValue()
    end
    
    -- Wave Interval
    local waveInterval = options:getOptionByName("TheOnslaught.WaveIntervalHours")
    if waveInterval then
        InfectionConfig.WaveIntervalHours = waveInterval:getValue()
    end
    
    -- Spawn Multiplier
    local spawnMult = options:getOptionByName("TheOnslaught.SpawnMultiplier")
    if spawnMult then
        InfectionConfig.SpawnRateMultiplier = spawnMult:getValue()
    end
    
    -- Base Zombies Per Wave
    local baseZombies = options:getOptionByName("TheOnslaught.BaseZombiesPerWave")
    if baseZombies then
        InfectionConfig.BaseZombiesPerWave = baseZombies:getValue()
    end
    
    -- Turrets Enabled
    local turretsEnabled = options:getOptionByName("TheOnslaught.TurretsEnabled")
    if turretsEnabled then
        InfectionConfig.TurretsEnabled = turretsEnabled:getValue()
    end
    
    -- Traps Enabled
    local trapsEnabled = options:getOptionByName("TheOnslaught.TrapsEnabled")
    if trapsEnabled then
        InfectionConfig.TrapsEnabled = trapsEnabled:getValue()
    end
    
    -- Stragglers Amount
    local stragglers = options:getOptionByName("TheOnslaught.StragglersAmount")
    if stragglers then
        InfectionConfig.StragglersAmount = stragglers:getValue()
    end
end

-- Initialize on server start
Events.OnServerStarted.Add(InfectionConfig.loadSandboxOptions)

return InfectionConfig
