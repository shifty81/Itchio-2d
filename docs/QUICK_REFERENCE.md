# Itchio 2D Engine - Quick Reference

## Project Overview

Modular, data-driven 2D game engine with hot-swappable systems and multi-API graphics support.

## Core Concepts

### Systems
Game logic modules loaded as DLLs at runtime. Each system implements:
- `Initialize()` - Setup
- `Update(deltaTime)` - Per-frame logic
- `Shutdown()` - Cleanup
- `GetName()` - System identifier

### Game Types
Different configurations that load different systems and assets:
- **GameTypeA**: RenderingSystem + PhysicsSystem
- **GameTypeB**: RenderingSystem + AISystem
- Defined by JSON config files

### Graphics Abstraction Layer (GAL)
Unified interface supporting:
- DirectX 11 (stub)
- DirectX 12 (stub)
- OpenGL (stub)

## Quick Commands

### Build
```bash
mkdir build && cd build
cmake ..
cmake --build .
```

### Run
```bash
./bin/Itchio2DEngine      # Main engine
./bin/TestSystemManager   # System tests
./bin/GameTypeSwitcherDemo # Demo
```

### Clean Build
```bash
rm -rf build/
mkdir build && cd build
cmake .. && cmake --build .
```

## Key Files

| File | Purpose |
|------|---------|
| `src/Core/Engine.h/cpp` | Main engine class |
| `src/Core/SystemManager.h/cpp` | DLL loading & system management |
| `src/Core/ISystem.h` | System interface |
| `src/Core/GraphicsAbstractionLayer.h/cpp` | Graphics API abstraction |
| `src/Core/AssetManager.h/cpp` | Asset loading |
| `src/Systems/*.cpp` | Example systems (as DLLs) |
| `config/*.json` | Game type configurations |

## Configuration

### Engine Config (Main.cpp)
```cpp
EngineConfig config;
config.windowTitle = "My Game";
config.windowWidth = 1280;
config.windowHeight = 720;
config.graphicsAPI = GraphicsAPI::OpenGL;
config.gameDataPath = "GameData";
config.gameType = "GameTypeA";
```

### Game Type Config (JSON)
```json
{
  "gameType": "MyGame",
  "systems": ["RenderingSystem.dll", "MySystem.dll"],
  "assets": {
    "sprites": ["player.png"]
  },
  "gameRules": {
    "speed": 5.0
  }
}
```

## Creating a New System

### 1. Create System File
```cpp
// src/Systems/MySystem.cpp
#include "../Core/ISystem.h"

class MySystem : public Itchio2D::ISystem {
    bool Initialize() override { return true; }
    void Update(float dt) override { /* logic */ }
    void Shutdown() override { }
    const char* GetName() const override { return "MySystem"; }
};

extern "C" {
    __declspec(dllexport) Itchio2D::ISystem* CreateSystem() {
        return new MySystem();
    }
    __declspec(dllexport) void DestroySystem(Itchio2D::ISystem* s) {
        delete s;
    }
}
```

### 2. Add to CMake
```cmake
# src/Systems/CMakeLists.txt
add_library(MySystem SHARED MySystem.cpp)
target_include_directories(MySystem PRIVATE ${CMAKE_SOURCE_DIR}/src)
set_target_properties(MySystem PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems
)
```

### 3. Reference in Config
```json
{
  "systems": ["MySystem.dll"]
}
```

## Common Patterns

### Loading Systems Dynamically
```cpp
SystemManager manager;
manager.LoadSystem("GameData/GameTypeA/Systems/MySystem.dll");
manager.InitializeAll();
manager.UpdateAll(0.016f);
manager.ShutdownAll();
```

### Loading Assets
```cpp
AssetManager assets;
assets.SetAssetDirectory("GameData/GameTypeA/Assets");
assets.LoadAsset("player", "sprites/player.png", AssetType::Texture);
Asset* playerSprite = assets.GetAsset("player");
```

### Switching Game Types
```cpp
engine.Shutdown();
config.gameType = "GameTypeB";
engine.Initialize(config);
engine.Run();
```

## Architecture Principles

1. **Modularity**: Systems are independent, hot-swappable DLLs
2. **Data-Driven**: Behavior controlled by JSON configs
3. **Abstraction**: Graphics API hidden behind GAL
4. **Flexibility**: Easy to switch systems and game types

## Directory Layout

```
Itchio-2d/
├── src/
│   ├── Core/          # Engine core
│   ├── Systems/       # Game systems (DLLs)
│   └── Modules/       # Additional modules
├── config/            # Game type configs
├── docs/              # Documentation
└── GameData/          # Runtime (auto-generated)
    ├── GameTypeA/
    ├── GameTypeB/
    └── Library/
```

## System Lifecycle

```
Load DLL → CreateSystem() → Initialize() → Update() [loop] → Shutdown() → DestroySystem() → Unload DLL
```

## Testing

### Unit Test Template
```cpp
#include "SystemManager.h"
#include <cassert>

int main() {
    SystemManager mgr;
    assert(mgr.LoadSystem("path/to/System.dll"));
    assert(mgr.InitializeAll());
    mgr.UpdateAll(0.016f);
    mgr.ShutdownAll();
    return 0;
}
```

## Performance Tips

1. Minimize allocations in `Update()`
2. Use data-oriented design for systems
3. Profile with platform tools (Visual Studio Profiler, etc.)
4. Build in Release mode for benchmarking
5. Consider system update order

## Debugging

### System Loading Issues
- Check DLL is in correct directory
- Verify export functions exist
- Use Dependency Walker (Windows) to check dependencies

### Crashes in System Code
- Use debugger with symbol files
- Check system initialization order
- Verify system state before Update()

### Memory Leaks
- Ensure Shutdown() is called
- Check DestroySystem() is called
- Use memory profilers (valgrind, Visual Studio)

## Next Steps

- [ ] Implement full DirectX/OpenGL rendering
- [ ] Add Dear ImGui integration
- [ ] Implement stb_image for texture loading
- [ ] Add input system
- [ ] Create audio system
- [ ] Implement serialization
- [ ] Add level editor
- [ ] Support asset hot-reloading

## Resources

- **Architecture**: [docs/ARCHITECTURE.md](ARCHITECTURE.md)
- **System Design**: [docs/SYSTEM_DESIGN.md](SYSTEM_DESIGN.md)
- **Windows Build**: [docs/BUILDING_WINDOWS.md](BUILDING_WINDOWS.md)
- **Main README**: [README.md](../README.md)

## Support

For issues, questions, or contributions, please refer to the repository's issue tracker.
