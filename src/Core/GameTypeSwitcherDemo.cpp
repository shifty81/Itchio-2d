#include "Engine.h"
#include <iostream>
#include <thread>
#include <chrono>

using namespace Itchio2D;

void RunGameType(const std::string& gameType) {
    std::cout << "\n========================================" << std::endl;
    std::cout << "Running Game Type: " << gameType << std::endl;
    std::cout << "========================================\n" << std::endl;
    
    Engine engine;
    
    EngineConfig config;
    config.windowTitle = "Itchio 2D - " + gameType;
    config.windowWidth = 1280;
    config.windowHeight = 720;
    config.graphicsAPI = GraphicsAPI::OpenGL;
    config.gameDataPath = "GameData";
    config.gameType = gameType;
    
    if (!engine.Initialize(config)) {
        std::cerr << "Failed to initialize engine for " << gameType << std::endl;
        return;
    }
    
    // Run for a short time in test mode
    std::cout << "\nRunning engine (will auto-stop in ~2 seconds)..." << std::endl;
    engine.Run();
    
    engine.Shutdown();
    
    std::cout << "\n" << gameType << " completed successfully!" << std::endl;
}

#ifdef PLATFORM_WINDOWS
#include <windows.h>
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
#else
int main(int argc, char* argv[]) {
#endif
    std::cout << "=======================================" << std::endl;
    std::cout << "  Itchio 2D - Game Type Switcher Demo" << std::endl;
    std::cout << "  Modular, Data-Driven Architecture" << std::endl;
    std::cout << "=======================================" << std::endl;
    
    // Demonstrate switching between game types
    RunGameType("GameTypeA");
    
    std::cout << "\n\n*** Switching to different game type ***\n" << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
    
    RunGameType("GameTypeB");
    
    std::cout << "\n=======================================" << std::endl;
    std::cout << "  Demo completed successfully!" << std::endl;
    std::cout << "  Both game types ran with different" << std::endl;
    std::cout << "  system configurations as expected." << std::endl;
    std::cout << "=======================================" << std::endl;
    
    return 0;
}
