#include "GraphicsAbstractionLayer.h"
#include <iostream>

#ifdef PLATFORM_WINDOWS
#include <windows.h>
#endif

namespace Itchio2D {

// Stub implementation for DirectX 11
class DX11Context : public IGraphicsContext {
public:
    bool Initialize(void* windowHandle) override {
        std::cout << "DirectX 11 context initialized (stub)" << std::endl;
        return true;
    }
    
    void Shutdown() override {
        std::cout << "DirectX 11 context shutdown" << std::endl;
    }
    
    void Clear(float r, float g, float b, float a) override {
        // Stub implementation
    }
    
    void Present() override {
        // Stub implementation
    }
    
    GraphicsAPI GetAPI() const override {
        return GraphicsAPI::DirectX11;
    }
};

// Stub implementation for DirectX 12
class DX12Context : public IGraphicsContext {
public:
    bool Initialize(void* windowHandle) override {
        std::cout << "DirectX 12 context initialized (stub)" << std::endl;
        return true;
    }
    
    void Shutdown() override {
        std::cout << "DirectX 12 context shutdown" << std::endl;
    }
    
    void Clear(float r, float g, float b, float a) override {
        // Stub implementation
    }
    
    void Present() override {
        // Stub implementation
    }
    
    GraphicsAPI GetAPI() const override {
        return GraphicsAPI::DirectX12;
    }
};

// Stub implementation for OpenGL
class OpenGLContext : public IGraphicsContext {
public:
    bool Initialize(void* windowHandle) override {
        std::cout << "OpenGL context initialized (stub)" << std::endl;
        return true;
    }
    
    void Shutdown() override {
        std::cout << "OpenGL context shutdown" << std::endl;
    }
    
    void Clear(float r, float g, float b, float a) override {
        // Stub implementation
    }
    
    void Present() override {
        // Stub implementation
    }
    
    GraphicsAPI GetAPI() const override {
        return GraphicsAPI::OpenGL;
    }
};

// GraphicsAbstractionLayer implementation
GraphicsAbstractionLayer::GraphicsAbstractionLayer() 
    : m_currentAPI(GraphicsAPI::None) {
}

GraphicsAbstractionLayer::~GraphicsAbstractionLayer() {
    Shutdown();
}

bool GraphicsAbstractionLayer::Initialize(GraphicsAPI api, void* windowHandle) {
    m_currentAPI = api;
    
    switch (api) {
        case GraphicsAPI::DirectX11:
            m_context = std::make_unique<DX11Context>();
            break;
        case GraphicsAPI::DirectX12:
            m_context = std::make_unique<DX12Context>();
            break;
        case GraphicsAPI::OpenGL:
            m_context = std::make_unique<OpenGLContext>();
            break;
        default:
            std::cerr << "Unknown graphics API" << std::endl;
            return false;
    }
    
    return m_context->Initialize(windowHandle);
}

void GraphicsAbstractionLayer::Shutdown() {
    if (m_context) {
        m_context->Shutdown();
        m_context.reset();
    }
    m_currentAPI = GraphicsAPI::None;
}

void GraphicsAbstractionLayer::BeginFrame() {
    // Begin frame setup
}

void GraphicsAbstractionLayer::EndFrame() {
    if (m_context) {
        m_context->Present();
    }
}

void GraphicsAbstractionLayer::Clear(float r, float g, float b, float a) {
    if (m_context) {
        m_context->Clear(r, g, b, a);
    }
}

} // namespace Itchio2D
