# The Onslaught - Complete Documentation Index

Welcome to "The Onslaught" mod for Project Zomboid! This index will guide you to the right documentation.

## Quick Links

### 🚀 Getting Started
- **[QUICK_START.md](QUICK_START.md)** - Get playing in 5 minutes
  - Installation instructions
  - First steps guide
  - Survival tips
  - Crafting cheat sheet

### 📖 Main Documentation
- **[README.md](README.md)** - Complete mod overview
  - Feature list
  - Configuration options
  - Gameplay strategy
  - Troubleshooting

### 🔧 Technical Documentation
- **[IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)** - System architecture
  - How all systems work together
  - Data flow diagrams
  - Performance considerations
  - Testing checklist

### 📋 Requirements & Implementation
- **[REQUIREMENT_MAPPING.md](REQUIREMENT_MAPPING.md)** - Problem statement to code
  - Maps each requirement to implementation
  - Verification methods
  - Code locations

- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - What was built
  - Complete feature list
  - File structure
  - Key components

### 📝 Version History
- **[CHANGELOG.md](CHANGELOG.md)** - All changes and updates
  - Version 1.0.0 features
  - Release notes
  - Known limitations
  - Future enhancements

## Documentation by Purpose

### For Players

**Just want to play?**
1. Read [QUICK_START.md](QUICK_START.md) (5 minutes)
2. Install and configure the mod
3. Start surviving!

**Want to master the game?**
1. [QUICK_START.md](QUICK_START.md) - Basics
2. [README.md](README.md) - Strategy section
3. [README.md](README.md) - Configuration tips

**Having problems?**
1. [README.md](README.md) - Troubleshooting section
2. [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Testing checklist

### For Modders

**Want to understand the code?**
1. [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Overview
2. [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Deep dive
3. Source code with inline comments

**Want to modify the mod?**
1. [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Extension points
2. [REQUIREMENT_MAPPING.md](REQUIREMENT_MAPPING.md) - Find specific code
3. InfectionConfig.lua - All settings

**Want to create something similar?**
1. [REQUIREMENT_MAPPING.md](REQUIREMENT_MAPPING.md) - Requirements
2. [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Architecture
3. [CHANGELOG.md](CHANGELOG.md) - Feature list

### For Reviewers

**Verifying implementation?**
1. [REQUIREMENT_MAPPING.md](REQUIREMENT_MAPPING.md) - Requirement checklist
2. [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - What was built
3. [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Testing guide

## File Overview

### Root Files
```
mod.info                    # Mod metadata for Project Zomboid
README.md                   # Main documentation (start here!)
QUICK_START.md              # 5-minute getting started guide
IMPLEMENTATION_GUIDE.md     # Technical architecture and systems
IMPLEMENTATION_SUMMARY.md   # What was built and why
REQUIREMENT_MAPPING.md      # Problem statement to implementation
CHANGELOG.md                # Version history and changes
INDEX.md                    # This file - navigation hub
```

### Code Structure
```
media/lua/
├── client/                 # Client-side only
│   ├── InfectionClient.lua     # Client initialization
│   └── InfectionUI.lua         # Timer display
├── server/                 # Server-side only
│   ├── InfectionServer.lua     # Server initialization
│   ├── InfectionTimer.lua      # Event timer system
│   ├── ZombieRemoval.lua       # Pre-onslaught cleanup
│   ├── SpawnController.lua     # Wave spawning
│   ├── DefensiveStructures.lua # Turrets and traps
│   └── SandboxOptions.lua      # Config loading
└── shared/                 # Both sides
    ├── InfectionConfig.lua     # Configuration values
    ├── InfectionUtils.lua      # Utility functions
    └── Translate/EN/Sandbox_EN.txt  # English text
```

### Game Content
```
media/
├── scripts/
│   ├── items_onslaught.txt     # Item definitions
│   └── recipes_onslaught.txt   # Crafting recipes
└── sandbox-options.txt         # Configuration interface
```

## Key Concepts

### The Three Phases

1. **Setup Phase (Default: 7 days)**
   - No zombies spawn
   - Free exploration and building
   - Countdown timer displays
   - Documentation: All guides cover this

2. **The Onslaught (18 hours)**
   - 9 waves of zombies (every 2 hours)
   - Doubled spawn rates
   - Defensive structures active
   - Documentation: README.md Strategy section

3. **Post-Onslaught (Permanent)**
   - Only stragglers remain
   - No further spawning
   - Safe exploration
   - Documentation: QUICK_START.md

### The Wave System

```
Wave 1 (Hour 0):  100 zombies
Wave 2 (Hour 2):  120 zombies
Wave 3 (Hour 4):  140 zombies
Wave 4 (Hour 6):  160 zombies
Wave 5 (Hour 8):  180 zombies
Wave 6 (Hour 10): 200 zombies
Wave 7 (Hour 12): 220 zombies
Wave 8 (Hour 14): 240 zombies
Wave 9 (Hour 16): 260 zombies
```

### Defensive Structures

1. **Auto Turrets** - Automated defense
2. **Snare Traps** - Slow zombies
3. **Spike Traps** - Heavy damage
4. **Barbwire Fencing** - Continuous damage + slow

See QUICK_START.md for crafting requirements.

## Configuration

All settings are configurable via Sandbox Options:

- Setup Phase Duration (1-30 days)
- Onslaught Duration (1-48 hours)
- Wave Interval (1-12 hours)
- Spawn Multiplier (0.5-10.0x)
- Base Zombies Per Wave (10-500)
- Stragglers Amount (0-100)
- Turrets Enabled (yes/no)
- Traps Enabled (yes/no)

See README.md for detailed configuration guide.

## Common Questions

**Q: Where do I start?**
A: [QUICK_START.md](QUICK_START.md) - 5 minute guide

**Q: How do I configure the mod?**
A: [README.md](README.md) - Configuration section

**Q: How does the code work?**
A: [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Full architecture

**Q: What was implemented?**
A: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Complete list

**Q: Does it meet requirements?**
A: [REQUIREMENT_MAPPING.md](REQUIREMENT_MAPPING.md) - Detailed mapping

**Q: What changed in each version?**
A: [CHANGELOG.md](CHANGELOG.md) - Version history

## Support

For issues or questions:
1. Check the Troubleshooting section in README.md
2. Review the Testing Checklist in IMPLEMENTATION_GUIDE.md
3. Check the problem statement mapping in REQUIREMENT_MAPPING.md
4. Visit the mod's repository or forum thread

## Contributing

Interested in contributing?
1. Read IMPLEMENTATION_GUIDE.md to understand the architecture
2. Check CHANGELOG.md for future enhancement ideas
3. Review the code with inline comments
4. See "Extension Points" in IMPLEMENTATION_GUIDE.md

## License

See LICENSE file for details (to be determined based on Project Zomboid modding guidelines).

---

## Navigation Tips

- **Playing the mod**: Start with QUICK_START.md
- **Understanding features**: Read README.md
- **Modding/extending**: Study IMPLEMENTATION_GUIDE.md
- **Verifying requirements**: Check REQUIREMENT_MAPPING.md
- **Seeing what's new**: Review CHANGELOG.md

Enjoy surviving "The Onslaught"! 🧟‍♂️
