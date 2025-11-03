@echo off
REM Build verification script for Itchio 2D Engine (Windows)

echo ======================================
echo   Itchio 2D Engine - Build Verification
echo ======================================
echo.

REM Check CMake
echo Checking CMake...
where cmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X CMake not found. Please install CMake 3.15 or later.
    exit /b 1
)
for /f "tokens=3" %%i in ('cmake --version ^| findstr /R "[0-9]"') do (
    echo + CMake found: %%i
    goto cmake_done
)
:cmake_done

REM Check compiler (look for Visual Studio)
echo.
echo Checking for Visual Studio...
where cl.exe >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo X Visual Studio compiler not found.
    echo   Please run from Developer Command Prompt or install Visual Studio.
    exit /b 1
)
echo + Visual Studio compiler found

REM Check directory structure
echo.
echo Checking project structure...
if not exist "CMakeLists.txt" (
    echo X CMakeLists.txt not found. Are you in the project root?
    exit /b 1
)
echo + CMakeLists.txt found

if not exist "src\Core" (
    echo X src\Core directory not found.
    exit /b 1
)
echo + src\Core directory found

REM Attempt build
echo.
echo Attempting test build...
set BUILD_DIR=build_verify
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
mkdir "%BUILD_DIR%"
cd "%BUILD_DIR%"

echo.
echo Configuring with CMake...
cmake .. -G "Visual Studio 16 2019" > cmake_config.log 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo X CMake configuration failed. Check cmake_config.log for details.
    type cmake_config.log
    cd ..
    exit /b 1
)
echo + CMake configuration successful

echo.
echo Building project...
cmake --build . --config Release > cmake_build.log 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo X Build failed. Check cmake_build.log for details.
    type cmake_build.log
    cd ..
    exit /b 1
)
echo + Build successful

REM Check outputs
echo.
echo Verifying build outputs...

if not exist "bin\Release\Itchio2DEngine.exe" (
    echo X Main executable not found
    cd ..
    exit /b 1
)
echo + Main executable found

if not exist "bin\Release\TestSystemManager.exe" (
    echo X Test executable not found
    cd ..
    exit /b 1
)
echo + Test executable found

REM Check systems
set SYSTEMS_FOUND=0
for %%s in (RenderingSystem PhysicsSystem AISystem) do (
    if exist "GameData\GameTypeA\Systems\%%s.dll" (
        echo + %%s found
        set /a SYSTEMS_FOUND+=1
    ) else (
        echo X %%s not found
    )
)

REM Check configs
if not exist "GameData\GameTypeA\Assets\Config\game_config.json" (
    echo X GameTypeA config not found
    cd ..
    exit /b 1
)
echo + GameTypeA config found

if not exist "GameData\GameTypeB\Assets\Config\game_config.json" (
    echo X GameTypeB config not found
    cd ..
    exit /b 1
)
echo + GameTypeB config found

REM Run tests
echo.
echo Running tests...
cd bin\Release
TestSystemManager.exe > test.log 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo X Tests failed. Check test.log for details.
    type test.log
    cd ..\..\..\..
    exit /b 1
)
echo + Tests passed
cd ..\..

REM Cleanup
cd ..
rmdir /s /q "%BUILD_DIR%"

echo.
echo ======================================
echo + All verifications passed!
echo ======================================
echo.
echo Your build environment is correctly set up.
echo You can now build the project with:
echo   mkdir build ^&^& cd build
echo   cmake .. -G "Visual Studio 16 2019"
echo   cmake --build . --config Release
echo.
