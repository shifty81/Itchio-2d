# Scripts Directory

This directory contains utility scripts for The Infection mod development and map extraction.

## Available Scripts

### extract_map.sh

Automates the extraction of Project Zomboid's vanilla map data according to the documentation in `docs/MAP_MODDING.md`.

**Purpose:**
- Downloads the community Vanilla Map Exporter tool
- Extracts map files in TMX/TBX format
- Prepares maps for editing with TileZed

**Prerequisites:**
- Git must be installed
- Sufficient disk space (~1GB+)
- Internet connection

**Usage:**
```bash
# Extract maps to default location (./extracted_maps)
./scripts/extract_map.sh

# Extract maps to custom location
./scripts/extract_map.sh /path/to/output/directory
```

**What it does:**
1. Checks for required tools (Git)
2. Clones the [Vanilla Map Exporter](https://github.com/cocolabs/pz-vanilla-map-project)
3. Copies extracted map files to the output directory
4. Provides instructions for next steps

**Output:**
- Extracted map files in TMX/TBX format
- Ready for editing in TileZed
- Can be integrated into The Infection mod

**Next Steps After Extraction:**
1. Review extracted files in the output directory
2. Open files with TileZed (found in `ProjectZomboid/Tools/TileZed/`)
3. Edit maps according to your needs
4. Follow `docs/MAP_MODDING.md` for integration instructions

**Related Documentation:**
- `docs/MAP_MODDING.md` - Complete map modding guide
- `docs/TECHNICAL_IMPLEMENTATION.md` - Integration details

## Adding New Scripts

When adding new scripts to this directory:
1. Make scripts executable: `chmod +x scripts/your_script.sh`
2. Include clear usage documentation in comments
3. Update this README with script information
4. Follow existing patterns for error handling and output formatting
