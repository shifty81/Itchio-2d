# The Onslaught - Enhanced Survival Mod

## Overview

"The Onslaught" is a total conversion mod for Project Zomboid that introduces a dramatic survival event system. Players get a setup phase to prepare, then face an intense 18-hour zombie onslaught with doubled spawn rates and waves every 2 hours. Survive the onslaught with new defensive structures including turrets, traps, barbwire, and spike traps.

## Key Features

### 1. Setup Phase (Configurable)
- **Default: 7 days** to prepare before the onslaught
- No zombie spawning during setup phase
- Free exploration and resource gathering
- Build your base and defenses
- Configurable from 1-30 days via sandbox options

### 2. The Onslaught Event
- **18-hour continuous assault** (configurable 1-48 hours)
- **Doubled spawn rates** throughout the entire event
- **Waves every 2 hours** with increasing difficulty
- Progressive zombie counts: each wave adds more zombies
- Clear warnings before and during the event

### 3. Wave System
- Spawns every 2 hours during the onslaught (configurable 1-12 hours)
- Base of 50 zombies per wave (configurable 10-500)
- Each wave adds +10 additional zombies
- Spawn rate multiplier of 2.0 (configurable 0.5-10.0)
- Zombies spawn around all players simultaneously

### 4. Post-Onslaught
- Event ends after 18 hours
- Only stragglers remain (default: 10 zombies max)
- No further spawning until next event
- Safe to rebuild and recover
- Victory notification

### 5. Defensive Structures

#### Auto Turrets
- Automated defense against zombies
- 15-tile range
- Requires ammunition (500 rounds per box)
- Craftable with electronics and metal
- Can be placed strategically around base

#### Traps
- **Snare Traps**: Slow and immobilize zombies
- **Spike Traps**: Deal heavy damage (25 HP)
- **Barbwire Fencing**: Continuous damage and slowing
- All traps are craftable and placeable

#### Crafting Requirements
- Turrets: Electronics, metal pipes, sheet metal, wire
- Traps: Metal bars, rope, wood, nails
- Barbwire: Wire, scrap metal, wood planks
- Check recipes in-game for detailed requirements

## Configuration Options

All settings are configurable via Sandbox Options:

### Timing Settings
- **Setup Phase Duration**: 1-30 days (default: 7)
- **Onslaught Duration**: 1-48 hours (default: 18)
- **Wave Interval**: 1-12 hours (default: 2)

### Difficulty Settings
- **Spawn Rate Multiplier**: 0.5-10.0x (default: 2.0)
- **Base Zombies Per Wave**: 10-500 (default: 50)
- **Stragglers After Onslaught**: 0-100 (default: 10)

### Feature Toggles
- **Enable Turrets**: On/Off (default: On)
- **Enable Traps**: On/Off (default: On)

## Gameplay Strategy

### Setup Phase Tips
1. **Explore aggressively** - no zombies to worry about
2. **Gather electronics** for turret crafting
3. **Collect metal** for traps and defenses
4. **Build walls** around your base perimeter
5. **Stockpile ammunition** for turrets
6. **Create multiple defense layers** with traps

### During Onslaught
1. **Monitor wave timers** - prepare for each 2-hour wave
2. **Repair defenses** between waves
3. **Maintain turret ammo** - restock regularly
4. **Stay within walls** - extremely dangerous outside
5. **Use traps effectively** - place at chokepoints
6. **Work in teams** in multiplayer

### Base Design Recommendations
- **Layered defenses**: Walls → Barbwire → Traps → Turrets
- **Overlapping turret coverage** for maximum efficiency
- **Trap placement at entry points** and weak spots
- **Multiple fallback positions** if outer walls breach
- **Emergency exits** for desperate situations

## Installation

1. Download the mod
2. Extract to your Project Zomboid mods folder:
   - Windows: `C:\Users\[YourName]\Zomboid\mods\`
   - Linux: `~/.local/share/Zomboid/mods/`
3. Enable the mod in the game's mod menu
4. Configure sandbox options if desired
5. Start a new game (recommended)

## Multiplayer Support

The mod is fully compatible with multiplayer servers:
- Timer synchronized across all clients
- Waves spawn around all connected players
- Shared defensive structures
- Cooperative base building encouraged
- Server admin can adjust all settings

## Compatibility

### Compatible With
- Map mods
- Weapon and item mods
- Building enhancement mods
- UI mods
- QoL (Quality of Life) mods

### Potential Conflicts
- Other zombie spawn override mods
- Mods that heavily modify zombie behavior
- Other "horde event" style mods

## Troubleshooting

### Zombies Spawning During Setup Phase
- Check that mod is properly enabled
- Verify no conflicting zombie mods are active
- Try starting a new save

### Onslaught Not Triggering
- Check sandbox options for timer setting
- Wait for full duration (default 7 days)
- Look for warnings in chat (24h, 6h, 1h before)

### Turrets Not Working
- Verify turrets are enabled in sandbox options
- Ensure turret has ammunition loaded
- Check that zombies are within 15-tile range
- Only works during active onslaught

### UI Timer Not Showing
- Check InfectionConfig.ShowUITimer setting
- Restart the game
- Verify client-side files are installed

## Technical Details

### Mod Structure
```
TheInfection/
├── mod.info (Mod metadata)
├── media/
│   ├── lua/
│   │   ├── client/ (UI and client logic)
│   │   ├── server/ (Game logic and spawning)
│   │   └── shared/ (Configuration and utilities)
│   ├── scripts/ (Item and recipe definitions)
│   └── sandbox-options.txt (Configurable settings)
```

### Key Systems
1. **InfectionTimer**: Manages setup phase countdown and onslaught timing
2. **SpawnController**: Handles wave-based zombie spawning
3. **ZombieRemoval**: Removes zombies during setup phase
4. **DefensiveStructures**: Manages turrets and traps
5. **InfectionUI**: Displays countdown timer to players

## Credits

Created for Project Zomboid Build 41+

Based on the concept of "7 Days to Die" style horde events adapted for Project Zomboid's gameplay.

## Version History

### Version 1.0.0
- Initial release
- 18-hour onslaught event system
- Configurable setup phase (default 7 days)
- Wave spawning every 2 hours
- Doubled spawn rates during onslaught
- Turret system implementation
- Trap system (snares, spikes, barbwire)
- Full sandbox options integration
- Multiplayer support
- Post-onslaught straggler system

## Support

For issues, suggestions, or contributions, please visit the mod's repository or forum thread.

## License

See LICENSE file for details.
