# Map Modding and Asset Extraction Guide

This guide covers extracting and modifying Project Zomboid's base map and assets for use in "The Infection" mod.

## Overview

While Project Zomboid doesn't provide an official "export all" feature, the modding community has developed tools to extract, edit, and integrate map data. This enables you to:
- Modify existing vanilla maps
- Create custom safe zones with pre-built walls
- Add special locations for your mod
- Integrate custom map areas with the base game

## Map File Basics

### Map Storage Structure

Project Zomboid stores maps in binary format:
```
Zomboid/Saves/<SaveName>/map/
├── map_780_1050.bin      # Map chunk at coordinates (780, 1050)
├── map_780_1051.bin      # Adjacent chunk
├── map_XXXX_YYYY.bin     # Pattern: map_<CellX>_<CellY>.bin
└── ...
```

Each file represents a 300x300 tile "cell" in the game world.

### File Types

- **.bin files**: Binary map data (terrain, buildings, objects)
- **.lotheader/.lotpack**: Lot information (buildings, spawn points)
- **.pzw files**: World/zone definitions
- **.tmx/.tbx files**: TileZed editable format (XML-based)

## Essential Tools

### 1. Vanilla Map Exporter

**GitHub**: https://github.com/cocolabs/pz-vanilla-map-project

Extracts the entire vanilla map to editable TMX/TBX files.

**Features**:
- Converts .bin files to TMX format
- Organized by rooms and buildings
- Preserves objects and properties
- Regular updates for new PZ builds

**Usage**:
```bash
# Clone repository
git clone https://github.com/cocolabs/pz-vanilla-map-project.git

# Follow repository instructions for extraction
# Output: TMX/TBX files in organized folders
```

### 2. TileZed (Official Map Editor)

**Location**: `ProjectZomboid/Tools/TileZed/`

**Purpose**: 
- View and edit TMX files
- Create new map cells
- Place buildings and objects
- Configure spawn zones

**Basic Usage**:
1. Launch TileZed.exe
2. File > Open Project
3. Load exported TMX files
4. Edit terrain, buildings, objects
5. Save changes

### 3. pz-mapmap (PNG Converter)

**GitHub**: https://github.com/quarantin/pz-mapmap

Converts map chunks to PNG images for viewing.

**Usage**:
```bash
# Requires .NET/Mono
# Compile from source
dotnet build pz-mapmap.csproj

# Convert map to PNG
./pz-mapmap --input ./Zomboid/Saves/MyWorld/map/ --output ./output/
```

### 4. Online Map Viewer

**URL**: https://map.projectzomboid.com

**Use For**:
- Finding coordinates of locations
- Planning custom map integration
- Identifying cell numbers
- Previewing vanilla map layout

## Extraction Workflow

### Step 1: Identify Target Areas

1. Use online map viewer to find coordinates
2. Note cell numbers (e.g., map_780_1050)
3. Identify buildings/areas to modify

**Example Coordinates**:
- Louisville: Around (12600, 1920)
- Muldraugh: Around (10950, 9840)
- Riverside: Around (6510, 5340)
- West Point: Around (11790, 7170)

### Step 2: Extract Map Data

```bash
# Using Vanilla Map Exporter
cd pz-vanilla-map-project

# Run extraction script (follow repo instructions)
./extract-vanilla-map.sh

# Output location:
# output/maps/<MapName>/
```

### Step 3: Edit in TileZed

1. **Open TileZed**
2. **File > Open Project**
3. **Navigate to extracted TMX files**
4. **Make your edits**:
   - Add/remove buildings
   - Place defensive structures
   - Create spawn zones
   - Add loot containers

### Step 4: Package for Mod

Create mod structure:
```
TheInfection/
└── media/
    └── maps/
        └── CustomArea/
            ├── worldmap.xml         # World definition
            ├── map_XXX_YYY.tmx      # Map cells
            └── map_XXX_YYY.tbx      # Building data
```

## Map Modding for "The Infection"

### Concept: Pre-Built Safe Zones

Create starting areas with walls already built:

**Implementation**:
1. Extract area from vanilla map
2. Add wall structures using TileZed
3. Set spawn points inside walls
4. Configure as safe zone in mod code

### Creating a Custom Starting Location

**TileZed Steps**:

1. **Create New Cell**:
   - File > New Cell
   - Set dimensions (300x300 recommended)
   - Choose location coordinates

2. **Add Terrain**:
   - Use Tiles panel
   - Paint ground (grass, concrete, dirt)
   - Add natural features

3. **Place Buildings**:
   - Buildings > Place Building
   - Select from templates
   - Position on map

4. **Add Walls**:
   - Objects > Walls
   - Select wall type (wood, metal)
   - Draw perimeter

5. **Set Spawn Points**:
   - Zones > Add Spawn Point
   - Mark player starting location

6. **Configure Properties**:
   - Select objects
   - Set properties (health, type)
   - Add custom metadata

### Integration with Vanilla Map

**Method 1: World Origin Alignment**

Set coordinates to connect with base game:

In TileZed:
1. **File > World Properties**
2. **Set World Origin**: Match vanilla coordinates
3. **Example**: Origin at (12600, 1920) for Louisville area

```xml
<!-- worldmap.xml -->
<world>
    <cell x="420" y="64">  <!-- Calculated from origin -->
        <map name="CustomArea/map_420_64" />
    </cell>
</world>
```

**Method 2: Replace Vanilla Cells**

Replace specific vanilla cells with custom versions:

1. Extract vanilla cell (e.g., map_780_1050.tmx)
2. Edit in TileZed
3. Package in mod with same filename
4. Mod overrides vanilla cell on load

### Creating "Infection Zones"

Mark areas that become hostile post-infection:

**TileZed**:
1. Zones > Add Zone
2. Name: "InfectionSpawnZone"
3. Properties: Add custom property "infectionZone" = "true"

**Lua Integration**:
```lua
-- Read zone properties
local zones = getWorld():getMetaGrid():getZones()
for i = 0, zones:size() - 1 do
    local zone = zones:get(i)
    if zone:getType() == "InfectionSpawnZone" then
        -- Mark as high-priority spawn area
        InfectionSpawnZones[#InfectionSpawnZones + 1] = {
            x = zone:getX(),
            y = zone:getY(),
            width = zone:getWidth(),
            height = zone:getHeight()
        }
    end
end
```

## Asset Extraction

### Extracting Textures

**Location**: `ProjectZomboid/media/textures/`

**Structure**:
```
textures/
├── Item_*.png           # Item icons
├── Tiles_*.png          # Terrain tiles
└── WorldObjects_*.png   # Building objects
```

**Usage**:
1. Copy needed textures to your mod
2. Reference in TMX files or Lua

**Example**:
```
TheInfection/
└── media/
    └── textures/
        └── custom/
            └── infected_wall.png
```

### Extracting 3D Models

**Location**: `ProjectZomboid/media/models_x/`

**Format**: .txt files defining 3D models

**Usage**:
1. Copy model definitions
2. Modify for custom objects
3. Reference in map files

### Extracting Sounds

**Location**: `ProjectZomboid/media/sound/`

**Format**: .ogg audio files

**Usage**:
```
TheInfection/
└── media/
    └── sound/
        └── infection/
            └── alarm.ogg
```

Reference in Lua:
```lua
getPlayer():getEmitter():playSound("infection/alarm")
```

## Advanced Map Techniques

### Mega Maps

Combining multiple map mods:

**Server Configuration**:
```ini
# server.ini
Mods=TheInfection;OtherMapMod

WorkshopItems=<TheInfectionID>;<OtherMapID>

Map=Muldraugh, KY;CustomMapName
```

**Alignment**:
- Ensure world coordinates don't overlap
- Use online map tool to verify
- Test chunk boundaries

### Dynamic Map Modifications

Modify maps at runtime with Lua:

```lua
-- Add barricade to existing building
local square = getCell():getGridSquare(x, y, z)
if square then
    local wall = IsoThumpable.new(getCell(), square, "walls_exterior_wooden_01_16", false, {})
    square:AddTileObject(wall)
end

-- Remove object
local objects = square:getObjects()
for i = 0, objects:size() - 1 do
    local obj = objects:get(i)
    if obj:getObjectName() == "targetObject" then
        square:RemoveTileObject(obj)
    end
end
```

### Procedural Generation

Generate structures dynamically:

```lua
function InfectionMap.generateWall(centerX, centerY, radius, z)
    for angle = 0, 360, 10 do
        local rad = math.rad(angle)
        local x = centerX + math.cos(rad) * radius
        local y = centerY + math.sin(rad) * radius
        
        local square = getCell():getGridSquare(math.floor(x), math.floor(y), z)
        if square then
            -- Place wall segment
            local wall = IsoThumpable.new(getCell(), square, "walls_exterior_wooden_01_16", false, {})
            square:AddTileObject(wall)
        end
    end
end
```

## Multiplayer Considerations

### Server Map Setup

1. **Install on Server**:
   - Copy mod to server mods folder
   - Configure server.ini

2. **Client Synchronization**:
   - Clients automatically download custom cells
   - Large maps may take time to download

3. **Performance**:
   - Limit custom cell count
   - Optimize object counts
   - Test with multiple players

### Map Chunk Management

```lua
-- Server-side chunk loading management
function InfectionMap.onChunkLoad(chunk)
    -- Apply infection modifications to newly loaded chunk
    local x = chunk:getX()
    local y = chunk:getY()
    
    if InfectionUtils.isInfectionTriggered() then
        InfectionMap.applyInfectionToChunk(x, y)
    end
end

Events.OnChunkLoaded.Add(InfectionMap.onChunkLoad)
```

## Common Issues and Solutions

### Issue: Map Not Loading

**Solutions**:
- Verify TMX/TBX file paths in mod
- Check worldmap.xml coordinates
- Ensure proper mod folder structure
- Validate XML syntax

### Issue: Misaligned with Vanilla Map

**Solutions**:
- Double-check World Origin settings
- Verify cell coordinate calculations
- Use online map for reference
- Test transitions between cells

### Issue: Objects Not Appearing

**Solutions**:
- Verify object layer in TMX
- Check sprite names exist
- Ensure proper tile properties
- Validate TBX building data

### Issue: Performance Problems

**Solutions**:
- Reduce object count per cell
- Optimize texture sizes
- Limit zombie spawn points
- Use LOD for distant areas

## Best Practices

### Map Design

1. **Keep It Balanced**:
   - Don't make safe zones too large
   - Provide strategic chokepoints
   - Balance loot distribution

2. **Performance First**:
   - Limit objects per cell (<1000)
   - Reuse vanilla textures when possible
   - Optimize spawn points

3. **Test Thoroughly**:
   - Test all cell transitions
   - Verify spawn points work
   - Check multiplayer compatibility

### Asset Usage

1. **Respect Licenses**:
   - Project Zomboid assets for PZ mods only
   - Credit community tool creators
   - Follow modding guidelines

2. **Optimize Assets**:
   - Compress textures appropriately
   - Reuse vanilla assets when possible
   - Keep mod size reasonable

3. **Document Changes**:
   - List custom cells added
   - Note vanilla cells modified
   - Provide coordinates reference

## Resources

### Tools and Downloads

- **Vanilla Map Exporter**: https://github.com/cocolabs/pz-vanilla-map-project
- **pz-mapmap**: https://github.com/quarantin/pz-mapmap
- **TileZed**: Included with Project Zomboid
- **Online Map**: https://map.projectzomboid.com

### Video Tutorials

- **Server Setup with Mega Maps**: Search "cosmiicsteem Project Zomboid server mega maps"
- **Custom Map Integration**: Search "MrAtomicDuck Project Zomboid map mods"
- **TileZed Basics**: Official Indie Stone YouTube channel

### Written Guides

- **PZwiki Map Modding**: https://pzwiki.net/wiki/Mapping
- **Indie Stone Forums**: Map modding section
- **Steam Guides**: Community map mod tutorials

### Community

- **Indie Stone Discord**: #mapping channel
- **Reddit r/projectzomboid**: Map showcase and help
- **PZ Modding Discord**: Dedicated mapping support

## Integration with "The Infection"

### Recommended Map Modifications

1. **Pre-Built Safe Zones**:
   - 3-5 small fortified areas across the map
   - Each with basic walls and minimal loot
   - Spawn points inside walls

2. **Infection Markers**:
   - Visual indicators (signs, markings)
   - Custom zones for heavy spawning
   - Environmental storytelling elements

3. **Strategic Locations**:
   - High ground positions
   - Natural chokepoints
   - Resource-rich but risky areas

### Custom Cell Example

Create a fortified warehouse:

1. Extract industrial area cell
2. Add perimeter walls (wood/metal)
3. Place warehouse building with loot
4. Add spawn point inside compound
5. Set zone property "safeZoneDefault" = "true"

### Mod Package Structure

```
TheInfection/
├── mod.info
└── media/
    ├── lua/                    # Mod code
    ├── maps/
    │   └── InfectionZones/
    │       ├── worldmap.xml
    │       ├── map_500_500.tmx
    │       ├── map_500_501.tmx
    │       └── ...
    └── textures/
        └── custom/             # Custom textures
```

## Conclusion

Map modding adds significant depth to "The Infection" by allowing:
- Pre-built defensive positions
- Custom infection spawn zones
- Environmental storytelling
- Strategic gameplay locations

While the process involves community tools and some technical knowledge, the results can dramatically enhance the mod experience. Start small with single cell modifications, then expand to larger custom areas as you gain confidence.

For "The Infection" specifically, focus on creating a few high-quality fortified locations rather than extensive map overhauls. This keeps mod size reasonable while providing compelling starting positions for the pre-infection preparation phase.

## Next Steps

1. Install TileZed and become familiar with it
2. Extract a small vanilla area using the community tools
3. Make minor modifications and test
4. Create one custom safe zone as a proof of concept
5. Integrate with your mod's Lua code
6. Test in both single-player and multiplayer
7. Expand based on player feedback

Happy mapping!
