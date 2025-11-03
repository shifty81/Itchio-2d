#include "AssetManager.h"
#include <iostream>
#include <fstream>

namespace Itchio2D {

// TextureAsset implementation
bool TextureAsset::Load(const std::string& path) {
    std::cout << "Loading texture: " << path << std::endl;
    // Stub: In a real implementation, use stb_image or similar
    return true;
}

void TextureAsset::Unload() {
    std::cout << "Unloading texture" << std::endl;
}

// SoundAsset implementation
bool SoundAsset::Load(const std::string& path) {
    std::cout << "Loading sound: " << path << std::endl;
    // Stub: In a real implementation, use a sound library
    return true;
}

void SoundAsset::Unload() {
    std::cout << "Unloading sound" << std::endl;
}

// AssetManager implementation
AssetManager::AssetManager() {}

AssetManager::~AssetManager() {
    UnloadAll();
}

void AssetManager::SetAssetDirectory(const std::string& dir) {
    m_assetDirectory = dir;
}

bool AssetManager::LoadAsset(const std::string& name, const std::string& path, AssetType type) {
    std::unique_ptr<Asset> asset;
    
    switch (type) {
        case AssetType::Texture:
            asset = std::make_unique<TextureAsset>();
            break;
        case AssetType::Sound:
            asset = std::make_unique<SoundAsset>();
            break;
        default:
            std::cerr << "Unsupported asset type" << std::endl;
            return false;
    }
    
    std::string fullPath = m_assetDirectory + "/" + path;
    if (!asset->Load(fullPath)) {
        std::cerr << "Failed to load asset: " << name << " from " << fullPath << std::endl;
        return false;
    }
    
    m_assets[name] = std::move(asset);
    return true;
}

Asset* AssetManager::GetAsset(const std::string& name) {
    auto it = m_assets.find(name);
    if (it != m_assets.end()) {
        return it->second.get();
    }
    return nullptr;
}

void AssetManager::UnloadAsset(const std::string& name) {
    auto it = m_assets.find(name);
    if (it != m_assets.end()) {
        it->second->Unload();
        m_assets.erase(it);
    }
}

void AssetManager::UnloadAll() {
    for (auto& pair : m_assets) {
        pair.second->Unload();
    }
    m_assets.clear();
}

bool AssetManager::LoadAssetsFromConfig(const std::string& configPath) {
    std::cout << "Loading assets from config: " << configPath << std::endl;
    // Stub: In a real implementation, parse JSON/XML config file
    // For now, just return true
    return true;
}

} // namespace Itchio2D
