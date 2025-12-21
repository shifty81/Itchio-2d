# Project Zomboid Modding Resources

A comprehensive collection of resources for creating mods for Project Zomboid, specifically for "The Infection" total conversion mod.

## Official Documentation

### Primary Resources

1. **PZwiki - Modding Portal**
   - URL: https://pzwiki.net/wiki/Modding
   - Description: Official wiki with comprehensive modding guides
   - Topics: Getting started, mod structure, best practices

2. **PZwiki - Lua API Documentation**
   - URL: https://pzwiki.net/wiki/Lua_(API)
   - Description: Complete reference for Project Zomboid's Lua API
   - Topics: Classes, methods, exposed Java objects

3. **PZwiki - Lua Events Reference**
   - URL: https://pzwiki.net/wiki/Lua_event
   - Description: List of all available event hooks
   - Topics: OnGameStart, OnZombieUpdate, OnPlayerUpdate, etc.

4. **PZwiki - Getting Started with Modding**
   - URL: https://pzwiki.net/wiki/Getting_started_with_modding
   - Description: Beginner-friendly introduction to modding
   - Topics: Setup, basic scripts, testing

5. **Project Zomboid LuaDocs (Auto-generated)**
   - URL: https://demiurgequantified.github.io/ProjectZomboidLuaDocs/
   - Description: Automatically generated documentation from game code
   - Topics: Class definitions, method signatures, events

### Advanced Documentation

6. **Events Plus API**
   - URL: https://pzwiki.net/wiki/Events_Plus_API
   - Description: Extended event system for more granular hooks
   - Topics: OnActionCreated, OnMedicalStatus, custom events

7. **Mod Structure Guide**
   - URL: https://pzwiki.net/wiki/Mod_structure
   - Description: Detailed explanation of mod folder structure
   - Topics: Directory layout, file naming, organization

8. **Scripting Guide**
   - URL: https://pzwiki.net/wiki/Scripting
   - Description: How to create item and recipe scripts
   - Topics: Item definitions, recipes, distributions

## Community Resources

### Forums and Communities

9. **The Indie Stone Forums - PZ Modding**
   - URL: https://theindiestone.com/forums/index.php?/forum/45-pz-modding/
   - Description: Official modding forum
   - Use for: Questions, troubleshooting, sharing mods

10. **The Indie Stone Forums - Lua Events Reference Thread**
    - URL: https://theindiestone.com/forums/index.php?/topic/23313-reference-list-of-lua-events/
    - Description: Community-maintained list of Lua events
    - Use for: Finding event hooks, examples

11. **Project Zomboid Discord - Modding Channel**
    - Description: Real-time chat with modders
    - Use for: Quick questions, collaboration

12. **Reddit - /r/projectzomboid**
    - URL: https://www.reddit.com/r/projectzomboid/
    - Description: Community discussions, mod showcases
    - Use for: Feedback, inspiration, announcements

### GitHub Repositories

13. **Zomboid-Modding-Guide by FWolfe**
    - URL: https://github.com/FWolfe/Zomboid-Modding-Guide
    - Description: Comprehensive GitHub-based modding guide
    - Topics: API reference, examples, tutorials

14. **Project Zomboid Community Modding - PZNS**
    - URL: https://github.com/Project-Zomboid-Community-Modding/PZNS
    - Description: NPC spawning framework
    - Use for: NPC/zombie spawning systems

15. **Exterminator Mod (Example)**
    - URL: https://github.com/Kapanther/PZMOD-Exterminator
    - Description: Open-source mod for zombie removal
    - Use for: Reference implementation, learning

16. **PZ-Mod Documentation by MrBounty**
    - URL: https://github.com/MrBounty/PZ-Mod---Doc
    - Description: Community documentation and examples
    - Topics: Event logic, practical examples

## Video Tutorials

### YouTube Channels and Playlists

17. **Modding Project Zomboid - Beginner Tutorial Series**
    - URL: https://www.youtube.com/playlist?list=PLLb94Sl64VORCO_tnApZ8H0TgNXTxzm8l
    - Description: Step-by-step video tutorial series
    - Topics: Setup, basic items, Lua scripting

18. **The Indie Stone YouTube Channel**
    - Description: Official channel with dev updates
    - Use for: Understanding game mechanics, feature previews

## Steam Guides

19. **B42 - How to Create a Mod**
    - URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3468930730
    - Description: Build 42 mod creation guide
    - Topics: Modern modding practices, B42 changes

20. **Modding 101: Add Items**
    - URL: https://steamcommunity.com/sharedfiles/filedetails/?id=3006109377
    - Description: Beginner guide for adding items
    - Topics: Item scripts, textures, integration

## Tools and Utilities

### Development Tools

21. **Visual Studio Code**
    - URL: https://code.visualstudio.com/
    - Description: Recommended text editor
    - Extensions: Lua Language Server, Lua Debug

22. **Lua Language Server**
    - URL: https://github.com/LuaLS/lua-language-server
    - Description: Autocomplete and linting for Lua
    - Use for: Better development experience

23. **TileZed (Map Editor)**
    - Description: Official Project Zomboid map editor
    - Location: In Project Zomboid install folder
    - Use for: Creating custom maps

24. **WorldEd (World Editor)**
    - Description: World and lot editing tool
    - Location: In Project Zomboid install folder
    - Use for: Placing buildings, managing world layout

### Debugging Tools

25. **Debug Mode in Project Zomboid**
    - Enable: Options > Display > Debug Mode
    - Use for: Console commands, debug overlays, testing

26. **Lua Console Commands**
    - Access: Tab key (default) in-game
    - Use for: Testing scripts, spawning items/zombies

## Specific to "The Infection" Mod

### Zombie Spawning and Control

27. **Zombie Spawning Mechanics**
    - Reference: PZwiki Lua API - IsoZombie class
    - Topics: addZombiesInOutfit, spawn parameters

28. **Sandbox Options Manipulation**
    - Reference: getSandboxOptions() method
    - Topics: PopulationMultiplier, ZombieRespawn

### Timer Systems

29. **Game Time Management**
    - Reference: getGameTime() API
    - Topics: getWorldAgeHours, time tracking

30. **Timed Events**
    - Reference: Events.EveryTenMinutes, Events.EveryHours
    - Topics: Periodic updates, scheduling

### Wall and Building Detection

31. **Building Detection APIs**
    - Reference: IsoGridSquare methods
    - Topics: HaveWall(), getDoor(), getWindow()

32. **Thumpable Objects**
    - Reference: IsoThumpable class
    - Topics: Player-built structures, damage application

### UI Development

33. **ISUI Framework**
    - Reference: ISUI/ISPanel, ISUI/ISButton
    - Topics: Creating UI elements, rendering

34. **UI Rendering**
    - Methods: drawText(), drawRect(), drawTexture()
    - Topics: Custom overlays, HUD elements

### Multiplayer Networking

35. **Client-Server Communication**
    - Methods: sendClientCommand(), sendServerCommand()
    - Topics: Data synchronization, multiplayer support

36. **ModData System**
    - Methods: ModData.getOrCreate(), player:getModData()
    - Topics: Persistent data, save/load

## Example Mods for Reference

### Open-Source Mods to Study

37. **Hydrocraft** (Complex Systems)
    - Description: Massive mod with extensive systems
    - Learn: Complex item systems, recipes, integration

38. **Superb Survivors** (NPC Systems)
    - Description: NPC companion system
    - Learn: AI behavior, NPC management

39. **Build 41 Apocalypse** (Gameplay Changes)
    - Description: Difficulty modifications
    - Learn: Sandbox integration, balance

## Lua Programming Resources

### Learning Lua

40. **Programming in Lua (Book)**
    - URL: https://www.lua.org/pil/
    - Description: Official Lua programming guide
    - Topics: Language fundamentals, patterns

41. **Lua 5.1 Reference Manual**
    - URL: https://www.lua.org/manual/5.1/
    - Description: Language specification
    - Note: Project Zomboid uses Lua 5.1

42. **Learn Lua in 15 Minutes**
    - URL: https://tylerneylon.com/a/learn-lua/
    - Description: Quick Lua introduction
    - Use for: Syntax refresher, basics

## Performance and Optimization

### Best Practices

43. **Lua Performance Tips**
    - Topics: Table pooling, local variables, update throttling
    - Reference: Lua optimization guides

44. **Project Zomboid Performance Considerations**
    - Topics: Entity limits, chunk loading, memory management
    - Reference: Forum discussions, dev blogs

## Testing and Debugging

### Testing Strategies

45. **Local Testing Workflow**
    - Setup: Use mods folder for quick iteration
    - Tools: Debug mode, console commands

46. **Multiplayer Testing**
    - Setup: Local dedicated server
    - Tools: Multiple clients, stress testing

### Common Issues and Solutions

47. **Troubleshooting Guide**
    - Common errors: Nil values, syntax errors, event issues
    - Solutions: Check console, verify paths, test incrementally

## Publishing and Distribution

### Steam Workshop

48. **Steam Workshop Guidelines**
    - Requirements: Valid mod.info, icons, description
    - Process: In-game uploader tool

49. **Workshop Best Practices**
    - Tips: Clear description, screenshots, changelog
    - Maintenance: Regular updates, bug fixes

### Mod Compatibility

50. **Ensuring Compatibility**
    - Practices: Check for conflicts, use mod options
    - Testing: Test with popular mods

## Version-Specific Information

### Build 41 vs Build 42

51. **Build 41 Information**
    - Status: Current stable build
    - Features: Established API, extensive mods

52. **Build 42 Changes**
    - Status: Beta/upcoming
    - Changes: New features, API updates, craft system overhaul

## Additional Resources

### Texture and Asset Creation

53. **Creating Textures for Project Zomboid**
    - Formats: PNG, specific sizes
    - Tools: GIMP, Photoshop, Paint.NET

54. **Sound Design**
    - Formats: WAV, OGG
    - Topics: Sound events, audio integration

### Localization

55. **Multi-Language Support**
    - Files: Translate_XX.txt
    - Topics: String externalization, translations

## Quick Reference Cheat Sheet

### Common Lua API Calls

```lua
-- Get player
local player = getPlayer()

-- Get game time
local gameTime = getGameTime()
local hours = gameTime:getWorldAgeHours()

-- Get cell
local cell = getCell()

-- Get square
local square = cell:getGridSquare(x, y, z)

-- Spawn zombie
local zombie = addZombiesInOutfit(x, y, z, count, outfit, facing, crawler, female, skull, sprinter, speed)

-- Get sandbox options
local sandbox = getSandboxOptions()

-- Send player message
player:Say("Message")

-- Get mod data
local modData = ModData.getOrCreate("ModName")
local playerModData = player:getModData()

-- Server/client commands
sendClientCommand(player, module, command, args)
sendServerCommand(module, command, args)
```

### Common Events

```lua
Events.OnGameStart.Add(function() end)
Events.OnLoad.Add(function() end)
Events.OnSave.Add(function() end)
Events.OnPlayerDeath.Add(function(player) end)
Events.OnZombieUpdate.Add(function(zombie) end)
Events.OnPlayerUpdate.Add(function(player) end)
Events.EveryTenMinutes.Add(function() end)
Events.EveryHours.Add(function() end)
Events.OnClientCommand.Add(function(module, command, player, args) end)
Events.OnServerCommand.Add(function(module, command, args) end)
```

## Community and Support

### Getting Help

- **Forums**: Post detailed questions with error logs
- **Discord**: Quick questions, real-time troubleshooting
- **GitHub Issues**: Report mod-specific bugs
- **Reddit**: General discussion, showcase

### Contributing Back

- **Share Knowledge**: Write tutorials, answer questions
- **Open Source**: Share your mod code
- **Documentation**: Contribute to wikis and guides
- **Testing**: Help test other mods, provide feedback

## Conclusion

This resource collection provides everything needed to create "The Infection" mod and other Project Zomboid modifications. Bookmark these links, join the community, and don't hesitate to ask for help. The modding community is active and welcoming to newcomers.

Happy modding!
