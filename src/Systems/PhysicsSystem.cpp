#include "../Core/ISystem.h"
#include <iostream>

using namespace Itchio2D;

class PhysicsSystem : public ISystem {
public:
    bool Initialize() override {
        std::cout << "[PhysicsSystem] Initialized" << std::endl;
        return true;
    }
    
    void Update(float deltaTime) override {
        // Physics simulation would go here
    }
    
    void Shutdown() override {
        std::cout << "[PhysicsSystem] Shutdown" << std::endl;
    }
    
    const char* GetName() const override {
        return "PhysicsSystem";
    }
};

// Export functions for DLL
extern "C" {
    #ifdef PLATFORM_WINDOWS
        __declspec(dllexport) ISystem* CreateSystem() {
            return new PhysicsSystem();
        }
        
        __declspec(dllexport) void DestroySystem(ISystem* system) {
            delete system;
        }
    #else
        ISystem* CreateSystem() {
            return new PhysicsSystem();
        }
        
        void DestroySystem(ISystem* system) {
            delete system;
        }
    #endif
}
