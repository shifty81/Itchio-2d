# GameData Directory Structure

This directory contains all runtime game data organized by game type.

## Structure

```
GameData/
├── GameTypeA/                  # First game type
│   ├── Systems/                # Game-specific DLL systems
│   │   ├── RenderingSystem.dll
│   │   ├── PhysicsSystem.dll
│   │   └── AISystem.dll
│   └── Assets/                 # Game-specific assets
│       ├── Sprites/
│       ├── Tilesets/
│       ├── Sounds/
│       └── Config/
│           └── game_config.json
│
├── GameTypeB/                  # Second game type
│   ├── Systems/                # Different system configuration
│   │   ├── RenderingSystem.dll
│   │   └── AISystem.dll
│   └── Assets/
│       └── Config/
│           └── game_config.json
│
└── Library/                    # Shared asset library
    ├── CommonSprites/          # Reusable sprites
    ├── SciFiTiles/             # Sci-fi themed tilesets
    └── FantasyTiles/           # Fantasy themed tilesets
```

## Game Types

Each game type is a self-contained configuration with:
- **Systems**: The DLL modules that define gameplay behavior
- **Assets**: Game-specific resources
- **Config**: JSON configuration file

### Creating a New Game Type

1. Create directory: `GameData/MyGameType/`
2. Create subdirectories:
   ```
   mkdir -p GameData/MyGameType/Systems
   mkdir -p GameData/MyGameType/Assets/{Sprites,Sounds,Config}
   ```
3. Create config file: `GameData/MyGameType/Assets/Config/game_config.json`
4. Copy or build required system DLLs to `Systems/`
5. Add assets to appropriate folders
6. Update engine config to load new game type

### Example Config (game_config.json)

```json
{
  "gameType": "MyGameType",
  "version": "1.0.0",
  "description": "My custom game",
  "systems": [
    "RenderingSystem.dll",
    "PhysicsSystem.dll",
    "MyCustomSystem.dll"
  ],
  "assets": {
    "sprites": [
      "player.png",
      "enemy.png"
    ],
    "sounds": [
      "music.ogg"
    ]
  },
  "gameRules": {
    "playerSpeed": 10.0,
    "maxEnemies": 50
  }
}
```

## Library

The Library directory contains shared assets that can be referenced by multiple game types. This promotes asset reuse and reduces duplication.

### Using Library Assets

Reference library assets in your game config or code:
```
../Library/CommonSprites/button.png
../Library/SciFiTiles/tech_wall.png
```

### Asset Organization

Organize library assets by theme or category:
- **CommonSprites/**: UI elements, common characters
- **SciFiTiles/**: Science fiction themed tiles
- **FantasyTiles/**: Fantasy themed tiles
- **SoundEffects/**: Reusable sound effects
- **Music/**: Background music tracks

## Hot-Swapping Systems

Systems can be changed without recompiling the engine:

1. Build new system DLL
2. Copy to `GameData/[GameType]/Systems/`
3. Update game_config.json
4. Restart engine or trigger reload

## Asset Loading

Assets are loaded based on the config file:
```cpp
assetManager.LoadAssetsFromConfig("GameData/GameTypeA/Assets/Config/game_config.json");
```

## Best Practices

1. **Naming**: Use descriptive names for game types
2. **Organization**: Keep assets organized by type
3. **Reuse**: Leverage Library for shared assets
4. **Versioning**: Track config file versions
5. **Documentation**: Document game rules in config files

## Directory Permissions

Ensure the engine has read access to:
- `Systems/*.dll` - System modules
- `Assets/**/*` - All asset files
- `Config/*.json` - Configuration files

## Troubleshooting

### System DLL Not Found
- Check DLL is in correct Systems directory
- Verify path in game_config.json
- Ensure DLL is built for correct platform

### Asset Not Loading
- Verify file exists in Assets directory
- Check file path in config
- Ensure correct asset type specified

### Config Parse Error
- Validate JSON syntax
- Check for missing commas or quotes
- Use a JSON validator tool

## Advanced Usage

### Asset Packs

Create reusable asset packs:
```json
{
  "pack": "SciFiBundle",
  "includes": [
    "../Library/SciFiTiles/*",
    "../Library/SciFiSprites/*"
  ]
}
```

### System Dependencies

Specify system load order in config:
```json
{
  "systems": [
    {"name": "RenderingSystem.dll", "priority": 1},
    {"name": "PhysicsSystem.dll", "priority": 2}
  ]
}
```

### Asset Streaming

For large assets, consider lazy loading:
```json
{
  "assets": {
    "largeTextures": {
      "loadOnDemand": true,
      "files": ["bigmap.png"]
    }
  }
}
```

## See Also

- [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - Overall architecture
- [SYSTEM_DESIGN.md](../docs/SYSTEM_DESIGN.md) - System design patterns
- [QUICK_REFERENCE.md](../docs/QUICK_REFERENCE.md) - Quick reference guide
