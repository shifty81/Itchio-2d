# Example Mod Structure

This document shows the complete folder structure for "The Infection" mod with file descriptions.

## Complete Directory Structure

```
TheInfection/
├── mod.info                                  # Mod metadata and configuration
├── poster.png                                # 512x512 preview image for mod menu
├── icon.png                                  # 64x64 icon for mod list
│
└── media/
    │
    ├── lua/
    │   │
    │   ├── client/                          # Client-side only code
    │   │   ├── InfectionClient.lua          # Client initialization
    │   │   ├── InfectionUI.lua              # UI timer display
    │   │   ├── InfectionHUD.lua             # HUD overlays (wave counter, status)
    │   │   ├── InfectionSounds.lua          # Client-side sound triggers
    │   │   └── InfectionCommands.lua        # Client console commands
    │   │
    │   ├── server/                          # Server-side only code
    │   │   ├── InfectionServer.lua          # Server initialization
    │   │   ├── InfectionTimer.lua           # Timer management and countdown
    │   │   ├── ZombieRemoval.lua            # Pre-infection zombie removal
    │   │   ├── SpawnController.lua          # Post-infection wave spawning
    │   │   ├── WallAttackAI.lua             # Zombie wall-bashing behavior
    │   │   ├── SafeZoneDetector.lua         # Wall detection and safe zones
    │   │   ├── InfectionEvents.lua          # Event triggers and notifications
    │   │   └── InfectionPersistence.lua     # Save/load system
    │   │
    │   └── shared/                          # Shared between client and server
    │       ├── InfectionConfig.lua          # Configuration values
    │       ├── InfectionUtils.lua           # Utility functions
    │       └── InfectionConstants.lua       # Constant values
    │
    ├── scripts/                             # Item and recipe definitions
    │   ├── items/
    │   │   └── InfectionItems.txt           # Custom items (if needed)
    │   └── recipes/
    │       └── InfectionRecipes.txt         # Custom recipes (if needed)
    │
    ├── textures/                            # Images and textures
    │   ├── ui/
    │   │   ├── timer_background.png         # UI background for timer
    │   │   ├── wave_icon.png                # Wave indicator icon
    │   │   └── warning_icon.png             # Warning notification icon
    │   └── items/
    │       └── (custom item textures)
    │
    └── sounds/                              # Audio files (optional)
        ├── infection_alarm.ogg              # Infection event alarm sound
        ├── wave_incoming.ogg                # Wave start sound
        └── wall_breach.ogg                  # Wall damaged alert sound
```

## File Descriptions

### Root Files

**mod.info**
- Metadata file containing mod name, ID, description, version
- Required for the game to recognize the mod
- Example content:
  ```ini
  name=The Infection
  id=TheInfection
  description=Survive the calm before the storm, then defend your walls!
  poster=poster.png
  icon=icon.png
  modversion=1.0.0
  pzversion=41.78
  ```

**poster.png**
- 512x512 PNG image
- Displayed in mod menu and Steam Workshop
- Should be eye-catching and represent the mod

**icon.png**
- 64x64 PNG image
- Small icon shown in mod list
- Simplified version of poster

### Client-Side Lua Files

**InfectionClient.lua**
- Entry point for client-side code
- Initializes UI, sound systems
- Sets up client event listeners
- Manages local player state

**InfectionUI.lua**
- Creates and manages countdown timer UI
- Renders timer overlay on screen
- Updates display based on server data
- Handles UI positioning and styling

**InfectionHUD.lua**
- Additional HUD elements
- Wave counter display
- Status indicators (safe zone, under attack)
- Visual warnings and alerts

**InfectionSounds.lua**
- Plays sound effects client-side
- Infection event alarm
- Wave incoming sounds
- Wall breach alerts

**InfectionCommands.lua**
- Debug commands for testing
- Admin commands for control
- Examples: /infection trigger, /infection status

### Server-Side Lua Files

**InfectionServer.lua**
- Entry point for server-side code
- Initializes all server systems
- Handles client-server communication
- Manages global game state

**InfectionTimer.lua**
- Core timer system
- Tracks game time until infection
- Sends warning notifications
- Triggers infection event at countdown end

**ZombieRemoval.lua**
- Removes all zombies during pre-infection phase
- Monitors and deletes any spawning zombies
- Adjusts sandbox settings
- Restores settings after infection

**SpawnController.lua**
- Manages post-infection zombie spawning
- Controls wave timing and size
- Handles spawn locations around players
- Avoids spawning in safe zones
- Creates variety in zombie types

**WallAttackAI.lua**
- Modifies zombie behavior to target walls
- Detects player-built structures
- Makes zombies attack barricades and walls
- Applies damage to structures
- Creates attack patterns

**SafeZoneDetector.lua**
- Detects areas enclosed by walls
- Implements flood-fill or ray-casting algorithm
- Maintains list of safe zones
- Prevents spawning inside safe areas
- Updates zones when walls change

**InfectionEvents.lua**
- Handles special events
- Helicopter flyovers
- Radio broadcasts
- Environmental changes (weather, etc.)
- Boss zombie spawns

**InfectionPersistence.lua**
- Manages save/load functionality
- Stores mod state in ModData
- Persists timer, wave progress, player stats
- Restores state on load

### Shared Lua Files

**InfectionConfig.lua**
- Central configuration file
- All adjustable settings
- Default values for gameplay parameters
- Sandbox option integration

**InfectionUtils.lua**
- Utility functions used by both client and server
- Logging functions
- Data access helpers
- Common calculations
- Validation functions

**InfectionConstants.lua**
- Constant values
- Zombie type definitions
- Wave configurations
- Message strings
- Enumeration values

### Script Files

**InfectionItems.txt** (if custom items needed)
```
module TheInfection
{
    item InfectionDetector
    {
        DisplayName = Infection Detector,
        Icon = InfectionDetector,
        Type = Normal,
        Weight = 0.5,
    }
}
```

**InfectionRecipes.txt** (if custom recipes needed)
```
module TheInfection
{
    recipe Craft Detector
    {
        Electronics,
        ElectronicsScrap=2,
        
        Result:InfectionDetector,
        Time:100.0,
        Category:Electrical,
    }
}
```

### Texture Files

All textures should be PNG format with alpha channel support.

**UI Textures** (in textures/ui/):
- timer_background.png - Semi-transparent background for timer
- wave_icon.png - Icon indicating wave number
- warning_icon.png - Flashing warning indicator

**Item Textures** (in textures/items/):
- Custom item icons if adding special items
- Should match Project Zomboid's art style

### Sound Files

Audio files in OGG or WAV format.

**infection_alarm.ogg**
- Plays when infection event triggers
- Loud, alarming sound
- Duration: 3-5 seconds

**wave_incoming.ogg**
- Plays at start of each wave
- Tension-building sound
- Duration: 2-3 seconds

**wall_breach.ogg**
- Plays when walls are heavily damaged
- Alert sound
- Duration: 1-2 seconds

## File Size Guidelines

### Textures
- UI elements: Keep under 200KB each
- Item textures: 64x64 or 128x128, under 50KB
- Total texture folder: Aim for under 5MB

### Sounds
- Individual sounds: 100KB - 500KB
- Total sound folder: Under 2MB
- Use OGG format for compression

### Code
- Individual Lua files: Keep modular, under 500 lines ideally
- Total code size: Usually negligible (tens of KB)

## Load Order

Files are loaded in this order:

1. **shared/** files load first (both client and server)
2. **server/** files load on server
3. **client/** files load on client
4. Within each folder, alphabetical order

To control load order, use require statements:

```lua
-- In InfectionServer.lua
require "InfectionConfig"      -- Load config first
require "InfectionUtils"       -- Then utils
require "InfectionTimer"       -- Then specific systems
```

## Optional Folders

### media/models_x/
For custom 3D models (advanced)

### media/ui/
Alternative location for UI files

### media/radio/
Custom radio broadcasts

### media/newspaper/
Custom newspaper/TV text

## Development Workflow

### Recommended Setup

1. **Development Location**:
   ```
   C:\Users\[YourName]\Zomboid\mods\TheInfection\
   ```

2. **Version Control**:
   Initialize git repository in mod folder
   ```
   git init
   git add .
   git commit -m "Initial commit"
   ```

3. **Testing Process**:
   - Edit files in mods folder
   - Launch game, enable mod
   - Test changes
   - Check console for errors
   - Iterate

4. **Publishing**:
   - Copy to Workshop folder
   - Use in-game uploader
   - Update Workshop page

## Minimal Working Example

For a minimal working mod, you only need:

```
TheInfection/
├── mod.info
└── media/
    └── lua/
        └── shared/
            └── InfectionMain.lua (all code in one file)
```

But proper organization as shown above is recommended for:
- Maintainability
- Collaboration
- Debugging
- Future expansion

## Conclusion

This structure provides clear organization and separation of concerns. Follow this layout for "The Infection" mod to keep code manageable and professional.
