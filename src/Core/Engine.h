#pragma once

#include "SystemManager.h"
#include "AssetManager.h"
#include "GraphicsAbstractionLayer.h"
#include <string>
#include <memory>

namespace Itchio2D {

struct EngineConfig {
    std::string windowTitle = "Itchio 2D Engine";
    int windowWidth = 1280;
    int windowHeight = 720;
    GraphicsAPI graphicsAPI = GraphicsAPI::OpenGL;
    std::string gameDataPath = "GameData";
    std::string gameType = "GameTypeA";
};

class Engine {
public:
    Engine();
    ~Engine();
    
    bool Initialize(const EngineConfig& config);
    void Run();
    void Shutdown();
    
    SystemManager& GetSystemManager() { return m_systemManager; }
    AssetManager& GetAssetManager() { return m_assetManager; }
    GraphicsAbstractionLayer& GetGraphics() { return m_graphics; }
    
    bool IsRunning() const { return m_running; }
    void Stop() { m_running = false; }
    
private:
    bool InitializeWindow();
    void ProcessEvents();
    void Update(float deltaTime);
    void Render();
    
    bool LoadGameType(const std::string& gameType);
    
    EngineConfig m_config;
    SystemManager m_systemManager;
    AssetManager m_assetManager;
    GraphicsAbstractionLayer m_graphics;
    
    void* m_windowHandle;
    bool m_running;
    
#ifdef PLATFORM_WINDOWS
    void* m_hInstance;
#endif
};

} // namespace Itchio2D
