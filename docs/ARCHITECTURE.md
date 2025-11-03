# Itchio 2D - Modular Game Engine

## Architecture Overview

This project implements a modular, data-driven architecture for a native Windows application (with cross-platform considerations). The engine is designed to support hot-swappable game systems and multiple graphics APIs.

## Key Features

### 1. Core Application Framework
- **Language**: C++17
- **Windowing**: Native Windows API (Win32)
- **Graphics**: Abstraction layer supporting DirectX 11, DirectX 12, and OpenGL

### 2. Modular Architecture
- **Entity Component System (ECS)**: Interchangeable game functionality
- **Hot-swappable DLLs**: Game systems implemented as dynamic libraries
- **Data-Driven Design**: External configuration files (JSON) control behavior

### 3. Graphics Abstraction Layer (GAL)
The GAL provides a unified interface to multiple rendering APIs:
- DirectX 11 (stub implementation)
- DirectX 12 (stub implementation)
- OpenGL (stub implementation)

### 4. System Management
- Dynamic loading/unloading of game systems
- Standardized interface: `Initialize()`, `Update()`, `Shutdown()`
- Automatic initialization and update ordering

### 5. Asset Management
- Centralized asset loading and management
- Support for various asset types (textures, sounds, configs)
- Configuration-driven asset loading

## Directory Structure

```
Itchio-2d/
├── CMakeLists.txt           # Root CMake configuration
├── README.md                # This file
├── src/
│   ├── Core/                # Core engine components
│   │   ├── Engine.h/cpp     # Main engine class
│   │   ├── SystemManager.h/cpp  # DLL loading and system management
│   │   ├── AssetManager.h/cpp   # Asset loading and management
│   │   ├── GraphicsAbstractionLayer.h/cpp  # Graphics API abstraction
│   │   ├── ISystem.h        # System interface
│   │   └── Main.cpp         # Application entry point
│   ├── Systems/             # Example game systems (DLLs)
│   │   ├── RenderingSystem.cpp
│   │   ├── PhysicsSystem.cpp
│   │   └── AISystem.cpp
│   └── Modules/             # Additional modules (ImGui, etc.)
├── config/                  # Game type configurations
│   ├── GameTypeA.json
│   └── GameTypeB.json
└── GameData/                # Runtime game data (created during build)
    ├── GameTypeA/
    │   ├── Systems/         # Game-specific DLLs
    │   └── Assets/
    │       ├── Sprites/
    │       ├── Tilesets/
    │       ├── Sounds/
    │       └── Config/
    ├── GameTypeB/
    │   ├── Systems/
    │   └── Assets/
    └── Library/             # Shared asset library
        ├── CommonSprites/
        ├── SciFiTiles/
        └── FantasyTiles/
```

## Building

### Prerequisites
- CMake 3.15 or higher
- C++17 compatible compiler (MSVC 2017+ on Windows)
- Windows SDK (for Win32 API)

### Build Instructions

```bash
# Create build directory
mkdir build
cd build

# Configure
cmake ..

# Build
cmake --build . --config Release

# Run
./bin/Itchio2DEngine.exe
```

## Usage

### Switching Graphics API

In `Main.cpp`, modify the engine configuration:

```cpp
EngineConfig config;
config.graphicsAPI = GraphicsAPI::DirectX11;  // or DirectX12, OpenGL
```

### Switching Game Type

Change the game type in the configuration:

```cpp
config.gameType = "GameTypeA";  // or "GameTypeB"
```

### Creating Custom Systems

1. Create a new C++ file implementing `ISystem` interface
2. Export `CreateSystem()` and `DestroySystem()` functions
3. Build as a shared library (DLL)
4. Place in the appropriate `GameData/[GameType]/Systems/` directory
5. Reference in the game type's JSON configuration

Example:

```cpp
#include "Core/ISystem.h"

class MyCustomSystem : public ISystem {
    bool Initialize() override { /* ... */ }
    void Update(float deltaTime) override { /* ... */ }
    void Shutdown() override { /* ... */ }
    const char* GetName() const override { return "MyCustomSystem"; }
};

extern "C" {
    __declspec(dllexport) ISystem* CreateSystem() {
        return new MyCustomSystem();
    }
    
    __declspec(dllexport) void DestroySystem(ISystem* system) {
        delete system;
    }
}
```

### Configuration Files

Game configurations are stored as JSON in the `config/` directory. These define:
- Which systems to load
- Asset lists
- Game-specific rules and parameters

Example (`GameTypeA.json`):

```json
{
  "gameType": "GameTypeA",
  "systems": ["RenderingSystem.dll", "PhysicsSystem.dll"],
  "assets": {
    "sprites": ["player.png", "enemy.png"]
  },
  "gameRules": {
    "playerSpeed": 5.0
  }
}
```

## Architecture Details

### System Interface

All game systems must implement the `ISystem` interface:

```cpp
class ISystem {
    virtual bool Initialize() = 0;
    virtual void Update(float deltaTime) = 0;
    virtual void Shutdown() = 0;
    virtual const char* GetName() const = 0;
};
```

### System Lifecycle

1. **Load**: DLL is loaded via `SystemManager::LoadSystem()`
2. **Initialize**: `Initialize()` is called on all systems
3. **Update**: `Update(deltaTime)` is called each frame
4. **Shutdown**: `Shutdown()` is called before unloading
5. **Unload**: DLL is unloaded from memory

### Hot-Swapping Systems

Systems can be swapped at runtime:

```cpp
systemManager.UnloadSystem("PhysicsSystem");
systemManager.LoadSystem("GameData/GameTypeB/Systems/AISystem.dll");
systemManager.InitializeAll();
```

## Future Enhancements

### Planned Features
- [ ] Dear ImGui integration for in-game UI
- [ ] Asset browser and selector
- [ ] Full DirectX 11/12 implementation
- [ ] Full OpenGL implementation
- [ ] stb_image integration for texture loading
- [ ] Audio system with sound library integration
- [ ] Complete ECS implementation
- [ ] Serialization system
- [ ] Resource hot-reloading
- [ ] Level editor
- [ ] Scripting support (Lua/Python)

### Helper Libraries to Integrate
- **SDL2** or **GLFW**: Enhanced window/input management
- **Dear ImGui**: UI and debugging tools
- **Assimp**: 3D model loading
- **stb_image**: Image file loading
- **OpenAL** or **FMOD**: Audio playback

## License

[Add license information here]

## Contributing

[Add contribution guidelines here]
