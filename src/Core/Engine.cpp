#include "Engine.h"
#include <iostream>
#include <chrono>
#include <thread>

#ifdef PLATFORM_WINDOWS
#include <windows.h>
#endif

namespace Itchio2D {

#ifdef PLATFORM_WINDOWS
// Windows message procedure
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        case WM_CLOSE:
            PostQuitMessage(0);
            return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
#endif

Engine::Engine() 
    : m_windowHandle(nullptr)
    , m_running(false)
#ifdef PLATFORM_WINDOWS
    , m_hInstance(nullptr)
#endif
{
}

Engine::~Engine() {
    Shutdown();
}

bool Engine::Initialize(const EngineConfig& config) {
    m_config = config;
    
    std::cout << "Initializing Itchio 2D Engine..." << std::endl;
    std::cout << "  Window: " << config.windowWidth << "x" << config.windowHeight << std::endl;
    std::cout << "  Graphics API: ";
    switch (config.graphicsAPI) {
        case GraphicsAPI::DirectX11: std::cout << "DirectX 11"; break;
        case GraphicsAPI::DirectX12: std::cout << "DirectX 12"; break;
        case GraphicsAPI::OpenGL: std::cout << "OpenGL"; break;
        default: std::cout << "None"; break;
    }
    std::cout << std::endl;
    
    // Initialize window
    if (!InitializeWindow()) {
        std::cerr << "Failed to initialize window" << std::endl;
        return false;
    }
    
    // Initialize graphics
    if (!m_graphics.Initialize(config.graphicsAPI, m_windowHandle)) {
        std::cerr << "Failed to initialize graphics" << std::endl;
        return false;
    }
    
    // Set asset directory
    std::string assetPath = config.gameDataPath + "/" + config.gameType + "/Assets";
    m_assetManager.SetAssetDirectory(assetPath);
    
    // Load game type
    if (!LoadGameType(config.gameType)) {
        std::cerr << "Failed to load game type: " << config.gameType << std::endl;
        return false;
    }
    
    // Initialize all systems
    if (!m_systemManager.InitializeAll()) {
        std::cerr << "Failed to initialize systems" << std::endl;
        return false;
    }
    
    std::cout << "Engine initialized successfully" << std::endl;
    m_running = true;
    return true;
}

bool Engine::InitializeWindow() {
#ifdef PLATFORM_WINDOWS
    m_hInstance = GetModuleHandle(NULL);
    
    // Register window class
    WNDCLASSA wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = (HINSTANCE)m_hInstance;
    wc.lpszClassName = "Itchio2DWindowClass";
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    
    if (!RegisterClassA(&wc)) {
        std::cerr << "Failed to register window class" << std::endl;
        return false;
    }
    
    // Create window
    HWND hwnd = CreateWindowExA(
        0,
        "Itchio2DWindowClass",
        m_config.windowTitle.c_str(),
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        m_config.windowWidth, m_config.windowHeight,
        NULL,
        NULL,
        (HINSTANCE)m_hInstance,
        NULL
    );
    
    if (!hwnd) {
        std::cerr << "Failed to create window" << std::endl;
        return false;
    }
    
    m_windowHandle = hwnd;
    ShowWindow(hwnd, SW_SHOW);
    
    std::cout << "Window created successfully" << std::endl;
    return true;
#else
    // Stub for non-Windows platforms
    std::cout << "Window creation (stub for non-Windows platform)" << std::endl;
    m_windowHandle = (void*)1;  // Dummy handle
    return true;
#endif
}

void Engine::ProcessEvents() {
#ifdef PLATFORM_WINDOWS
    MSG msg = {};
    while (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
        if (msg.message == WM_QUIT) {
            m_running = false;
        }
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }
#else
    // Stub for non-Windows platforms
    static int frameCount = 0;
    frameCount++;
    if (frameCount > 120) {  // Run for ~2 seconds at 60 FPS
        m_running = false;
    }
#endif
}

void Engine::Update(float deltaTime) {
    m_systemManager.UpdateAll(deltaTime);
}

void Engine::Render() {
    m_graphics.Clear(0.2f, 0.3f, 0.4f, 1.0f);
    // Rendering logic would go here
    m_graphics.EndFrame();
}

void Engine::Run() {
    std::cout << "Starting engine main loop..." << std::endl;
    
    auto lastTime = std::chrono::high_resolution_clock::now();
    
    while (m_running) {
        // Calculate delta time
        auto currentTime = std::chrono::high_resolution_clock::now();
        float deltaTime = std::chrono::duration<float>(currentTime - lastTime).count();
        lastTime = currentTime;
        
        // Process window events
        ProcessEvents();
        
        // Update
        Update(deltaTime);
        
        // Render
        Render();
        
        // Sleep to maintain reasonable frame rate (limit to ~60 FPS)
        std::this_thread::sleep_for(std::chrono::milliseconds(16));
    }
    
    std::cout << "Engine loop ended" << std::endl;
}

void Engine::Shutdown() {
    std::cout << "Shutting down engine..." << std::endl;
    
    m_systemManager.ShutdownAll();
    m_systemManager.UnloadAllSystems();
    m_assetManager.UnloadAll();
    m_graphics.Shutdown();
    
    // Cleanup window
#ifdef PLATFORM_WINDOWS
    if (m_windowHandle) {
        DestroyWindow((HWND)m_windowHandle);
        m_windowHandle = nullptr;
    }
#else
    // Stub for non-Windows platforms
    m_windowHandle = nullptr;
#endif
    
    m_running = false;
    std::cout << "Engine shutdown complete" << std::endl;
}

bool Engine::LoadGameType(const std::string& gameType) {
    std::cout << "Loading game type: " << gameType << std::endl;
    
    // Load systems from DLL directory
    std::string systemsPath = m_config.gameDataPath + "/" + gameType + "/Systems/";
    
    // Note: In a real implementation, we would scan the directory for DLLs
    // For now, we'll just log that we would load them
    std::cout << "  Systems directory: " << systemsPath << std::endl;
    
    // Load asset configuration
    std::string configPath = m_config.gameDataPath + "/" + gameType + "/Assets/Config/game_config.json";
    m_assetManager.LoadAssetsFromConfig(configPath);
    
    return true;
}

} // namespace Itchio2D
