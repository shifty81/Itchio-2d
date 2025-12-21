-- The Onslaught - Configuration
InfectionConfig = InfectionConfig or {}

-- Setup Phase Settings (Pre-Onslaught)
InfectionConfig.SetupPhaseEnabled = true
InfectionConfig.DaysUntilOnslaught = 7  -- Days before onslaught starts
InfectionConfig.ShowUITimer = true      -- Display countdown on screen

-- Onslaught Event Settings
InfectionConfig.OnslaughtDurationHours = 18  -- Duration of the onslaught
InfectionConfig.WaveIntervalHours = 2        -- Spawn wave every 2 hours
InfectionConfig.SpawnRateMultiplier = 2.0    -- Doubled spawn rates during onslaught
InfectionConfig.BaseZombiesPerWave = 50      -- Base number per wave

-- Zombie Settings (Pre-Onslaught)
InfectionConfig.RemoveZombiesPreOnslaught = true
InfectionConfig.DisableZombieRespawn = true

-- Post-Onslaught Settings
InfectionConfig.OnlyStragglers = true        -- Only stragglers after onslaught
InfectionConfig.StragglersAmount = 10        -- Max stragglers remaining
InfectionConfig.NoRespawnAfterOnslaught = true  -- No respawning until next event

-- Wall Attack Settings
InfectionConfig.ZombiesAttackWalls = true
InfectionConfig.WallDamageMultiplier = 1.5
InfectionConfig.AttackRadius = 50  -- Tiles from player base

-- Safe Zone Settings
InfectionConfig.SafeZoneEnabled = true
InfectionConfig.MinWallHeight = 1
InfectionConfig.RequireFullEnclosure = true

-- Defensive Structures
InfectionConfig.TurretsEnabled = true
InfectionConfig.TurretDamage = 10
InfectionConfig.TurretRange = 15
InfectionConfig.TurretAmmoRequired = true

InfectionConfig.TrapsEnabled = true
InfectionConfig.SnareTrapDuration = 10  -- Seconds zombies are trapped
InfectionConfig.SpikeTrapDamage = 25
InfectionConfig.BarbwireDamage = 5
InfectionConfig.BarbwireSlowFactor = 0.5

-- Sandbox Integration
InfectionConfig.UseSandboxPopulation = true  -- Use sandbox zombie population settings

-- Debug Settings
InfectionConfig.DebugMode = false
InfectionConfig.DebugTimerMultiplier = 1.0  -- Speed up time for testing

return InfectionConfig
