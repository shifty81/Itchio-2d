#pragma once

#include <string>
#include <map>
#include <vector>
#include <memory>

namespace Itchio2D {

// Asset types
enum class AssetType {
    Texture,
    Sound,
    Config,
    Tileset,
    Other
};

// Base asset class
class Asset {
public:
    virtual ~Asset() = default;
    virtual AssetType GetType() const = 0;
    virtual bool Load(const std::string& path) = 0;
    virtual void Unload() = 0;
};

// Texture asset (stub)
class TextureAsset : public Asset {
public:
    AssetType GetType() const override { return AssetType::Texture; }
    bool Load(const std::string& path) override;
    void Unload() override;
    
private:
    // Texture data would go here
};

// Sound asset (stub)
class SoundAsset : public Asset {
public:
    AssetType GetType() const override { return AssetType::Sound; }
    bool Load(const std::string& path) override;
    void Unload() override;
    
private:
    // Sound data would go here
};

// Asset Manager - manages all game assets
class AssetManager {
public:
    AssetManager();
    ~AssetManager();
    
    // Set base directory for assets
    void SetAssetDirectory(const std::string& dir);
    
    // Load an asset
    bool LoadAsset(const std::string& name, const std::string& path, AssetType type);
    
    // Get an asset by name
    Asset* GetAsset(const std::string& name);
    
    // Unload a specific asset
    void UnloadAsset(const std::string& name);
    
    // Unload all assets
    void UnloadAll();
    
    // Load assets from a configuration file
    bool LoadAssetsFromConfig(const std::string& configPath);
    
private:
    std::string m_assetDirectory;
    std::map<std::string, std::unique_ptr<Asset>> m_assets;
};

} // namespace Itchio2D
