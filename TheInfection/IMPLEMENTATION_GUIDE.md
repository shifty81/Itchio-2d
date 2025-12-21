# The Onslaught - Implementation Guide

## System Architecture

This document explains how all the systems in "The Onslaught" mod work together to create the complete gameplay experience.

## Core Systems Overview

### 1. Configuration System (InfectionConfig.lua)

**Purpose**: Central configuration hub for all mod settings

**Key Settings**:
- Setup phase duration (days before onslaught)
- Onslaught duration (default 18 hours)
- Wave interval (default 2 hours)
- Spawn rate multiplier (default 2.0x)
- Defensive structure settings
- Trap and turret parameters

**Location**: `media/lua/shared/InfectionConfig.lua`

### 2. Utility System (InfectionUtils.lua)

**Purpose**: Shared helper functions used across all systems

**Key Functions**:
- `getGlobalModData()`: Access persistent game state
- `getGameTimeHours()`: Get current game time
- `isOnslaughtActive()`: Check if onslaught is currently running
- `isInSetupPhase()`: Check if still in preparation phase
- `formatTime()`: Convert hours to readable format

**Location**: `media/lua/shared/InfectionUtils.lua`

### 3. Server System (InfectionServer.lua)

**Purpose**: Server initialization and client communication

**Responsibilities**:
- Initialize mod on game start
- Set up initial mod data
- Handle client-server communication
- Respond to status requests

**Key Events**:
- `OnGameStart`: Initialize systems
- `OnClientCommand`: Handle requests from clients

**Location**: `media/lua/server/InfectionServer.lua`

### 4. Timer System (InfectionTimer.lua)

**Purpose**: Manage the setup phase countdown and onslaught duration

**Flow**:
```
Game Start → Setup Phase → Warnings → Onslaught → End
```

**Warning System**:
- 24 hours before: "WARNING: The Onslaught begins in 24 hours!"
- 6 hours before: "WARNING: The Onslaught begins in 6 hours!"
- 1 hour before: "WARNING: The Onslaught begins in 1 hour!"
- During onslaught at 2h and 30m remaining

**Key Functions**:
- `checkOnslaughtTimer()`: Monitor countdown
- `triggerOnslaught()`: Start the event
- `checkOnslaughtEnd()`: Monitor onslaught completion
- `endOnslaught()`: Clean up and transition to post-event

**Update Frequency**: Every 10 minutes and every hour

**Location**: `media/lua/server/InfectionTimer.lua`

### 5. Zombie Removal System (ZombieRemoval.lua)

**Purpose**: Remove all zombies during setup phase

**How It Works**:
1. On game start, adjusts sandbox settings to ZombieCount=0
2. Removes any existing zombies from the world
3. Monitors and removes any zombies that spawn
4. Restores settings when onslaught triggers

**Key Functions**:
- `adjustSandboxSettings()`: Set zombie count to 0
- `removeAllZombies()`: Clear existing zombies
- `onZombieUpdate()`: Monitor and remove spawning zombies
- `restoreSandboxSettings()`: Restore normal spawn settings

**Update Frequency**: Every hour + on each zombie update

**Location**: `media/lua/server/ZombieRemoval.lua`

### 6. Spawn Controller System (SpawnController.lua)

**Purpose**: Manage wave-based zombie spawning during onslaught

**Wave Mechanics**:
```
Wave 1: 50 * 2.0 = 100 zombies
Wave 2: 60 * 2.0 = 120 zombies
Wave 3: 70 * 2.0 = 140 zombies
...and so on
```

**Spawn Formula**:
```lua
totalZombies = (BaseZombiesPerWave + (waveNumber - 1) * 10) * SpawnRateMultiplier
```

**Spawn Distribution**:
- Zombies spawn around each online player
- Radius: AttackRadius + random variance
- Even distribution across all players

**Key Functions**:
- `processSpawning()`: Check and trigger waves
- `spawnWave()`: Execute wave spawn
- `spawnAroundPlayer()`: Distribute zombies around player
- `cleanupStragglers()`: Leave only configured amount after onslaught

**Update Frequency**: Every 10 minutes

**Location**: `media/lua/server/SpawnController.lua`

### 7. Defensive Structures System (DefensiveStructures.lua)

**Purpose**: Manage turrets and traps functionality

#### Turret System

**How It Works**:
1. Turrets scan for zombies within range (15 tiles)
2. Target closest zombie
3. Deal damage (default 10 HP per shot)
4. Consume ammo if enabled

**Turret Data Structure**:
```lua
{
    x = number,
    y = number,
    z = number,
    ammo = number,
    active = boolean
}
```

#### Trap System

**Trap Types**:

1. **Snare Trap**:
   - Slows zombie movement to 0.1x
   - Duration: 10 seconds
   - Reusable multiple times

2. **Spike Trap**:
   - Deals 25 damage instantly
   - Limited uses (default 10)
   - Removed when uses exhausted

3. **Barbwire Fencing**:
   - Continuous damage (5 HP)
   - Slows movement by 50%
   - Affects all zombies passing through

**Key Functions**:
- `placeTurret()`: Add turret to world
- `turretFire()`: Execute turret attack
- `placeTrap()`: Add trap to world
- `triggerTrap()`: Execute trap effect
- `updateTurrets()`: Process all turrets
- `updateTraps()`: Check trap triggers

**Update Frequency**: Every 10 minutes

**Location**: `media/lua/server/DefensiveStructures.lua`

### 8. Client System (InfectionClient.lua)

**Purpose**: Client-side logic and server communication

**Responsibilities**:
- Request status updates from server
- Store local state for UI
- Handle server responses

**State Variables**:
- `onslaughtTriggered`: Boolean
- `onslaughtComplete`: Boolean
- `timeUntilOnslaught`: Number (hours)
- `timeRemainingInOnslaught`: Number (hours)
- `currentWave`: Number

**Update Frequency**: Every 10 minutes

**Location**: `media/lua/client/InfectionClient.lua`

### 9. UI System (InfectionUI.lua)

**Purpose**: Display countdown timer and event status

**Display Modes**:

1. **Setup Phase**:
   ```
   ONSLAUGHT IN: 2d 5h 30m
   Prepare your defenses!
   ```

2. **During Onslaught**:
   ```
   ONSLAUGHT: 14h 25m
   Wave: 5
   Hold the line!
   ```

3. **Post-Onslaught**:
   ```
   ONSLAUGHT SURVIVED
   Stragglers remain...
   ```

**Position**: Top-right corner of screen

**Customization**: Can be toggled via `InfectionConfig.ShowUITimer`

**Location**: `media/lua/client/InfectionUI.lua`

### 10. Sandbox Options System (SandboxOptions.lua)

**Purpose**: Load player-configured settings into mod

**Available Options**:
- Setup Phase Duration (1-30 days)
- Onslaught Duration (1-48 hours)
- Wave Interval (1-12 hours)
- Spawn Multiplier (0.5-10.0x)
- Base Zombies Per Wave (10-500)
- Stragglers Amount (0-100)
- Turrets Enabled (boolean)
- Traps Enabled (boolean)

**Loading Process**:
1. Server starts
2. Load sandbox options
3. Override default config values
4. Apply throughout gameplay

**Location**: `media/lua/server/SandboxOptions.lua`

## Game Flow Diagram

```
[Game Start]
     ↓
[Initialize Systems]
     ↓
[Setup Phase - No Zombies]
     ↓
[Countdown Timer Active]
     ↓
[24h Warning] → [6h Warning] → [1h Warning]
     ↓
[Onslaught Triggers]
     ↓
[Wave 1 Spawns] → [2h delay] → [Wave 2 Spawns] → [2h delay] → ...
     ↓                    ↓                    ↓
[Turrets Active]    [Traps Active]    [Player Defense]
     ↓
[18 Hours Elapse]
     ↓
[Onslaught Ends]
     ↓
[Cleanup to Stragglers]
     ↓
[Safe State - No More Spawns]
```

## Data Persistence

**Global Mod Data** (saved in ModData):
```lua
{
    onslaughtTriggered = boolean,
    onslaughtStartTime = number (hours),
    onslaughtComplete = boolean,
    setupPhaseStartTime = number (hours),
    currentWave = number,
    nextWaveTime = number (hours)
}
```

**Persistence Events**:
- Automatically saved by game engine
- Loaded on game start
- Synchronized across clients in multiplayer

## Item and Recipe System

### Items Defined (items_onslaught.txt)

1. **Turret** - Placeable auto-turret
2. **TurretAmmo** - Ammunition for turrets
3. **SnareTrap** - Snare trap item
4. **SpikeTrap** - Spike trap item
5. **BarbwireFencing** - Barbwire fence item
6. **BarbwireKit** - Crafting material
7. **TurretParts** - Crafting component
8. **TrapComponents** - Crafting component

### Recipes Defined (recipes_onslaught.txt)

**Turret Crafting**:
- Turret Parts + Electronics + Metal + Wire → Auto Turret
- Metal Bar + Electronics Scrap → Turret Parts
- Various Ammo + Metal Pipe → Turret Ammo

**Trap Crafting**:
- Rope + Wire + Wood → Snare Trap
- Trap Components + Metal + Nails → Spike Trap
- Metal Bar + Scrap Metal → Trap Components

**Barbwire Crafting**:
- Barbwire Kit + Metal + Wood → Barbwire Fencing
- Wire + Scrap Metal → Barbwire Kit

## Performance Considerations

### Optimization Strategies

1. **Update Frequency**:
   - Critical systems: Every 10 minutes
   - Non-critical: Every hour
   - UI: Renders every frame but uses cached data

2. **Spawn Batching**:
   - All wave zombies spawn in single batch
   - Distributed across multiple players
   - No continuous spawning (only at wave intervals)

3. **Turret Processing**:
   - Only active during onslaught
   - Processes all turrets in batch
   - Limited range checking (15 tiles)

4. **Trap Checking**:
   - Tile-based collision detection
   - Only processes zombies near traps
   - Efficient position matching

## Multiplayer Synchronization

### Server Authority
- Server manages all game state
- Clients request updates periodically
- Timer is server-authoritative

### Client Updates
- Status requests every 10 minutes
- UI updates based on local state
- Instant updates on major events

### Event Broadcasting
- Wave notifications sent to all players
- Onslaught start/end broadcasted
- Warning messages synchronized

## Testing Checklist

### Setup Phase Testing
- [ ] Verify no zombies spawn
- [ ] Confirm countdown timer displays
- [ ] Check warnings appear at correct times
- [ ] Test sandbox option loading

### Onslaught Testing
- [ ] Verify onslaught triggers after countdown
- [ ] Confirm waves spawn every 2 hours
- [ ] Check doubled spawn rates applied
- [ ] Test wave difficulty progression

### Defensive Structures Testing
- [ ] Verify turrets can be placed
- [ ] Confirm turrets fire at zombies
- [ ] Test ammo consumption
- [ ] Check trap triggering
- [ ] Verify trap effects (slow, damage)

### Post-Onslaught Testing
- [ ] Confirm event ends after 18 hours
- [ ] Verify stragglers cleanup
- [ ] Check no further spawning
- [ ] Test UI displays correct state

### Multiplayer Testing
- [ ] Verify timer synchronization
- [ ] Test wave distribution across players
- [ ] Check event notifications broadcast
- [ ] Confirm sandbox settings shared

## Troubleshooting Guide

### Common Issues

**Issue**: Zombies spawning during setup phase
**Solution**: Check ZombieRemoval system is active, verify no conflicting mods

**Issue**: Onslaught not triggering
**Solution**: Check setupPhaseStartTime in ModData, verify timer system is running

**Issue**: Waves not spawning
**Solution**: Verify SpawnController is processing, check nextWaveTime value

**Issue**: Turrets not firing
**Solution**: Confirm onslaught is active, check ammo if required, verify range

**Issue**: UI not showing
**Solution**: Check ShowUITimer config, verify client files loaded

## Extension Points

### Adding New Trap Types
1. Define item in items_onslaught.txt
2. Add recipe in recipes_onslaught.txt
3. Add handler in DefensiveStructures.triggerTrap()
4. Configure parameters in InfectionConfig.lua

### Adding New Wave Patterns
1. Modify SpawnController.spawnWave()
2. Implement custom spawn distribution logic
3. Add configuration options

### Custom Events During Onslaught
1. Create new event handler in InfectionEvents.lua
2. Hook into wave system or timer
3. Add notification system

## Conclusion

This implementation provides a complete, configurable onslaught event system for Project Zomboid. All systems are modular and can be extended or modified as needed. The mod is designed for both single-player and multiplayer gameplay with full synchronization support.
