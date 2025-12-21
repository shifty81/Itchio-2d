# Quick Start Guide - The Infection Mod

Get started creating "The Infection" mod in 30 minutes or less.

## Overview

This guide will help you:
1. Set up your modding environment (5 min)
2. Create the basic mod structure (5 min)
3. Implement core zombie removal (10 min)
4. Add basic infection timer (10 min)

## Prerequisites

- Project Zomboid installed
- Text editor (VS Code recommended)
- Basic understanding of Lua syntax

## Step 1: Environment Setup (5 minutes)

### 1.1 Find Your Zomboid Folder

**Windows**: `C:\Users\[YourName]\Zomboid\`

Open this folder and verify you see:
- `mods\` folder (create if doesn't exist)
- `Saves\` folder
- `Lua\` folder

### 1.2 Enable Debug Mode

1. Launch Project Zomboid
2. Go to: **Options > Display**
3. Check **"Enable Debug Mode"**
4. Restart game

### 1.3 Create Mod Folder

Create: `C:\Users\[YourName]\Zomboid\mods\TheInfection\`

## Step 2: Basic Structure (5 minutes)

### 2.1 Create mod.info

In `TheInfection\` folder, create `mod.info`:

```ini
name=The Infection - Quick Start
id=TheInfectionQuickStart
description=Basic implementation of infection timer and zombie removal
modversion=0.1.0
pzversion=41.78
```

### 2.2 Create Folder Structure

Create these folders:
```
TheInfection\
└── media\
    └── lua\
        ├── client\
        ├── server\
        └── shared\
```

## Step 3: Zombie Removal (10 minutes)

### 3.1 Create Configuration

File: `media\lua\shared\InfectionConfig.lua`

```lua
InfectionConfig = {
    DaysUntilInfection = 7,
    RemoveZombies = true,
    DebugMode = true
}
```

### 3.2 Create Utilities

File: `media\lua\shared\InfectionUtils.lua`

```lua
InfectionUtils = {}

function InfectionUtils.log(msg)
    if InfectionConfig.DebugMode then
        print("[TheInfection] " .. tostring(msg))
    end
end

function InfectionUtils.getModData()
    local data = ModData.getOrCreate("TheInfection")
    if not data.initialized then
        data.initialized = true
        data.infectionTriggered = false
        data.startTime = 0
    end
    return data
end

function InfectionUtils.getGameHours()
    return getGameTime():getWorldAgeHours()
end
```

### 3.3 Create Zombie Removal

File: `media\lua\server\ZombieRemoval.lua`

```lua
require "InfectionConfig"
require "InfectionUtils"

-- Remove all zombies on game start
local function onGameStart()
    if not InfectionConfig.RemoveZombies then return end
    
    InfectionUtils.log("Removing all zombies...")
    
    -- Set spawn to zero
    local sandbox = getSandboxOptions()
    if sandbox then
        sandbox:set("ZombieCount", 0)
        sandbox:set("Respawn", 0)
    end
    
    InfectionUtils.log("Zombie spawning disabled")
end

-- Remove any zombies that spawn
local function onZombieUpdate(zombie)
    if InfectionConfig.RemoveZombies then
        local modData = InfectionUtils.getModData()
        if not modData.infectionTriggered then
            zombie:removeFromWorld()
            zombie:removeFromSquare()
        end
    end
end

Events.OnGameStart.Add(onGameStart)
Events.OnZombieUpdate.Add(onZombieUpdate)
```

### 3.4 Test Zombie Removal

1. Launch Project Zomboid
2. Go to: **Main Menu > Mods**
3. Enable **"The Infection - Quick Start"**
4. Start new game
5. Verify no zombies spawn

**Debug Console Check**:
- Press **Tab** to open console
- Type: `/lua print(InfectionConfig.RemoveZombies)`
- Should print: `true`

## Step 4: Infection Timer (10 minutes)

### 4.1 Create Timer System

File: `media\lua\server\InfectionTimer.lua`

```lua
require "InfectionConfig"
require "InfectionUtils"

InfectionTimer = {}

-- Initialize timer
function InfectionTimer.init()
    local modData = InfectionUtils.getModData()
    if modData.startTime == 0 then
        modData.startTime = InfectionUtils.getGameHours()
        InfectionUtils.log("Timer started at " .. modData.startTime)
    end
end

-- Get hours remaining
function InfectionTimer.getRemaining()
    local modData = InfectionUtils.getModData()
    if modData.infectionTriggered then return 0 end
    
    local current = InfectionUtils.getGameHours()
    local target = modData.startTime + (InfectionConfig.DaysUntilInfection * 24)
    return math.max(0, target - current)
end

-- Check if time to trigger
function InfectionTimer.check()
    if InfectionTimer.getRemaining() <= 0 then
        InfectionTimer.trigger()
    end
end

-- Trigger infection
function InfectionTimer.trigger()
    local modData = InfectionUtils.getModData()
    if not modData.infectionTriggered then
        modData.infectionTriggered = true
        InfectionUtils.log("INFECTION TRIGGERED!")
        
        -- Notify players
        local players = getOnlinePlayers()
        for i = 0, players:size() - 1 do
            players:get(i):Say("THE INFECTION HAS BEGUN!")
        end
        
        -- Re-enable zombies
        local sandbox = getSandboxOptions()
        if sandbox then
            sandbox:set("ZombieCount", 4)  -- Normal
            sandbox:set("Respawn", 1)      -- Enabled
        end
    end
end

-- Initialize on start
local function onGameStart()
    InfectionTimer.init()
end

-- Check every 10 minutes
local function everyTenMinutes()
    InfectionTimer.check()
end

Events.OnGameStart.Add(onGameStart)
Events.EveryTenMinutes.Add(everyTenMinutes)
```

### 4.2 Create UI Timer

File: `media\lua\client\InfectionUI.lua`

```lua
require "ISUI/ISPanel"

InfectionUI = ISPanel:derive("InfectionUI")

function InfectionUI:new()
    local o = ISPanel:new(10, 10, 300, 40)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor.a = 0
    return o
end

function InfectionUI:render()
    -- This is simplified - in full version, sync with server
    local modData = InfectionUtils.getModData()
    
    if not modData.infectionTriggered then
        local remaining = InfectionTimer.getRemaining()
        if remaining then
            local days = math.floor(remaining / 24)
            local hours = math.floor(remaining % 24)
            
            local text = string.format("Infection in: %d days, %d hours", days, hours)
            self:drawText(text, 10, 10, 1, 1, 1, 1, UIFont.Medium)
        end
    else
        self:drawText("INFECTION ACTIVE", 10, 10, 1, 0, 0, 1, UIFont.Large)
    end
end

-- Create UI on game start
local function createUI()
    local ui = InfectionUI:new()
    ui:initialise()
    ui:addToUIManager()
end

Events.OnGameStart.Add(createUI)
```

### 4.3 Test Timer System

1. Start new game with mod enabled
2. Check top-left corner for timer
3. Open console (Tab)
4. Check timer: `/lua print(InfectionTimer.getRemaining())`
5. Force trigger: `/lua InfectionTimer.trigger()`

## Testing Checklist

- [ ] Mod appears in mod menu
- [ ] No zombies spawn on new game
- [ ] Timer displays on screen
- [ ] Console shows debug messages
- [ ] Force trigger works
- [ ] Zombies spawn after trigger

## Common Issues

### Issue: Mod doesn't appear
**Fix**: Check mod.info file, ensure no syntax errors

### Issue: Zombies still spawning
**Fix**: Check sandbox settings set to 0, verify ZombieRemoval.lua loads

### Issue: No timer on screen
**Fix**: Verify InfectionUI.lua is in client folder, check for Lua errors in console

### Issue: Errors in console
**Fix**: Check for typos, ensure all `require` statements are correct

## Debug Commands

Open console (Tab) and try:

```lua
-- Check configuration
/lua print(InfectionConfig.DaysUntilInfection)

-- Check mod data
/lua local d = InfectionUtils.getModData(); print(d.infectionTriggered)

-- Get time remaining
/lua print(InfectionTimer.getRemaining())

-- Force trigger
/lua InfectionTimer.trigger()

-- Reset (requires reload)
/lua InfectionUtils.getModData().infectionTriggered = false
```

## Next Steps

You now have a working basic version! Enhance it with:

1. **Wave Spawning**: Add SpawnController.lua for post-infection waves
2. **Wall Detection**: Add SafeZoneDetector.lua for protected areas
3. **Wall Attacks**: Add WallAttackAI.lua for zombies attacking structures
4. **Polish**: Add sounds, better UI, configuration options

## Full Documentation

For complete implementation, see:
- [MODDING_GUIDE.md](MODDING_GUIDE.md) - Complete step-by-step guide
- [TECHNICAL_IMPLEMENTATION.md](TECHNICAL_IMPLEMENTATION.md) - Advanced features
- [MOD_OVERVIEW.md](MOD_OVERVIEW.md) - Design and gameplay details
- [RESOURCES.md](RESOURCES.md) - Links and references

## Getting Help

- **Console Errors**: Check for typos, missing files
- **Forums**: Post on Indie Stone forums
- **Discord**: Ask in Project Zomboid modding channels
- **GitHub**: Check example mods for reference

## Conclusion

Congratulations! You've created a working Project Zomboid mod in 30 minutes. This foundation can be expanded into the full "The Infection" experience with additional features and polish.

Happy modding!
