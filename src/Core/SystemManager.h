#pragma once

#include <string>
#include <map>
#include <memory>
#include <vector>

#ifdef PLATFORM_WINDOWS
#include <windows.h>
#endif

namespace Itchio2D {

class ISystem;

// DLL Module wrapper
class Module {
public:
    Module();
    ~Module();
    
    bool Load(const std::string& path);
    void Unload();
    bool IsLoaded() const { return m_handle != nullptr; }
    
    void* GetFunction(const std::string& name);
    
private:
#ifdef PLATFORM_WINDOWS
    HMODULE m_handle;
#else
    void* m_handle;
#endif
};

// System Manager - loads and manages game systems
class SystemManager {
public:
    SystemManager();
    ~SystemManager();
    
    // Load a system from a DLL
    bool LoadSystem(const std::string& dllPath);
    
    // Unload a specific system
    void UnloadSystem(const std::string& systemName);
    
    // Unload all systems
    void UnloadAllSystems();
    
    // Initialize all loaded systems
    bool InitializeAll();
    
    // Update all loaded systems
    void UpdateAll(float deltaTime);
    
    // Shutdown all systems
    void ShutdownAll();
    
    // Get a system by name
    ISystem* GetSystem(const std::string& name);
    
private:
    struct SystemEntry {
        std::unique_ptr<Module> module;
        ISystem* system;
        std::string name;
    };
    
    std::vector<SystemEntry> m_systems;
};

} // namespace Itchio2D
