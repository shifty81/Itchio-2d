#include "SystemManager.h"
#include "ISystem.h"
#include <iostream>
#include <cassert>

using namespace Itchio2D;

int main() {
    std::cout << "=== System Manager Test ===" << std::endl;
    
    SystemManager manager;
    
    // Test loading systems
    std::cout << "\n1. Testing system loading..." << std::endl;
    bool loaded1 = manager.LoadSystem("GameData/GameTypeA/Systems/libRenderingSystem.so");
    bool loaded2 = manager.LoadSystem("GameData/GameTypeA/Systems/libPhysicsSystem.so");
    bool loaded3 = manager.LoadSystem("GameData/GameTypeA/Systems/libAISystem.so");
    
    assert(loaded1 && "Failed to load RenderingSystem");
    assert(loaded2 && "Failed to load PhysicsSystem");
    assert(loaded3 && "Failed to load AISystem");
    std::cout << "   ✓ All systems loaded successfully" << std::endl;
    
    // Test initialization
    std::cout << "\n2. Testing system initialization..." << std::endl;
    bool initialized = manager.InitializeAll();
    assert(initialized && "Failed to initialize systems");
    std::cout << "   ✓ All systems initialized successfully" << std::endl;
    
    // Test update
    std::cout << "\n3. Testing system updates..." << std::endl;
    for (int i = 0; i < 5; i++) {
        manager.UpdateAll(0.016f);  // 60 FPS
    }
    std::cout << "   ✓ Systems updated successfully" << std::endl;
    
    // Test getting a system
    std::cout << "\n4. Testing system retrieval..." << std::endl;
    ISystem* renderSystem = manager.GetSystem("RenderingSystem");
    assert(renderSystem != nullptr && "Failed to get RenderingSystem");
    std::cout << "   ✓ Retrieved system: " << renderSystem->GetName() << std::endl;
    
    // Test shutdown
    std::cout << "\n5. Testing system shutdown..." << std::endl;
    manager.ShutdownAll();
    std::cout << "   ✓ All systems shutdown successfully" << std::endl;
    
    // Test unloading specific system
    std::cout << "\n6. Testing system unloading..." << std::endl;
    manager.UnloadSystem("PhysicsSystem");
    std::cout << "   ✓ PhysicsSystem unloaded successfully" << std::endl;
    
    // Test unloading all
    std::cout << "\n7. Testing unload all systems..." << std::endl;
    manager.UnloadAllSystems();
    std::cout << "   ✓ All systems unloaded successfully" << std::endl;
    
    std::cout << "\n=== All tests passed! ===" << std::endl;
    return 0;
}
