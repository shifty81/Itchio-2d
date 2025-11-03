#include "../Core/ISystem.h"
#include <iostream>

using namespace Itchio2D;

class RenderingSystem : public ISystem {
public:
    bool Initialize() override {
        std::cout << "[RenderingSystem] Initialized" << std::endl;
        return true;
    }
    
    void Update(float deltaTime) override {
        // Rendering logic would go here
    }
    
    void Shutdown() override {
        std::cout << "[RenderingSystem] Shutdown" << std::endl;
    }
    
    const char* GetName() const override {
        return "RenderingSystem";
    }
};

// Export functions for DLL
extern "C" {
    #ifdef PLATFORM_WINDOWS
        __declspec(dllexport) ISystem* CreateSystem() {
            return new RenderingSystem();
        }
        
        __declspec(dllexport) void DestroySystem(ISystem* system) {
            delete system;
        }
    #else
        ISystem* CreateSystem() {
            return new RenderingSystem();
        }
        
        void DestroySystem(ISystem* system) {
            delete system;
        }
    #endif
}
