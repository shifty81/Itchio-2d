# Project Zomboid Modding Guide - Creating "The Infection"

This guide walks through creating the total conversion mod from scratch, covering all aspects from initial setup to advanced implementation.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setting Up Your Modding Environment](#setting-up-your-modding-environment)
3. [Mod Folder Structure](#mod-folder-structure)
4. [Creating the mod.info File](#creating-the-modinfo-file)
5. [Basic Lua Scripting Setup](#basic-lua-scripting-setup)
6. [Implementing Core Features](#implementing-core-features)
7. [Testing Your Mod](#testing-your-mod)
8. [Publishing to Steam Workshop](#publishing-to-steam-workshop)

---

## Prerequisites

### Required Knowledge
- Basic Lua programming
- Understanding of Project Zomboid gameplay mechanics
- Familiarity with text editors (VS Code, Notepad++, etc.)
- Basic understanding of file systems and directory structures

### Required Software
- Project Zomboid (Build 41 or Build 42)
- Text editor with Lua syntax highlighting
- (Optional) Git for version control
- (Optional) Lua language server for autocomplete

### Recommended Resources
- [PZwiki Modding Guide](https://pzwiki.net/wiki/Modding)
- [Project Zomboid Lua API Documentation](https://pzwiki.net/wiki/Lua_(API))
- [Indie Stone Forums - Modding Section](https://theindiestone.com/forums/index.php?/forum/45-pz-modding/)
- [Project Zomboid Lua Events Reference](https://pzwiki.net/wiki/Lua_event)

---

## Setting Up Your Modding Environment

### Step 1: Locate Your Project Zomboid Folders

**Windows**:
```
User Folder: C:\Users\[YourName]\Zomboid\
Game Installation: C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\
```

**Linux**:
```
User Folder: ~/.local/share/Zomboid/
Game Installation: ~/.steam/steam/SteamApps/common/ProjectZomboid/
```

**Mac**:
```
User Folder: ~/Library/Application Support/Zomboid/
Game Installation: ~/Library/Application Support/Steam/steamapps/common/ProjectZomboid/
```

### Step 2: Create Your Mod Directory

Navigate to your user Zomboid folder and create the mod structure:

```
C:\Users\[YourName]\Zomboid\
└── mods\
    └── TheInfection\
        └── media\
```

**Note**: For testing, use the `mods` folder. For Steam Workshop uploads, you'll use the `Workshop` folder instead.

### Step 3: Enable Developer Mode

1. Launch Project Zomboid
2. Go to Options > Display
3. Enable "Debug Mode"
4. Restart the game

This enables console commands and debug overlays useful for testing.

---

## Mod Folder Structure

Create the following directory structure for "The Infection" mod:

```
TheInfection/
├── mod.info                          # Mod metadata
├── poster.png                        # 512x512 mod thumbnail
├── icon.png                          # 64x64 mod icon
└── media/
    ├── lua/
    │   ├── client/
    │   │   ├── InfectionClient.lua       # Client-side initialization
    │   │   ├── InfectionUI.lua           # UI elements (timer display)
    │   │   └── InfectionCommands.lua     # Client commands
    │   ├── server/
    │   │   ├── InfectionServer.lua       # Server-side logic
    │   │   ├── InfectionTimer.lua        # Timer management
    │   │   ├── ZombieRemoval.lua         # Zombie removal system
    │   │   ├── SpawnController.lua       # Post-infection spawning
    │   │   └── WallAttackAI.lua          # Wall-bashing behavior
    │   └── shared/
    │       ├── InfectionConfig.lua       # Configuration values
    │       └── InfectionUtils.lua        # Shared utility functions
    ├── scripts/
    │   └── items/                    # Custom items (if needed)
    ├── textures/
    │   └── ui/                       # UI textures
    └── sounds/                       # Custom sounds (optional)
```

### Folder Purposes

- **lua/client/**: Code that runs only on the client (UI, local commands)
- **lua/server/**: Code that runs only on the server (spawn logic, world state)
- **lua/shared/**: Code that runs on both client and server (configuration, utilities)
- **scripts/**: Item definitions, recipe scripts
- **textures/**: Images and icons
- **sounds/**: Audio files

---

## Creating the mod.info File

Create `mod.info` in the root of your mod folder:

```ini
name=The Infection
id=TheInfection
description=A total conversion mod that removes zombies until a catastrophic Infection Event occurs. Prepare your defenses and survive the siege!
poster=poster.png
icon=icon.png
url=https://github.com/yourusername/the-infection
modversion=1.0.0
pzversion=41.78
```

### Field Explanations

- **name**: Display name shown in-game
- **id**: Unique identifier (no spaces, use for code references)
- **description**: Brief description for mod menu
- **poster**: 512x512 PNG preview image
- **icon**: 64x64 PNG icon
- **url**: Optional link to your mod page/repository
- **modversion**: Your mod's version number
- **pzversion**: Minimum Project Zomboid version required

---

## Basic Lua Scripting Setup

### Creating the Configuration File

Create `media/lua/shared/InfectionConfig.lua`:

```lua
-- The Infection - Configuration
InfectionConfig = InfectionConfig or {}

-- Timer Settings
InfectionConfig.TimerEnabled = true
InfectionConfig.DaysUntilInfection = 7  -- Default: 7 in-game days
InfectionConfig.ShowUITimer = true      -- Display countdown on screen

-- Zombie Settings
InfectionConfig.RemoveZombiesPreInfection = true
InfectionConfig.DisableZombieRespawn = true

-- Post-Infection Spawning
InfectionConfig.PostInfectionSpawnMultiplier = 2.0
InfectionConfig.WaveIntervalMinutes = 30
InfectionConfig.InitialWaveSize = 50

-- Wall Attack Settings
InfectionConfig.ZombiesAttackWalls = true
InfectionConfig.WallDamageMultiplier = 1.0
InfectionConfig.AttackRadius = 50  -- Tiles from player base

-- Safe Zone Settings
InfectionConfig.SafeZoneEnabled = true
InfectionConfig.MinWallHeight = 1  -- Minimum wall height for protection
InfectionConfig.RequireFullEnclosure = true

-- Debug Settings
InfectionConfig.DebugMode = false
InfectionConfig.DebugTimerMultiplier = 1.0  -- Speed up time for testing

return InfectionConfig
```

### Creating Shared Utilities

Create `media/lua/shared/InfectionUtils.lua`:

```lua
-- The Infection - Utility Functions
InfectionUtils = InfectionUtils or {}

-- Debug logging function
function InfectionUtils.log(message)
    if InfectionConfig.DebugMode then
        print("[The Infection] " .. tostring(message))
    end
end

-- Get mod data for a player
function InfectionUtils.getPlayerModData(player)
    if not player then return nil end
    local modData = player:getModData()
    if not modData.TheInfection then
        modData.TheInfection = {
            infectionTriggered = false,
            timerStartTime = 0,
            baseLocations = {}
        }
    end
    return modData.TheInfection
end

-- Get global mod data
function InfectionUtils.getGlobalModData()
    local modData = ModData.getOrCreate("TheInfection")
    if not modData.initialized then
        modData.initialized = true
        modData.infectionTriggered = false
        modData.gameStartTime = 0
        modData.infectionTime = 0
    end
    return modData
end

-- Convert days to game hours
function InfectionUtils.daysToHours(days)
    return days * 24
end

-- Get current game time in hours
function InfectionUtils.getGameTimeHours()
    local gameTime = getGameTime()
    return gameTime:getWorldAgeHours()
end

-- Check if infection has triggered
function InfectionUtils.isInfectionTriggered()
    local modData = InfectionUtils.getGlobalModData()
    return modData.infectionTriggered
end

-- Trigger the infection event
function InfectionUtils.triggerInfection()
    local modData = InfectionUtils.getGlobalModData()
    if not modData.infectionTriggered then
        modData.infectionTriggered = true
        modData.infectionTime = InfectionUtils.getGameTimeHours()
        InfectionUtils.log("Infection Event triggered at " .. modData.infectionTime .. " hours")
        return true
    end
    return false
end

return InfectionUtils
```

---

## Implementing Core Features

### Feature 1: Zombie Removal System

Create `media/lua/server/ZombieRemoval.lua`:

```lua
-- The Infection - Zombie Removal System
require "InfectionConfig"
require "InfectionUtils"

ZombieRemoval = ZombieRemoval or {}

-- Remove all zombies from the map
function ZombieRemoval.removeAllZombies()
    InfectionUtils.log("Removing all zombies from the map...")
    
    local count = 0
    local cell = getCell()
    
    -- Get all zombies in loaded cells
    for x = 0, cell:getMaxX() do
        for y = 0, cell:getMaxY() do
            local square = cell:getGridSquare(x, y, 0)
            if square then
                local objects = square:getObjects()
                for i = 0, objects:size() - 1 do
                    local obj = objects:get(i)
                    if instanceof(obj, "IsoZombie") then
                        obj:removeFromWorld()
                        obj:removeFromSquare()
                        count = count + 1
                    end
                end
            end
        end
    end
    
    InfectionUtils.log("Removed " .. count .. " zombies")
end

-- Monitor and remove zombies that spawn during pre-infection phase
function ZombieRemoval.onZombieUpdate(zombie)
    if not InfectionConfig.RemoveZombiesPreInfection then
        return
    end
    
    -- Only remove if infection hasn't triggered yet
    if not InfectionUtils.isInfectionTriggered() then
        zombie:removeFromWorld()
        zombie:removeFromSquare()
    end
end

-- Initialize zombie removal on game start
function ZombieRemoval.onGameStart()
    InfectionUtils.log("ZombieRemoval: Game started")
    
    if InfectionConfig.RemoveZombiesPreInfection then
        ZombieRemoval.removeAllZombies()
    end
end

-- Set zombie population to zero before infection
function ZombieRemoval.adjustSandboxSettings()
    if not InfectionUtils.isInfectionTriggered() then
        local sandbox = getSandboxOptions()
        if sandbox then
            -- Store original settings
            if not ZombieRemoval.originalSettings then
                ZombieRemoval.originalSettings = {
                    zombiePopulation = sandbox:getOptionByName("ZombieCount"):getValue(),
                    zombieRespawn = sandbox:getOptionByName("Respawn"):getValue()
                }
            end
            
            -- Set to zero during pre-infection
            sandbox:set("ZombieCount", 0)
            sandbox:set("Respawn", 0)
        end
    end
end

-- Restore zombie settings after infection
function ZombieRemoval.restoreSandboxSettings()
    if ZombieRemoval.originalSettings then
        local sandbox = getSandboxOptions()
        if sandbox then
            sandbox:set("ZombieCount", ZombieRemoval.originalSettings.zombiePopulation)
            sandbox:set("Respawn", ZombieRemoval.originalSettings.zombieRespawn)
            InfectionUtils.log("Restored sandbox settings")
        end
    end
end

-- Hook into game events
Events.OnGameStart.Add(ZombieRemoval.onGameStart)
Events.OnZombieUpdate.Add(ZombieRemoval.onZombieUpdate)

return ZombieRemoval
```

### Feature 2: Infection Timer System

Create `media/lua/server/InfectionTimer.lua`:

```lua
-- The Infection - Timer System
require "InfectionConfig"
require "InfectionUtils"

InfectionTimer = InfectionTimer or {}

-- Initialize timer when game starts
function InfectionTimer.initialize()
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.gameStartTime == 0 then
        modData.gameStartTime = InfectionUtils.getGameTimeHours()
        modData.infectionTime = modData.gameStartTime + InfectionUtils.daysToHours(InfectionConfig.DaysUntilInfection)
        InfectionUtils.log("Timer initialized. Infection will occur at " .. modData.infectionTime .. " hours")
    end
end

-- Get time remaining until infection (in hours)
function InfectionTimer.getTimeRemaining()
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.infectionTriggered then
        return 0
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local remaining = modData.infectionTime - currentTime
    
    return math.max(0, remaining)
end

-- Check if it's time to trigger infection
function InfectionTimer.checkInfection()
    if InfectionUtils.isInfectionTriggered() then
        return
    end
    
    local remaining = InfectionTimer.getTimeRemaining()
    
    if remaining <= 0 then
        InfectionTimer.triggerInfection()
    else
        -- Send warnings at specific intervals
        InfectionTimer.checkWarnings(remaining)
    end
end

-- Send warning messages to players
function InfectionTimer.checkWarnings(hoursRemaining)
    local modData = InfectionUtils.getGlobalModData()
    
    -- Warning thresholds in hours
    local warnings = {
        {hours = 72, message = "3 days until the Infection Event", key = "warning_3days"},
        {hours = 24, message = "24 hours until the Infection Event", key = "warning_1day"},
        {hours = 6, message = "6 hours until the Infection Event!", key = "warning_6hours"},
        {hours = 1, message = "1 hour until the Infection Event!!", key = "warning_1hour"}
    }
    
    for _, warning in ipairs(warnings) do
        if hoursRemaining <= warning.hours and not modData[warning.key] then
            modData[warning.key] = true
            
            -- Send message to all players
            local players = getOnlinePlayers()
            for i = 0, players:size() - 1 do
                local player = players:get(i)
                player:Say(warning.message)
            end
            
            InfectionUtils.log("Warning sent: " .. warning.message)
        end
    end
end

-- Trigger the infection event
function InfectionTimer.triggerInfection()
    InfectionUtils.log("Triggering Infection Event!")
    
    if InfectionUtils.triggerInfection() then
        -- Notify all players
        local players = getOnlinePlayers()
        for i = 0, players:size() - 1 do
            local player = players:get(i)
            player:Say("THE INFECTION HAS BEGUN!")
        end
        
        -- Restore zombie spawning
        require "ZombieRemoval"
        ZombieRemoval.restoreSandboxSettings()
        
        -- Activate spawn controller
        require "SpawnController"
        SpawnController.activate()
    end
end

-- Update every 10 minutes
function InfectionTimer.everyTenMinutes()
    if InfectionConfig.TimerEnabled then
        InfectionTimer.checkInfection()
    end
end

-- Initialize on game start
function InfectionTimer.onGameStart()
    InfectionUtils.log("InfectionTimer: Initializing...")
    InfectionTimer.initialize()
end

-- Hook into game events
Events.OnGameStart.Add(InfectionTimer.onGameStart)
Events.EveryTenMinutes.Add(InfectionTimer.everyTenMinutes)

return InfectionTimer
```

### Feature 3: Post-Infection Spawn Controller

Create `media/lua/server/SpawnController.lua`:

```lua
-- The Infection - Spawn Controller
require "InfectionConfig"
require "InfectionUtils"

SpawnController = SpawnController or {}
SpawnController.active = false
SpawnController.nextWaveTime = 0
SpawnController.waveNumber = 0

-- Activate spawn controller after infection
function SpawnController.activate()
    SpawnController.active = true
    SpawnController.nextWaveTime = InfectionUtils.getGameTimeHours()
    InfectionUtils.log("Spawn Controller activated")
end

-- Spawn a wave of zombies around player bases
function SpawnController.spawnWave()
    if not SpawnController.active then
        return
    end
    
    SpawnController.waveNumber = SpawnController.waveNumber + 1
    local waveSize = InfectionConfig.InitialWaveSize * InfectionConfig.PostInfectionSpawnMultiplier
    
    InfectionUtils.log("Spawning wave #" .. SpawnController.waveNumber .. " (" .. waveSize .. " zombies)")
    
    local players = getOnlinePlayers()
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        SpawnController.spawnAroundPlayer(player, waveSize / players:size())
    end
end

-- Spawn zombies around a specific player
function SpawnController.spawnAroundPlayer(player, count)
    if not player then return end
    
    local playerX = player:getX()
    local playerY = player:getY()
    local playerZ = player:getZ()
    local radius = InfectionConfig.AttackRadius
    
    for i = 1, count do
        -- Random angle and distance
        local angle = ZombRand(360) * math.pi / 180
        local distance = radius + ZombRand(20)
        
        local spawnX = playerX + math.cos(angle) * distance
        local spawnY = playerY + math.sin(angle) * distance
        
        -- Spawn zombie
        local cell = getCell()
        local square = cell:getGridSquare(spawnX, spawnY, playerZ)
        
        if square and not SpawnController.isInSafeZone(spawnX, spawnY) then
            local zombie = addZombiesInOutfit(spawnX, spawnY, playerZ, 1, "Naked", 0, false, false, false, false, 1.0)
            
            -- Make zombie aggressive and target player structures
            if zombie then
                -- Additional configuration for zombie behavior can be added here
            end
        end
    end
end

-- Check if coordinates are in a safe zone
function SpawnController.isInSafeZone(x, y)
    if not InfectionConfig.SafeZoneEnabled then
        return false
    end
    
    -- This is a placeholder - implement actual safe zone detection
    -- based on player-built walls
    return false
end

-- Check if it's time for next wave
function SpawnController.checkWaveTimer()
    if not SpawnController.active then
        return
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local waveInterval = InfectionConfig.WaveIntervalMinutes / 60  -- Convert to hours
    
    if currentTime >= SpawnController.nextWaveTime then
        SpawnController.spawnWave()
        SpawnController.nextWaveTime = currentTime + waveInterval
    end
end

-- Update every 10 minutes
function SpawnController.everyTenMinutes()
    SpawnController.checkWaveTimer()
end

-- Hook into game events
Events.EveryTenMinutes.Add(SpawnController.everyTenMinutes)

return SpawnController
```

### Feature 4: Client-Side UI Timer

Create `media/lua/client/InfectionUI.lua`:

```lua
-- The Infection - UI Timer Display
require "ISUI/ISPanel"
require "InfectionConfig"
require "InfectionUtils"

InfectionUI = ISPanel:derive("InfectionUI")

-- Constructor
function InfectionUI:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor.a = 0.0  -- Transparent background
    return o
end

-- Initialize UI
function InfectionUI:initialise()
    ISPanel.initialise(self)
end

-- Render the timer
function InfectionUI:render()
    if not InfectionConfig.ShowUITimer then
        return
    end
    
    -- Request time remaining from server
    local timeRemaining = InfectionUI.getTimeRemaining()
    
    if timeRemaining > 0 then
        local days = math.floor(timeRemaining / 24)
        local hours = math.floor(timeRemaining % 24)
        local minutes = math.floor((timeRemaining % 1) * 60)
        
        local text = string.format("Infection in: %dd %dh %dm", days, hours, minutes)
        
        -- Draw text
        self:drawText(text, 10, 10, 1, 0, 0, 1, UIFont.Medium)
    else
        -- Infection has occurred
        if InfectionUtils.isInfectionTriggered() then
            self:drawText("THE INFECTION IS ACTIVE", 10, 10, 1, 0, 0, 1, UIFont.Medium)
        end
    end
end

-- Get time remaining (this should sync with server)
function InfectionUI.getTimeRemaining()
    -- In a full implementation, this would use client-server communication
    -- For now, use local calculation
    local modData = InfectionUtils.getGlobalModData()
    
    if modData.infectionTriggered then
        return 0
    end
    
    local currentTime = InfectionUtils.getGameTimeHours()
    local remaining = modData.infectionTime - currentTime
    
    return math.max(0, remaining)
end

-- Create and add UI to screen
function InfectionUI.createUI()
    if InfectionConfig.ShowUITimer then
        local ui = InfectionUI:new(10, 10, 300, 50)
        ui:initialise()
        ui:addToUIManager()
        InfectionUI.instance = ui
    end
end

-- Initialize on game start
Events.OnGameStart.Add(InfectionUI.createUI)

return InfectionUI
```

---

## Testing Your Mod

### Step 1: Enable the Mod

1. Copy your mod folder to: `C:\Users\[YourName]\Zomboid\mods\`
2. Launch Project Zomboid
3. Go to: Main Menu > Mods
4. Find "The Infection" and check the box
5. Click "Done"

### Step 2: Create a Test World

1. Start a new game (Solo > Sandbox)
2. Configure difficulty settings
3. Start the game and verify:
   - No zombies spawn initially
   - Timer appears on screen (if UI enabled)
   - Console shows debug messages (if debug mode enabled)

### Step 3: Debug Console Commands

Open the debug console (default: Tab key) and use these commands:

```lua
-- Check infection status
/lua print(InfectionUtils.isInfectionTriggered())

-- Force trigger infection
/lua require "InfectionTimer"; InfectionTimer.triggerInfection()

-- Check time remaining
/lua require "InfectionTimer"; print(InfectionTimer.getTimeRemaining())

-- Spawn test wave
/lua require "SpawnController"; SpawnController.spawnWave()
```

### Step 4: Common Issues and Solutions

**Issue**: Mod doesn't appear in mod menu
- **Solution**: Check mod.info file format, ensure no syntax errors

**Issue**: Zombies still spawning during pre-infection
- **Solution**: Verify ZombieRemoval.lua is being loaded, check sandbox settings

**Issue**: Timer not counting down
- **Solution**: Check Events.EveryTenMinutes is hooked properly, verify modData initialization

**Issue**: Lua errors in console
- **Solution**: Check syntax, ensure all `require` statements are correct, verify file paths

---

## Publishing to Steam Workshop

### Step 1: Prepare for Upload

1. Move your mod to the Workshop folder:
   ```
   C:\Users\[YourName]\Zomboid\Workshop\
   ```

2. Ensure you have:
   - Valid mod.info file
   - poster.png (512x512)
   - icon.png (64x64)
   - All Lua files tested and working

### Step 2: Use In-Game Uploader

1. Launch Project Zomboid
2. Go to: Main Menu > Workshop > Create Item
3. Select your mod folder
4. Fill in:
   - Title
   - Description
   - Tags (Gameplay, Server, Map)
   - Visibility (Public/Unlisted/Private)
5. Click "Upload"

### Step 3: Update Your Workshop Page

After upload, visit your Steam Workshop page and:
- Add detailed description
- Upload screenshots/videos
- List dependencies (if any)
- Add changelog for updates

---

## Advanced Topics

### Multiplayer Synchronization

For multiplayer, ensure:
- Server-side logic handles authoritative state
- Client-side UI syncs with server data
- Use `sendClientCommand()` and `sendServerCommand()` for communication

Example server command:

```lua
-- Server side
function InfectionTimer.onClientCommand(module, command, player, args)
    if module == "TheInfection" then
        if command == "RequestTimeRemaining" then
            local remaining = InfectionTimer.getTimeRemaining()
            sendServerCommand(player, module, "TimeRemainingResponse", {time = remaining})
        end
    end
end

Events.OnClientCommand.Add(InfectionTimer.onClientCommand)
```

Example client request:

```lua
-- Client side
function InfectionUI.requestTimeRemaining()
    sendClientCommand("TheInfection", "RequestTimeRemaining", {})
end

function InfectionUI.onServerCommand(module, command, args)
    if module == "TheInfection" then
        if command == "TimeRemainingResponse" then
            InfectionUI.serverTimeRemaining = args.time
        end
    end
end

Events.OnServerCommand.Add(InfectionUI.onServerCommand)
```

### Performance Optimization

- Use spawn pooling for large waves
- Limit zombie updates with update intervals
- Cache frequently accessed mod data
- Use spatial partitioning for safe zone checks

### Mod Compatibility

Create a compatibility layer in `InfectionConfig.lua`:

```lua
-- Check for mod compatibility
function InfectionConfig.checkCompatibility()
    -- Check for conflicting mods
    if getActivatedMods():contains("ConflictingModID") then
        InfectionConfig.DisableFeatureX = true
    end
end
```

---

## Next Steps

1. Implement wall detection for safe zones
2. Add wall-bashing AI behavior
3. Create special infected variants
4. Add sound effects and visual polish
5. Balance testing with players
6. Gather feedback and iterate

## Conclusion

You now have a complete guide to creating "The Infection" mod for Project Zomboid. Start with the basic systems, test thoroughly, and gradually add more complex features. Join the modding community for support and share your progress!

For more information, see:
- [TECHNICAL_IMPLEMENTATION.md](TECHNICAL_IMPLEMENTATION.md) - Detailed code examples
- [RESOURCES.md](RESOURCES.md) - Links to additional documentation
