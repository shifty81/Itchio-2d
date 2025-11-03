#pragma once

#include <string>
#include <memory>

namespace Itchio2D {

// Graphics API types
enum class GraphicsAPI {
    None,
    DirectX11,
    DirectX12,
    OpenGL
};

// Graphics Context interface
class IGraphicsContext {
public:
    virtual ~IGraphicsContext() = default;
    
    virtual bool Initialize(void* windowHandle) = 0;
    virtual void Shutdown() = 0;
    virtual void Clear(float r, float g, float b, float a) = 0;
    virtual void Present() = 0;
    virtual GraphicsAPI GetAPI() const = 0;
};

// Graphics Abstraction Layer
class GraphicsAbstractionLayer {
public:
    GraphicsAbstractionLayer();
    ~GraphicsAbstractionLayer();
    
    bool Initialize(GraphicsAPI api, void* windowHandle);
    void Shutdown();
    
    void BeginFrame();
    void EndFrame();
    void Clear(float r, float g, float b, float a);
    
    GraphicsAPI GetCurrentAPI() const { return m_currentAPI; }
    IGraphicsContext* GetContext() { return m_context.get(); }
    
private:
    GraphicsAPI m_currentAPI;
    std::unique_ptr<IGraphicsContext> m_context;
};

} // namespace Itchio2D
