cmake_minimum_required(VERSION 3.15)

# Core Engine Library
add_library(ItchioCore STATIC
    SystemManager.cpp
    SystemManager.h
    ISystem.h
    GraphicsAbstractionLayer.cpp
    GraphicsAbstractionLayer.h
    AssetManager.cpp
    AssetManager.h
    Engine.cpp
    Engine.h
)

target_include_directories(ItchioCore PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# Main executable (only build on Windows)
if(PLATFORM_WINDOWS)
    add_executable(Itchio2DEngine Main.cpp)
    target_link_libraries(Itchio2DEngine ItchioCore user32 gdi32)
    
    # Set output directory
    set_target_properties(Itchio2DEngine PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
else()
    # On non-Windows platforms, create a stub executable for testing
    message(STATUS "Building stub executable for non-Windows platform")
    add_executable(Itchio2DEngine Main.cpp)
    target_link_libraries(Itchio2DEngine ItchioCore)
    
    set_target_properties(Itchio2DEngine PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
endif()

# Test executable for System Manager
add_executable(TestSystemManager TestSystemManager.cpp)
target_link_libraries(TestSystemManager ItchioCore)
set_target_properties(TestSystemManager PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)

# Game Type Switcher Demo
add_executable(GameTypeSwitcherDemo GameTypeSwitcherDemo.cpp)
target_link_libraries(GameTypeSwitcherDemo ItchioCore)
set_target_properties(GameTypeSwitcherDemo PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
