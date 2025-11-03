#pragma once

#include <string>
#include <memory>

namespace Itchio2D {

// System interface that all game systems must implement
class ISystem {
public:
    virtual ~ISystem() = default;
    
    // Initialize the system
    virtual bool Initialize() = 0;
    
    // Update the system (called each frame)
    virtual void Update(float deltaTime) = 0;
    
    // Shutdown the system
    virtual void Shutdown() = 0;
    
    // Get system name
    virtual const char* GetName() const = 0;
};

// Factory function type for creating systems
typedef ISystem* (*CreateSystemFunc)();
typedef void (*DestroySystemFunc)(ISystem*);

} // namespace Itchio2D
