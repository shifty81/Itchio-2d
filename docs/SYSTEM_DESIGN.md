# System Design and Implementation Guide

## Core Components

### 1. Engine (Engine.h/cpp)

The main engine class that orchestrates all subsystems:

- **Window Management**: Creates and manages the application window
- **Main Loop**: Processes events, updates systems, and renders
- **Lifecycle Management**: Initializes, runs, and shuts down all components

Key Methods:
- `Initialize(config)`: Sets up the engine with specified configuration
- `Run()`: Starts the main game loop
- `Shutdown()`: Cleans up all resources

### 2. System Manager (SystemManager.h/cpp)

Manages loading, initialization, and updating of game systems:

- **Dynamic Loading**: Loads systems from DLL files at runtime
- **Lifecycle Control**: Manages initialization, update, and shutdown
- **System Registry**: Maintains a list of loaded systems

Key Methods:
- `LoadSystem(dllPath)`: Loads a system from a DLL
- `UnloadSystem(name)`: Unloads a specific system
- `InitializeAll()`: Initializes all loaded systems
- `UpdateAll(deltaTime)`: Updates all systems each frame

### 3. Graphics Abstraction Layer (GraphicsAbstractionLayer.h/cpp)

Provides a unified interface to multiple graphics APIs:

- **API Abstraction**: Common interface for DirectX 11, 12, and OpenGL
- **Context Management**: Creates and manages rendering contexts
- **Rendering Commands**: Generic rendering operations

Supported APIs:
- DirectX 11 (stub)
- DirectX 12 (stub)
- OpenGL (stub)

### 4. Asset Manager (AssetManager.h/cpp)

Centralized asset loading and management:

- **Asset Loading**: Loads textures, sounds, and other resources
- **Asset Registry**: Maintains loaded assets in memory
- **Configuration**: Supports JSON-based asset configuration

Supported Asset Types:
- Textures
- Sounds
- Configuration files
- Custom asset types (extensible)

## Creating a New Game System

### Step 1: Define Your System

Create a new C++ file (e.g., `InventorySystem.cpp`):

```cpp
#include "../Core/ISystem.h"
#include <iostream>

class InventorySystem : public Itchio2D::ISystem {
private:
    // Your system data
    
public:
    bool Initialize() override {
        std::cout << "[InventorySystem] Initialized" << std::endl;
        // Initialize your system
        return true;
    }
    
    void Update(float deltaTime) override {
        // Update logic called each frame
    }
    
    void Shutdown() override {
        std::cout << "[InventorySystem] Shutdown" << std::endl;
        // Cleanup
    }
    
    const char* GetName() const override {
        return "InventorySystem";
    }
};
```

### Step 2: Export the System

Add export functions:

```cpp
extern "C" {
    #ifdef PLATFORM_WINDOWS
        __declspec(dllexport) Itchio2D::ISystem* CreateSystem() {
            return new InventorySystem();
        }
        
        __declspec(dllexport) void DestroySystem(Itchio2D::ISystem* system) {
            delete system;
        }
    #else
        Itchio2D::ISystem* CreateSystem() {
            return new InventorySystem();
        }
        
        void DestroySystem(Itchio2D::ISystem* system) {
            delete system;
        }
    #endif
}
```

### Step 3: Build as DLL

Add to `src/Systems/CMakeLists.txt`:

```cmake
add_library(InventorySystem SHARED InventorySystem.cpp)
target_include_directories(InventorySystem PRIVATE ${CMAKE_SOURCE_DIR}/src)

set_target_properties(InventorySystem PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems
)
```

### Step 4: Configure Game Type

Add to your game configuration JSON:

```json
{
  "systems": [
    "RenderingSystem.dll",
    "InventorySystem.dll"
  ]
}
```

## Adding a New Graphics API

### Step 1: Implement IGraphicsContext

```cpp
class MyAPIContext : public IGraphicsContext {
public:
    bool Initialize(void* windowHandle) override {
        // Initialize your API
        return true;
    }
    
    void Shutdown() override {
        // Cleanup
    }
    
    void Clear(float r, float g, float b, float a) override {
        // Clear screen
    }
    
    void Present() override {
        // Present frame
    }
    
    GraphicsAPI GetAPI() const override {
        return GraphicsAPI::MyAPI;
    }
};
```

### Step 2: Register in GAL

Update `GraphicsAbstractionLayer.cpp`:

```cpp
bool GraphicsAbstractionLayer::Initialize(GraphicsAPI api, void* windowHandle) {
    switch (api) {
        // ... existing cases
        case GraphicsAPI::MyAPI:
            m_context = std::make_unique<MyAPIContext>();
            break;
    }
    return m_context->Initialize(windowHandle);
}
```

## Data-Driven Configuration

### Game Type Configuration

Each game type has a JSON configuration file:

```json
{
  "gameType": "RPG",
  "version": "1.0.0",
  "description": "RPG game configuration",
  "systems": [
    "RenderingSystem.dll",
    "PhysicsSystem.dll",
    "InventorySystem.dll",
    "QuestSystem.dll"
  ],
  "assets": {
    "sprites": ["hero.png", "npc.png"],
    "sounds": ["theme.ogg"],
    "maps": ["level1.json"]
  },
  "gameRules": {
    "startingHP": 100,
    "maxLevel": 50
  }
}
```

### Loading Configuration

The engine loads configuration at startup:

```cpp
bool Engine::LoadGameType(const std::string& gameType) {
    std::string configPath = m_config.gameDataPath + "/" + 
                            gameType + "/Assets/Config/game_config.json";
    
    // Parse JSON and load systems/assets
    m_assetManager.LoadAssetsFromConfig(configPath);
    
    return true;
}
```

## Performance Considerations

### System Update Order

Systems are updated in the order they are loaded. For performance-critical ordering:

1. Load systems in priority order
2. Consider dependencies between systems
3. Use profiling to identify bottlenecks

### Asset Loading

- Load assets asynchronously when possible
- Use asset streaming for large files
- Implement asset caching

### DLL Loading

- DLLs are loaded once at startup
- Hot-reloading requires careful state management
- Consider using separate DLLs for development vs. release

## Testing Systems

### Unit Testing

Create a test harness:

```cpp
int main() {
    Itchio2D::SystemManager manager;
    
    // Load system
    manager.LoadSystem("MySystem.dll");
    
    // Initialize
    manager.InitializeAll();
    
    // Update loop
    for (int i = 0; i < 100; i++) {
        manager.UpdateAll(0.016f);  // 60 FPS
    }
    
    // Cleanup
    manager.ShutdownAll();
    
    return 0;
}
```

### Integration Testing

Test with the full engine:

```cpp
Engine engine;
EngineConfig config;
config.gameType = "TestGame";

engine.Initialize(config);
// Perform tests
engine.Shutdown();
```

## Debugging

### System Loading Issues

Check:
1. DLL is in correct directory
2. Export functions are present: `CreateSystem`, `DestroySystem`
3. System implements `ISystem` interface correctly

### Rendering Issues

- Verify graphics API initialization
- Check window handle validity
- Enable graphics API debug layers

### Memory Leaks

- Ensure all systems call `Shutdown()`
- Verify `DestroySystem()` is called for each system
- Use memory profiling tools (Visual Studio Diagnostic Tools)

## Best Practices

1. **System Design**
   - Keep systems independent
   - Use events for communication
   - Avoid tight coupling

2. **Performance**
   - Profile regularly
   - Cache frequently accessed data
   - Minimize allocations in Update()

3. **Code Organization**
   - One system per file
   - Clear naming conventions
   - Document public interfaces

4. **Version Control**
   - Use semantic versioning for systems
   - Tag stable releases
   - Document breaking changes

## Advanced Topics

### Entity Component System (ECS)

Future enhancement: Full ECS implementation with:
- Entity manager
- Component storage
- System queries

### Scripting Integration

Consider adding:
- Lua for gameplay logic
- Python for tools
- Hot-reload support

### Networking

For multiplayer:
- Network system DLL
- Serialization framework
- State synchronization

## Resources

- [C++ Best Practices](https://isocpp.org/)
- [Game Programming Patterns](https://gameprogrammingpatterns.com/)
- [DirectX Documentation](https://docs.microsoft.com/en-us/windows/win32/directx)
- [OpenGL Documentation](https://www.opengl.org/documentation/)
