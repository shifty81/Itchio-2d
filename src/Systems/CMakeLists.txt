cmake_minimum_required(VERSION 3.15)

# Build each system as a shared library (DLL)
add_library(RenderingSystem SHARED RenderingSystem.cpp)
target_include_directories(RenderingSystem PRIVATE ${CMAKE_SOURCE_DIR}/src)

add_library(PhysicsSystem SHARED PhysicsSystem.cpp)
target_include_directories(PhysicsSystem PRIVATE ${CMAKE_SOURCE_DIR}/src)

add_library(AISystem SHARED AISystem.cpp)
target_include_directories(AISystem PRIVATE ${CMAKE_SOURCE_DIR}/src)

# Set output directories for the DLLs
set_target_properties(RenderingSystem PhysicsSystem AISystem PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/GameData/GameTypeA/Systems
)

# Copy to GameTypeB as well (for demonstration)
add_custom_command(TARGET RenderingSystem POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:RenderingSystem> ${CMAKE_BINARY_DIR}/GameData/GameTypeB/Systems/
)

add_custom_command(TARGET AISystem POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:AISystem> ${CMAKE_BINARY_DIR}/GameData/GameTypeB/Systems/
)
