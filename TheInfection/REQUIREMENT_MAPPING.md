# Problem Statement Mapping

This document maps each requirement from the problem statement to its implementation in the mod.

## Original Problem Statement

> the onslaught happens a full 18 hours causing your charachter to reach their limits if you survive the onslaught you will be safe as only straggler zombies remain until cleared out there will be no further spawning until timer for next event reaches zero all settings configurable and zombie amount is configurable based on settings already in game however for in such a dense area the rate of spawn for the event is doubled for the entire 18 hours every 2 hours more spawn you must cull before they breach new trap ssytems will be implemented as well ad new turrets that can be placed and snare traps and barbwire fencing and spike traps it will take alot to get your base safe to stop the onslaught time until event from world start configurable to give player a setup phase almost like 7 days style

## Requirement Breakdown and Implementation

### 1. "the onslaught happens a full 18 hours"

**Requirement**: Onslaught event lasts 18 hours

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.OnslaughtDurationHours = 18
  ```
- File: `InfectionTimer.lua`
  - Function: `checkOnslaughtEnd()` monitors duration
  - Function: `endOnslaught()` triggers at 18-hour mark

**Configuration**:
- Sandbox option: "Onslaught Duration (Hours)"
- Range: 1-48 hours
- Default: 18 hours

### 2. "if you survive the onslaught you will be safe as only straggler zombies remain"

**Requirement**: After onslaught, only limited stragglers remain

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.OnlyStragglers = true
  InfectionConfig.StragglersAmount = 10
  ```
- File: `SpawnController.lua`
  - Function: `cleanupStragglers()` reduces zombies to configured amount

**Configuration**:
- Sandbox option: "Stragglers After Onslaught"
- Range: 0-100
- Default: 10

### 3. "there will be no further spawning until timer for next event reaches zero"

**Requirement**: No zombie respawning after onslaught ends

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.NoRespawnAfterOnslaught = true
  ```
- File: `SpawnController.lua`
  - Function: `processSpawning()` only spawns during active onslaught
  - Condition: `if not InfectionUtils.isOnslaughtActive() then return end`

### 4. "all settings configurable"

**Requirement**: All parameters should be configurable

**Implementation**:
- File: `sandbox-options.txt` - Defines 8 configurable options
- File: `SandboxOptions.lua` - Loads options into config
- File: `Sandbox_EN.txt` - Provides descriptions

**Configurable Options**:
1. Setup Phase Duration (1-30 days)
2. Onslaught Duration (1-48 hours)
3. Wave Interval (1-12 hours)
4. Spawn Multiplier (0.5-10.0x)
5. Base Zombies Per Wave (10-500)
6. Stragglers Amount (0-100)
7. Turrets Enabled (on/off)
8. Traps Enabled (on/off)

### 5. "zombie amount is configurable based on settings already in game"

**Requirement**: Use existing game zombie population settings

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.UseSandboxPopulation = true
  ```
- File: `ZombieRemoval.lua`
  - Function: `adjustSandboxSettings()` stores original settings
  - Function: `restoreSandboxSettings()` applies original population values

### 6. "the rate of spawn for the event is doubled for the entire 18 hours"

**Requirement**: 2x spawn rate multiplier during onslaught

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.SpawnRateMultiplier = 2.0
  ```
- File: `SpawnController.lua`
  - Function: `spawnWave()`
  - Formula: `totalZombies = (baseAmount + waveBonus) * multiplier`

**Example Calculation**:
```
Wave 1: 50 × 2.0 = 100 zombies (doubled)
Wave 2: 60 × 2.0 = 120 zombies (doubled)
```

### 7. "every 2 hours more spawn you must cull before they breach"

**Requirement**: Spawn waves every 2 hours during onslaught

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.WaveIntervalHours = 2
  ```
- File: `SpawnController.lua`
  - Function: `processSpawning()` checks time intervals
  - Spawns at: 0h, 2h, 4h, 6h, 8h, 10h, 12h, 14h, 16h (9 waves total)

**Wave Schedule**:
```
Hour 0:  Wave 1 spawns
Hour 2:  Wave 2 spawns
Hour 4:  Wave 3 spawns
Hour 6:  Wave 4 spawns
Hour 8:  Wave 5 spawns
Hour 10: Wave 6 spawns
Hour 12: Wave 7 spawns
Hour 14: Wave 8 spawns
Hour 16: Wave 9 spawns
Hour 18: Onslaught ends
```

### 8. "new trap ssytems will be implemented"

**Requirement**: Implement trap systems

**Implementation**:

#### Snare Traps
- File: `items_onslaught.txt` - Item definition
- File: `recipes_onslaught.txt` - Crafting recipe
- File: `DefensiveStructures.lua` - Snare logic
  - Effect: Slows zombie to 10% speed for 10 seconds

#### Spike Traps
- File: `items_onslaught.txt` - Item definition
- File: `recipes_onslaught.txt` - Crafting recipe
- File: `DefensiveStructures.lua` - Spike logic
  - Effect: Deals 25 HP damage, 10 uses

#### Barbwire Fencing
- File: `items_onslaught.txt` - Item definition
- File: `recipes_onslaught.txt` - Crafting recipe
- File: `DefensiveStructures.lua` - Barbwire logic
  - Effect: 5 HP damage + 50% speed reduction

**Trap System Functions**:
- `placeTrap()` - Add trap to world
- `checkTrapTrigger()` - Detect zombie collision
- `triggerTrap()` - Apply trap effect
- `updateTraps()` - Process all traps

### 9. "new turrets that can be placed"

**Requirement**: Implement placeable turret system

**Implementation**:
- File: `items_onslaught.txt`
  - `Turret` item definition
  - `TurretAmmo` item definition
  - `TurretParts` component definition
- File: `recipes_onslaught.txt`
  - `Craft Auto Turret` recipe
  - `Craft Turret Components` recipe
  - `Craft Turret Ammo` recipe
- File: `DefensiveStructures.lua`
  - Function: `placeTurret()` - Add turret
  - Function: `turretFire()` - Fire at zombies
  - Function: `updateTurrets()` - Process all turrets

**Turret Specifications**:
- Range: 15 tiles
- Damage: 10 HP per shot
- Ammo: 500 rounds per box
- Auto-targeting: Closest zombie

### 10. "it will take alot to get your base safe to stop the onslaught"

**Requirement**: Resource-intensive defensive preparation

**Implementation**:

**Turret Crafting Requirements**:
- Turret Parts (requires 2 metal bars, 3 electronics scrap)
- 2× Electronics
- 4× Electronics Scrap
- 2× Metal Pipe
- 2× Sheet Metal
- 3× Wire
- 4× Small Sheet Metal

**Trap Crafting Requirements**:
- Snare: 2 rope, 3 wire, 2 wood planks, 10 nails
- Spike: Trap components, 3 metal pipes, 2 sheet metal, 20 nails, 3 wood
- Barbwire: Barbwire kit, 2 metal pipes, 4 wood planks, 20 nails

**Resource Gathering Needed**:
- Electronics from stores
- Metal from warehouses
- Wood from logging
- Wire from electrical
- Scrap from demolition

### 11. "time until event from world start configurable to give player a setup phase almost like 7 days style"

**Requirement**: Configurable setup/preparation phase like "7 Days to Die"

**Implementation**:
- File: `InfectionConfig.lua`
  ```lua
  InfectionConfig.SetupPhaseEnabled = true
  InfectionConfig.DaysUntilOnslaught = 7
  ```
- File: `InfectionTimer.lua`
  - Function: `checkOnslaughtTimer()` monitors countdown
  - Warning system at 24h, 6h, 1h before event
- File: `ZombieRemoval.lua`
  - Removes all zombies during setup phase
  - Allows free exploration and building

**Configuration**:
- Sandbox option: "Setup Phase Duration (Days)"
- Range: 1-30 days
- Default: 7 days (matching 7 Days to Die style)

**Setup Phase Features**:
- Zero zombie spawning
- Free exploration
- Resource gathering
- Base building time
- UI countdown timer
- Warning notifications

## Additional Features Implemented

Beyond the core requirements, the implementation includes:

1. **UI System**: Visual countdown timer display
2. **Multiplayer Support**: Synchronized events and spawning
3. **Client-Server Architecture**: Proper networking
4. **Save/Load Persistence**: Game state preservation
5. **Comprehensive Documentation**: 5 documentation files
6. **Localization Support**: English translations
7. **Wave Progression**: Increasing difficulty per wave
8. **Post-Onslaught State**: Clear victory condition

## Testing Verification

Each requirement can be verified through:

1. **18-hour duration**: Check timer in UI and ModData
2. **Stragglers only**: Count zombies after onslaught ends
3. **No respawning**: Monitor zombie count post-event
4. **Configurable settings**: Open sandbox options menu
5. **Population integration**: Verify sandbox zombie count used
6. **Doubled spawn rate**: Compare wave sizes (should be 2x base)
7. **2-hour waves**: Time between wave notifications
8. **Trap systems**: Craft and place traps, observe effects
9. **Turret systems**: Craft and place turrets, watch them fire
10. **Resource requirements**: Check recipe complexity
11. **Setup phase**: Verify 7-day countdown and no zombies

## Conclusion

Every requirement from the problem statement has been implemented with:
- ✅ Complete functionality
- ✅ Configurable parameters
- ✅ Proper game integration
- ✅ Documentation and testing support

The mod is production-ready and fully addresses all specified features.
