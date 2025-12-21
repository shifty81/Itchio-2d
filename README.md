# The Infection - Project Zomboid Total Conversion Mod

A total conversion mod for Project Zomboid that transforms the zombie survival experience into a timed survival game with a dramatic "Infection Event" mechanic.

## Concept Overview

This mod fundamentally changes the Project Zomboid gameplay loop:

### Before the Infection
- **No zombies** spawn on the map initially
- Players can explore, build, and gather resources freely
- The world is peaceful but tension builds as the Infection Event approaches
- Time to prepare your defenses and fortify your base

### After the Infection Event
- **Everything outside your walls becomes hostile**
- All entities attempt to break through your defenses
- Waves of enemies bash against your barricades and walls
- Survival depends on the quality of your preparations

## Key Features

1. **Zero Initial Zombie Spawning**: Complete removal of zombies until the Infection Event triggers
2. **Timed Event System**: Configurable countdown to the Infection Event
3. **Wall Defense Mechanics**: Entities actively target and attack player-built structures
4. **Base Protection Zones**: Areas within player-defined walls remain safe
5. **Hostile Entity Spawning**: Mass spawn of aggressive entities when the event triggers
6. **Wave-Based Attacks**: Progressive difficulty with enemies attempting to breach defenses

## Documentation

Comprehensive guides are available in the `/docs` folder:

- **[MOD_OVERVIEW.md](docs/MOD_OVERVIEW.md)**: Detailed concept and gameplay mechanics
- **[MODDING_GUIDE.md](docs/MODDING_GUIDE.md)**: Step-by-step guide to creating the mod
- **[TECHNICAL_IMPLEMENTATION.md](docs/TECHNICAL_IMPLEMENTATION.md)**: Implementation details and code examples
- **[MAP_MODDING.md](docs/MAP_MODDING.md)**: Map extraction and custom area creation
- **[RESOURCES.md](docs/RESOURCES.md)**: Links to wikis, documentation, and community resources

See **[docs/README.md](docs/README.md)** for a complete documentation index.

## Quick Start

1. Review the documentation in `/docs` to understand the mod architecture
2. Set up your Project Zomboid modding environment
3. Follow the implementation guide to build core features
4. Test and iterate on the gameplay mechanics

## Implementation Status

✅ **IMPLEMENTED**: The mod has been implemented in the `/TheInfection` directory with all core features:

### Completed Features
- ✅ **18-Hour Onslaught Event System** with configurable duration
- ✅ **Setup Phase** (default 7 days) with no zombie spawning
- ✅ **Wave-Based Spawning** every 2 hours during onslaught
- ✅ **Doubled Spawn Rates** throughout the onslaught event
- ✅ **Defensive Structures**: Turrets, Snare Traps, Spike Traps, Barbwire Fencing
- ✅ **Configurable Settings** via Sandbox Options
- ✅ **Post-Onslaught Cleanup** with straggler system
- ✅ **UI Timer Display** showing countdown and event status
- ✅ **Multiplayer Support** with synchronized timers and events

### Installation
See `/TheInfection/README.md` for detailed installation and gameplay instructions.

## Requirements

- Project Zomboid (Build 41 or 42)
- Basic understanding of Lua scripting
- Familiarity with Project Zomboid's modding API
- Knowledge of the mod folder structure

## Contributing

This mod is in active design. Contributions, suggestions, and improvements are welcome. Please refer to the documentation for implementation details.

## License

[To be determined based on Project Zomboid modding guidelines]
