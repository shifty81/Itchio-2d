#include "Engine.h"
#include <iostream>

using namespace Itchio2D;

#ifdef PLATFORM_WINDOWS
#include <windows.h>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
#else
int main(int argc, char* argv[]) {
#endif
    std::cout << "=== Itchio 2D Engine ===" << std::endl;
    std::cout << "Modular, Data-Driven Architecture" << std::endl;
    std::cout << "===========================" << std::endl << std::endl;
    
    Engine engine;
    
    // Configure engine
    EngineConfig config;
    config.windowTitle = "Itchio 2D - Modular Game Engine";
    config.windowWidth = 1280;
    config.windowHeight = 720;
    config.graphicsAPI = GraphicsAPI::OpenGL;  // Can be changed to DirectX11 or DirectX12
    config.gameDataPath = "GameData";
    config.gameType = "GameTypeA";  // Can be switched to GameTypeB or other types
    
    // Initialize engine
    if (!engine.Initialize(config)) {
        std::cerr << "Failed to initialize engine" << std::endl;
        return -1;
    }
    
    // Run the engine
    engine.Run();
    
    // Shutdown
    engine.Shutdown();
    
    std::cout << "Application exited normally" << std::endl;
    return 0;
}
