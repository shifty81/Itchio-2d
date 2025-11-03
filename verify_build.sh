#!/bin/bash
# Build verification script for Itchio 2D Engine

echo "======================================"
echo "  Itchio 2D Engine - Build Verification"
echo "======================================"
echo ""

# Check CMake
echo "Checking CMake..."
if ! command -v cmake &> /dev/null; then
    echo "❌ CMake not found. Please install CMake 3.15 or later."
    exit 1
fi
CMAKE_VERSION=$(cmake --version | head -n1 | cut -d' ' -f3)
echo "✓ CMake found: $CMAKE_VERSION"

# Check compiler
echo ""
echo "Checking C++ compiler..."
if ! command -v g++ &> /dev/null && ! command -v clang++ &> /dev/null; then
    echo "❌ No C++ compiler found. Please install g++ or clang++."
    exit 1
fi
if command -v g++ &> /dev/null; then
    CXX_VERSION=$(g++ --version | head -n1)
    echo "✓ Compiler found: $CXX_VERSION"
elif command -v clang++ &> /dev/null; then
    CXX_VERSION=$(clang++ --version | head -n1)
    echo "✓ Compiler found: $CXX_VERSION"
fi

# Check directory structure
echo ""
echo "Checking project structure..."
if [ ! -f "CMakeLists.txt" ]; then
    echo "❌ CMakeLists.txt not found. Are you in the project root?"
    exit 1
fi
echo "✓ CMakeLists.txt found"

if [ ! -d "src/Core" ]; then
    echo "❌ src/Core directory not found."
    exit 1
fi
echo "✓ src/Core directory found"

# Attempt build
echo ""
echo "Attempting test build..."
BUILD_DIR="build_verify"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

echo ""
echo "Configuring with CMake..."
if ! cmake .. > cmake_config.log 2>&1; then
    echo "❌ CMake configuration failed. Check cmake_config.log for details."
    cat cmake_config.log
    exit 1
fi
echo "✓ CMake configuration successful"

echo ""
echo "Building project..."
if ! cmake --build . > cmake_build.log 2>&1; then
    echo "❌ Build failed. Check cmake_build.log for details."
    tail -n 20 cmake_build.log
    exit 1
fi
echo "✓ Build successful"

# Check outputs
echo ""
echo "Verifying build outputs..."

if [ ! -f "bin/Itchio2DEngine" ]; then
    echo "❌ Main executable not found"
    exit 1
fi
echo "✓ Main executable found"

if [ ! -f "bin/TestSystemManager" ]; then
    echo "❌ Test executable not found"
    exit 1
fi
echo "✓ Test executable found"

# Check systems
SYSTEMS_FOUND=0
for system in RenderingSystem PhysicsSystem AISystem; do
    if [ -f "GameData/GameTypeA/Systems/lib${system}.so" ] || [ -f "GameData/GameTypeA/Systems/${system}.dll" ]; then
        echo "✓ $system found"
        ((SYSTEMS_FOUND++))
    else
        echo "❌ $system not found"
    fi
done

if [ $SYSTEMS_FOUND -lt 3 ]; then
    echo "❌ Not all systems were built"
    exit 1
fi

# Check configs
if [ ! -f "GameData/GameTypeA/Assets/Config/game_config.json" ]; then
    echo "❌ GameTypeA config not found"
    exit 1
fi
echo "✓ GameTypeA config found"

if [ ! -f "GameData/GameTypeB/Assets/Config/game_config.json" ]; then
    echo "❌ GameTypeB config not found"
    exit 1
fi
echo "✓ GameTypeB config found"

# Run tests
echo ""
echo "Running tests..."
if ! ./bin/TestSystemManager > test.log 2>&1; then
    echo "❌ Tests failed. Check test.log for details."
    cat test.log
    exit 1
fi
echo "✓ Tests passed"

# Cleanup
cd ..
rm -rf "$BUILD_DIR"

echo ""
echo "======================================"
echo "✓ All verifications passed!"
echo "======================================"
echo ""
echo "Your build environment is correctly set up."
echo "You can now build the project with:"
echo "  mkdir build && cd build"
echo "  cmake .."
echo "  cmake --build ."
echo ""
