# Changelog

All notable changes to "The Onslaught" mod will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-21

### Added

#### Core Event System
- Setup phase system with configurable duration (default 7 days)
- 18-hour onslaught event with configurable duration
- Wave-based spawning every 2 hours (configurable interval)
- Doubled spawn rates during onslaught (configurable multiplier)
- Post-onslaught straggler system with configurable amount

#### Timer System
- Countdown timer during setup phase
- Warning system at 24h, 6h, and 1h before onslaught
- Onslaught duration tracking
- Post-onslaught completion state

#### Zombie Management
- Complete zombie removal during setup phase
- Sandbox settings adjustment and restoration
- Wave spawning with progressive difficulty
- Each wave increases zombie count by base amount + 10

#### Defensive Structures
- Auto Turret system
  - 15-tile range
  - Configurable damage (default 10 HP)
  - Ammunition system (500 rounds per box)
  - Automatic targeting of closest zombie
- Snare Trap system
  - Slows zombies to 10% speed
  - 10-second duration
  - Reusable
- Spike Trap system
  - 25 HP damage per trigger
  - Limited uses (10 triggers)
  - Auto-removes when exhausted
- Barbwire Fencing system
  - Continuous 5 HP damage
  - 50% movement speed reduction
  - Affects all passing zombies

#### Crafting System
- Turret crafting recipes
  - Craft Auto Turret (requires turret parts, electronics, metal)
  - Craft Turret Components (metal bar, electronics scrap)
  - Craft Turret Ammo (bullets, metal pipe)
- Trap crafting recipes
  - Craft Snare Trap (rope, wire, wood)
  - Craft Spike Trap (trap components, metal, nails)
  - Craft Trap Components (metal bar, scrap metal)
- Barbwire crafting recipes
  - Craft Barbwire Fencing (barbwire kit, metal, wood)
  - Craft Barbwire Kit (wire, scrap metal)

#### Configuration System
- Comprehensive sandbox options for all settings
- Setup Phase Duration: 1-30 days
- Onslaught Duration: 1-48 hours
- Wave Interval: 1-12 hours
- Spawn Rate Multiplier: 0.5-10.0x
- Base Zombies Per Wave: 10-500
- Stragglers Amount: 0-100
- Toggle turrets on/off
- Toggle traps on/off

#### User Interface
- Top-right countdown timer display
- Setup phase timer with "Prepare your defenses!" message
- Active onslaught timer with wave counter
- Post-onslaught completion message
- Configurable visibility

#### Multiplayer Support
- Server-authoritative game state
- Client-server synchronization every 10 minutes
- Event broadcasting to all connected players
- Wave spawning distributed across all players
- Shared defensive structures

#### Documentation
- Comprehensive README with installation and gameplay guide
- Implementation guide with system architecture details
- Sandbox options with tooltips
- Recipe documentation

### Technical Implementation

#### Lua Modules Created
- `InfectionConfig.lua` - Central configuration system
- `InfectionUtils.lua` - Shared utility functions
- `InfectionServer.lua` - Server initialization and communication
- `InfectionClient.lua` - Client logic and state management
- `InfectionTimer.lua` - Timer and event management
- `ZombieRemoval.lua` - Pre-onslaught zombie removal
- `SpawnController.lua` - Wave-based spawning system
- `DefensiveStructures.lua` - Turret and trap management
- `InfectionUI.lua` - Client-side UI display
- `SandboxOptions.lua` - Configuration loading

#### Scripts Created
- `items_onslaught.txt` - Item definitions for all defensive structures
- `recipes_onslaught.txt` - Crafting recipes for all items
- `sandbox-options.txt` - Sandbox option definitions
- `Sandbox_EN.txt` - English translations for options

#### Event Hooks Used
- `OnGameStart` - System initialization
- `OnServerStarted` - Load sandbox options
- `OnClientCommand` - Handle client requests
- `OnServerCommand` - Handle server responses
- `OnZombieUpdate` - Monitor zombie spawning
- `EveryTenMinutes` - Regular updates
- `EveryHours` - Periodic checks

#### Data Persistence
- ModData system for global state
- Persistent across save/load cycles
- Synchronized in multiplayer

### Performance Optimizations
- Batch zombie spawning at wave intervals
- Limited update frequency (10 minutes for most systems)
- Efficient turret range checking
- Tile-based trap collision detection
- Cached client state for UI

### Known Limitations
- Turrets require manual reloading of ammo
- Traps have limited uses (spike traps)
- UI position fixed to top-right corner
- No visual models for turrets/traps (system-level implementation)

### Future Enhancement Ideas
- Visual models for defensive structures
- Additional trap types (fire, explosive)
- Turret upgrade system
- Multiple onslaught events
- Custom zombie types during onslaught
- Wall breach detection and alerts
- Repair mechanics for damaged structures
- Resource cost for maintaining defenses

## Release Notes

This is the initial release implementing the complete onslaught event system as specified. The mod transforms Project Zomboid into a "7 Days to Die" style survival experience with:

1. **Preparation Phase**: Gather resources and build defenses
2. **The Onslaught**: Survive 18 hours of intense zombie waves
3. **Victory**: Clear out stragglers and enjoy safety

All core mechanics are functional and configurable. The mod is ready for testing and gameplay.

## Installation

1. Extract the `TheInfection` folder to your Project Zomboid mods directory
2. Enable the mod in the game's mod menu
3. Configure sandbox options as desired
4. Start a new game (recommended for first playthrough)

## Compatibility

- Project Zomboid Build 41.78+
- Compatible with most item and building mods
- May conflict with other zombie spawn override mods
- Multiplayer compatible with synchronized events

## Credits

Inspired by "7 Days to Die" horde mechanics and adapted for Project Zomboid's gameplay loop.

## License

[To be determined based on Project Zomboid modding guidelines]
