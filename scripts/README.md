# Scripts Directory

This directory contains utility scripts for The Infection mod development and map extraction.

## Available Scripts

### extract_map.sh

Automates the extraction of Project Zomboid Build 41.78 vanilla map data from the Unjammer/PZ_Vanilla_Map-B41- repository.

**Purpose:**
- Downloads pre-extracted Project Zomboid vanilla maps (Build 41.78)
- Extracts 2841 map cells with 117,441 rooms
- Provides maps in TMX/TBX format for editing with WorldEd/TileZed

**Prerequisites:**
- Git must be installed
- Sufficient disk space (~2GB+)
- Internet connection

**Usage:**
```bash
# Extract maps to default location (scripts/extracted_maps)
./scripts/extract_map.sh

# Extract maps to custom location
./scripts/extract_map.sh /path/to/output/directory
```

**What it does:**
1. Checks for required tools (Git)
2. Clones the [Unjammer/PZ_Vanilla_Map-B41-](https://github.com/Unjammer/PZ_Vanilla_Map-B41-) repository
3. Copies all map files, including:
   - 2841 TMX map cells in the tmx/ directory
   - Kentucky_full.pzw world file for WorldEd
   - Map reference images (PNG)
   - Map directories (Challenge, Kingsmouth, KnoxCounty, etc.)
4. Provides instructions for next steps

**Output:**
- Extracted map files in TMX/TBX format
- Ready for editing in WorldEd or TileZed
- Can be integrated into The Infection mod

**Repository Information:**
- **Repository:** https://github.com/Unjammer/PZ_Vanilla_Map-B41-
- **Build Version:** Project Zomboid 41.78 (stable)
- **Export Details:** 2841 cells exported, 117,441 rooms
- **Format:** TMX (map cells) and TBX (building/room data)
- **Note:** Exported using private tools via reverse engineering

**Next Steps After Extraction:**
1. Review extracted files in the output directory
2. Open Kentucky_full.pzw with WorldEd (found in `ProjectZomboid/Tools/WorldEd/`)
3. Edit individual cells with TileZed (found in `ProjectZomboid/Tools/TileZed/`)
4. Follow `docs/MAP_MODDING.md` for integration instructions
5. Note: You'll need proper tilesheets to edit maps (see REPOSITORY_README.md in output)

**Related Documentation:**
- `EXTRACTION_GUIDE.md` - Comprehensive extraction and usage guide
- `docs/MAP_MODDING.md` - Complete map modding guide
- `docs/TECHNICAL_IMPLEMENTATION.md` - Integration details

## Adding New Scripts

When adding new scripts to this directory:
1. Make scripts executable: `chmod +x scripts/your_script.sh`
2. Include clear usage documentation in comments
3. Update this README with script information
4. Follow existing patterns for error handling and output formatting
