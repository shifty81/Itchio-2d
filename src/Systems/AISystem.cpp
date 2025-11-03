#include "../Core/ISystem.h"
#include <iostream>

using namespace Itchio2D;

class AISystem : public ISystem {
public:
    bool Initialize() override {
        std::cout << "[AISystem] Initialized" << std::endl;
        return true;
    }
    
    void Update(float deltaTime) override {
        // AI logic would go here
    }
    
    void Shutdown() override {
        std::cout << "[AISystem] Shutdown" << std::endl;
    }
    
    const char* GetName() const override {
        return "AISystem";
    }
};

// Export functions for DLL
extern "C" {
    #ifdef PLATFORM_WINDOWS
        __declspec(dllexport) ISystem* CreateSystem() {
            return new AISystem();
        }
        
        __declspec(dllexport) void DestroySystem(ISystem* system) {
            delete system;
        }
    #else
        ISystem* CreateSystem() {
            return new AISystem();
        }
        
        void DestroySystem(ISystem* system) {
            delete system;
        }
    #endif
}
