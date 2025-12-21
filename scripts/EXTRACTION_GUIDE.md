# Map Extraction Guide

This guide explains how to use the automated map extraction script to download and extract Project Zomboid Build 41.78 vanilla maps for use in The Infection mod.

## Quick Start

```bash
# From the repository root
./scripts/extract_map.sh
```

This will:
1. Download the complete PZ Build 41.78 vanilla map
2. Extract it to `scripts/extracted_maps/`
3. Make all files ready for editing

## What You Get

### Repository Details
- **Source**: https://github.com/Unjammer/PZ_Vanilla_Map-B41-
- **Build Version**: Project Zomboid 41.78 (stable)
- **Total Files**: ~130,000 files (~2GB)
- **Export Method**: Reverse engineered from PZ game files

### Extracted Files

After running the script, you'll find these in `scripts/extracted_maps/`:

#### 1. Map Cells (tmx/ directory)
- **2,841 TMX files**: Individual map cells
- **Format**: TMX (Tiled Map Editor format)
- **Coverage**: Complete Kentucky map
- **Naming**: `XX_YY.tmx` (coordinates)

#### 2. World File
- **Kentucky_full.pzw**: Complete world definition
- **Size**: ~2.7 MB
- **Use**: Open in WorldEd to view/edit entire map

#### 3. Building Data
- **117,441 TBX files**: Room and building data
- **Organization**: Each room has its own TBX file
- **Linkage**: TMX files reference TBX files

#### 4. Reference Images
- **Map.png**: Full map overview (10.8 MB)
- **Map_ZombieSpawnMap.png**: Zombie spawn zones (606 KB)
- **Map_veg.png**: Vegetation map (25.6 MB)
- **kentucky.jpg**: Kentucky overview

#### 5. Map Directories
- **Challenge1/**: Challenge map 1
- **Challenge2/**: Challenge map 2
- **Kingsmouth/**: Kingsmouth area
- **KnoxCounty/**: Knox County area
- **Studio/**: Studio map
- **Tutorial/**: Tutorial map

## Using the Extracted Maps

### Step 1: Open in WorldEd

WorldEd is the official world editor included with Project Zomboid.

```bash
# Location (typically)
# Windows: C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\Tools\WorldEd\
# Linux: ~/.steam/steam/steamapps/common/ProjectZomboid/Tools/WorldEd/
```

1. Launch WorldEd
2. Open `Kentucky_full.pzw` from the extracted_maps directory
3. View the entire map layout
4. Navigate to specific areas

### Step 2: Edit Individual Cells with TileZed

TileZed is for detailed editing of individual map cells.

```bash
# Location (typically)
# Windows: C:\Program Files (x86)\Steam\steamapps\common\ProjectZomboid\Tools\TileZed\
# Linux: ~/.steam/steam/steamapps/common/ProjectZomboid/Tools/TileZed/
```

1. Launch TileZed
2. Open a TMX file from `tmx/` directory (e.g., `tmx/42_39.tmx`)
3. Edit terrain, buildings, objects
4. Save changes

### Step 3: Find Map Coordinates

Use the online map viewer to find specific locations:
- **URL**: https://map.projectzomboid.com
- Find addresses and landmarks
- Note the cell coordinates
- Open corresponding TMX file

**Example Coordinates:**
- Louisville: Around cells 42_6 to 44_8
- Muldraugh: Around cells 36_32 to 38_34
- West Point: Around cells 39_23 to 41_25
- Riverside: Around cells 21_17 to 23_19

## Integration with The Infection Mod

### Creating Custom Safe Zones

1. **Select a Location**
   - Choose a cell to modify (e.g., warehouse district)
   - Open in TileZed

2. **Add Defensive Structures**
   - Place walls around perimeter
   - Add defensive positions
   - Create entry/exit points

3. **Set Spawn Points**
   - Mark player starting location
   - Configure as safe zone

4. **Export to Mod**
   ```
   TheInfection/
   └── media/
       └── maps/
           └── CustomArea/
               ├── worldmap.xml
               ├── map_XX_YY.tmx
               └── map_XX_YY.tbx
   ```

5. **Configure in Lua**
   - Reference the custom zone
   - Mark as infection-free during setup phase
   - Define behavior during onslaught

See `docs/MAP_MODDING.md` for detailed integration instructions.

## Advanced Usage

### Custom Output Directory

```bash
# Extract to a specific location
./scripts/extract_map.sh /path/to/custom/output
```

### Selective Editing

You don't need to edit all 2,841 cells. Focus on:
- Starting locations for players
- Strategic defensive positions
- Resource-rich areas
- Key landmarks

### Working with Layers

TMX files contain multiple layers:
- **Floor layers**: Ground tiles (0, 1, 2, etc.)
- **Wall layers**: Walls and vertical objects
- **Object layers**: Furniture, items, etc.

Each layer can be edited independently in TileZed.

## Important Notes

### Tilesheets Required

To properly edit maps, you need Project Zomboid tilesheets:
- Not included in the repository
- Must extract from game files
- See `REPOSITORY_README.md` in output directory
- Link provided in repository README

### File Format

- **TMX**: XML-based, human-readable
- **TBX**: Binary format for room data
- **PZW**: Project Zomboid world file

### Compatibility

- **Build**: 41.78 (stable)
- **Tools**: WorldEd, TileZed (included with PZ)
- **Game Version**: Build 41.x

### Performance Tips

1. **Large Repository**: ~2GB download, be patient
2. **Disk Space**: Ensure 5GB+ free space
3. **Git Clone**: Uses depth=1 for faster download
4. **Editing**: Work on one cell at a time

## Troubleshooting

### Clone Takes Too Long
- The repository has ~130,000 files
- Download time: 5-15 minutes (depending on connection)
- This is normal, be patient

### Out of Disk Space
- Repository needs ~2GB
- Ensure adequate free space before running
- Clean up temporary files if needed

### Can't Open Files in TileZed
- Verify TileZed is correctly installed
- Check file paths are correct
- Ensure tilesheets are extracted

### Missing Tilesheets
- See REPOSITORY_README.md in output
- Download from link provided
- Extract to proper location

## Additional Resources

### Documentation
- [MAP_MODDING.md](../docs/MAP_MODDING.md): Complete map modding guide
- [TECHNICAL_IMPLEMENTATION.md](../docs/TECHNICAL_IMPLEMENTATION.md): Technical details
- [scripts/README.md](README.md): Scripts overview

### External Links
- **Repository**: https://github.com/Unjammer/PZ_Vanilla_Map-B41-
- **Online Map**: https://map.projectzomboid.com
- **PZ Wiki**: https://pzwiki.net/wiki/Mapping
- **Indie Stone Forums**: Map modding section

### Community
- Indie Stone Discord: #mapping channel
- Reddit: r/projectzomboid
- PZ Modding Discord

## Credits

- **Map Export**: Unjammer (reverse engineering)
- **Project Zomboid**: The Indie Stone
- **Tools**: WorldEd, TileZed by The Indie Stone
- **Community**: Various contributors

## License

The extracted maps are from Project Zomboid and are subject to The Indie Stone's modding policies. Use for Project Zomboid mods only.

---

**Last Updated**: December 2024  
**Script Version**: 2.0  
**Build Version**: Project Zomboid 41.78
