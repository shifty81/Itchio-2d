#include "SystemManager.h"
#include "ISystem.h"
#include <iostream>

#ifdef PLATFORM_WINDOWS
#include <windows.h>
#else
#include <dlfcn.h>
#endif

namespace Itchio2D {

// Module implementation
Module::Module() : m_handle(nullptr) {}

Module::~Module() {
    Unload();
}

bool Module::Load(const std::string& path) {
    if (m_handle) {
        Unload();
    }
    
#ifdef PLATFORM_WINDOWS
    m_handle = LoadLibraryA(path.c_str());
    if (!m_handle) {
        std::cerr << "Failed to load module: " << path << " Error: " << GetLastError() << std::endl;
        return false;
    }
#else
    m_handle = dlopen(path.c_str(), RTLD_LAZY);
    if (!m_handle) {
        std::cerr << "Failed to load module: " << path << " Error: " << dlerror() << std::endl;
        return false;
    }
#endif
    
    return true;
}

void Module::Unload() {
    if (m_handle) {
#ifdef PLATFORM_WINDOWS
        FreeLibrary(m_handle);
#else
        dlclose(m_handle);
#endif
        m_handle = nullptr;
    }
}

void* Module::GetFunction(const std::string& name) {
    if (!m_handle) {
        return nullptr;
    }
    
#ifdef PLATFORM_WINDOWS
    return (void*)GetProcAddress(m_handle, name.c_str());
#else
    return dlsym(m_handle, name.c_str());
#endif
}

// SystemManager implementation
SystemManager::SystemManager() {}

SystemManager::~SystemManager() {
    ShutdownAll();
    UnloadAllSystems();
}

bool SystemManager::LoadSystem(const std::string& dllPath) {
    auto module = std::make_unique<Module>();
    if (!module->Load(dllPath)) {
        return false;
    }
    
    // Get the factory functions
    auto createFunc = (CreateSystemFunc)module->GetFunction("CreateSystem");
    if (!createFunc) {
        std::cerr << "Failed to find CreateSystem function in " << dllPath << std::endl;
        return false;
    }
    
    // Create the system instance
    ISystem* system = createFunc();
    if (!system) {
        std::cerr << "Failed to create system from " << dllPath << std::endl;
        return false;
    }
    
    SystemEntry entry;
    entry.module = std::move(module);
    entry.system = system;
    entry.name = system->GetName();
    
    m_systems.push_back(std::move(entry));
    
    std::cout << "Loaded system: " << entry.name << " from " << dllPath << std::endl;
    return true;
}

void SystemManager::UnloadSystem(const std::string& systemName) {
    for (auto it = m_systems.begin(); it != m_systems.end(); ++it) {
        if (it->name == systemName) {
            it->system->Shutdown();
            
            // Get destroy function before unloading
            auto destroyFunc = (DestroySystemFunc)it->module->GetFunction("DestroySystem");
            if (destroyFunc) {
                destroyFunc(it->system);
            }
            
            m_systems.erase(it);
            break;
        }
    }
}

void SystemManager::UnloadAllSystems() {
    for (auto& entry : m_systems) {
        auto destroyFunc = (DestroySystemFunc)entry.module->GetFunction("DestroySystem");
        if (destroyFunc && entry.system) {
            destroyFunc(entry.system);
        }
    }
    m_systems.clear();
}

bool SystemManager::InitializeAll() {
    for (auto& entry : m_systems) {
        if (!entry.system->Initialize()) {
            std::cerr << "Failed to initialize system: " << entry.name << std::endl;
            return false;
        }
    }
    return true;
}

void SystemManager::UpdateAll(float deltaTime) {
    for (auto& entry : m_systems) {
        entry.system->Update(deltaTime);
    }
}

void SystemManager::ShutdownAll() {
    for (auto& entry : m_systems) {
        entry.system->Shutdown();
    }
}

ISystem* SystemManager::GetSystem(const std::string& name) {
    for (auto& entry : m_systems) {
        if (entry.name == name) {
            return entry.system;
        }
    }
    return nullptr;
}

} // namespace Itchio2D
