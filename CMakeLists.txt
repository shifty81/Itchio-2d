cmake_minimum_required(VERSION 3.15)
project(Itchio2D VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Platform detection
if(WIN32)
    set(PLATFORM_WINDOWS TRUE)
    add_definitions(-DPLATFORM_WINDOWS)
elseif(UNIX AND NOT APPLE)
    set(PLATFORM_LINUX TRUE)
    add_definitions(-DPLATFORM_LINUX)
endif()

# Add subdirectories
add_subdirectory(src/Core)
add_subdirectory(src/Systems)
add_subdirectory(src/Modules)

# Create GameData directory structure
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Assets/Sprites)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Assets/Tilesets)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Assets/Sounds)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Assets/Config)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeB/Systems)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeB/Assets)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/Library/CommonSprites)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/Library/SciFiTiles)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/Library/FantasyTiles)

# Copy configuration files to build directory
configure_file(${CMAKE_SOURCE_DIR}/config/GameTypeA.json ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Assets/Config/game_config.json COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/config/GameTypeB.json ${CMAKE_BINARY_DIR}/GameData/GameTypeB/Assets/Config/game_config.json COPYONLY)
