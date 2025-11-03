# Building on Windows

## Prerequisites

- **Visual Studio 2017 or later** (with C++ desktop development workload)
- **CMake 3.15+** ([Download](https://cmake.org/download/))
- **Windows SDK** (included with Visual Studio)

## Build Instructions

### Option 1: Visual Studio IDE

1. Open CMake GUI
2. Set source directory to the project root
3. Set build directory to `build/`
4. Click "Configure" and select your Visual Studio version
5. Click "Generate"
6. Open the generated `.sln` file in Visual Studio
7. Build the solution (F7)
8. Run `Itchio2DEngine` from the Solution Explorer

### Option 2: Command Line (Developer Command Prompt)

```cmd
:: Navigate to project directory
cd path\to\Itchio-2d

:: Create build directory
mkdir build
cd build

:: Configure (adjust VS version as needed)
cmake .. -G "Visual Studio 16 2019"

:: Build
cmake --build . --config Release

:: Run
cd bin\Release
Itchio2DEngine.exe
```

### Option 3: CMake + Ninja (faster builds)

```cmd
:: From Developer Command Prompt
mkdir build
cd build
cmake .. -G "Ninja" -DCMAKE_BUILD_TYPE=Release
cmake --build .

:: Run
cd bin
Itchio2DEngine.exe
```

## Graphics API Selection

By default, the engine uses OpenGL. To use DirectX:

Edit `src/Core/Main.cpp`:

```cpp
EngineConfig config;
config.graphicsAPI = GraphicsAPI::DirectX11;  // or DirectX12
```

## Building System DLLs

System DLLs are automatically built and placed in the correct directories:
- `build/GameData/GameTypeA/Systems/*.dll`
- `build/GameData/GameTypeB/Systems/*.dll`

## Running Tests

```cmd
cd build\bin
TestSystemManager.exe
GameTypeSwitcherDemo.exe
```

## Directory Structure After Build

```
build/
├── bin/
│   └── Itchio2DEngine.exe
├── GameData/
│   ├── GameTypeA/
│   │   ├── Systems/
│   │   │   ├── RenderingSystem.dll
│   │   │   ├── PhysicsSystem.dll
│   │   │   └── AISystem.dll
│   │   └── Assets/
│   │       └── Config/
│   │           └── game_config.json
│   └── GameTypeB/
│       ├── Systems/
│       │   ├── RenderingSystem.dll
│       │   └── AISystem.dll
│       └── Assets/
│           └── Config/
│               └── game_config.json
└── lib/
```

## Troubleshooting

### CMake Can't Find Visual Studio

Ensure you're using the correct Visual Studio version in the CMake generator. List available generators:

```cmd
cmake --help
```

### Missing Windows SDK

Install Windows SDK from Visual Studio Installer:
1. Open Visual Studio Installer
2. Modify your installation
3. Check "Windows 10 SDK" (or latest version)

### DLL Loading Fails

Ensure DLLs are in the correct directory relative to the executable. The engine looks for systems in:
`GameData/[GameType]/Systems/`

### Link Errors (user32.lib, gdi32.lib)

These are standard Windows libraries. Ensure you have the Windows SDK installed with Visual Studio.

## Release Build

For optimized release builds:

```cmd
cmake --build . --config Release
```

The release executable will be in `build/bin/Release/`.

## Debug Build

For debugging:

```cmd
cmake --build . --config Debug
```

Debug symbols will be included. Use Visual Studio debugger:
1. Open the solution file
2. Set Itchio2DEngine as startup project
3. Press F5 to debug

## Advanced: DirectX Development

### DirectX 11/12 Requirements

- Windows SDK (included with Visual Studio)
- DirectX End-User Runtime (for older systems)

### Enabling DirectX Debug Layer

In debug builds, add to `Engine.cpp`:

```cpp
#if defined(_DEBUG) && defined(PLATFORM_WINDOWS)
    // Enable D3D11/D3D12 debug layer
#endif
```

## Performance Notes

- **Release builds** are significantly faster than Debug
- Use **Profile builds** for performance analysis
- Consider using **PGO (Profile-Guided Optimization)** for production

## Common Issues

### Issue: "Cannot find or open the PDB file"

This is a warning and can be ignored, or download symbol files from Microsoft Symbol Server.

### Issue: Runtime error about missing VCRUNTIME140.dll

Install Visual C++ Redistributable:
- [Download from Microsoft](https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads)

### Issue: Window doesn't appear

Check if running on Windows. The stub implementation on Linux won't create actual windows.

## Next Steps

1. Implement full DirectX 11/12 rendering
2. Add ImGui for UI
3. Implement asset loading (stb_image, etc.)
4. Add input handling
5. Create more game systems

See [ARCHITECTURE.md](ARCHITECTURE.md) for architectural details.
