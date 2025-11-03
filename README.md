# Itchio-2d

A modular, data-driven 2D game engine for Windows with hot-swappable systems and multi-API graphics support.

## Features

- **Modular Architecture**: Hot-swappable game systems via DLLs
- **Graphics Abstraction**: Support for DirectX 11, DirectX 12, and OpenGL
- **Data-Driven Design**: JSON-based configuration for game types and assets
- **Native Windows**: Built on Win32 API for high performance
- **Flexible Asset Management**: Drop-in support for different game types

## Quick Start

### Prerequisites
- CMake 3.15+
- Visual Studio 2017+ (or compatible C++17 compiler)
- Windows SDK

### Building

```bash
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

### Running

```bash
cd build/bin
./Itchio2DEngine.exe
```

## Project Structure

```
Itchio-2d/
├── src/
│   ├── Core/              # Core engine (Engine, SystemManager, AssetManager, GAL)
│   ├── Systems/           # Example game systems (as DLLs)
│   └── Modules/           # Additional modules
├── config/                # Game type configurations (JSON)
├── docs/                  # Documentation
│   └── ARCHITECTURE.md    # Detailed architecture documentation
└── GameData/              # Runtime game data (auto-generated)
    ├── GameTypeA/
    ├── GameTypeB/
    └── Library/
```

## Architecture

This engine implements a modular, data-driven architecture with:

1. **Core Application Framework** (C++ with Win32)
2. **Graphics Abstraction Layer** (DirectX 11/12, OpenGL)
3. **Dynamic System Loading** (Hot-swappable DLL modules)
4. **Entity Component System** (Modular game functionality)
5. **Data-Driven Asset Management** (JSON configuration)

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed documentation.

## Switching Game Types

Edit `src/Core/Main.cpp`:

```cpp
EngineConfig config;
config.gameType = "GameTypeA";  // or "GameTypeB"
config.graphicsAPI = GraphicsAPI::OpenGL;  // or DirectX11, DirectX12
```

## Creating Custom Systems

1. Implement the `ISystem` interface
2. Export `CreateSystem()` and `DestroySystem()` functions
3. Build as a DLL
4. Place in `GameData/[GameType]/Systems/`

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for examples.

## License

[Add license information here]
