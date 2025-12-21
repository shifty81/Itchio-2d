#!/bin/bash

################################################################################
# Project Zomboid Map Extraction Script
# 
# This script automates the extraction of Project Zomboid's vanilla map
# according to the process documented in docs/MAP_MODDING.md
#
# Prerequisites:
# - Git must be installed
# - Sufficient disk space for the map extraction (~1GB+)
# - Internet connection to clone the extraction tool
#
# Usage:
#   ./scripts/extract_map.sh [output_directory]
#
# Example:
#   ./scripts/extract_map.sh ./extracted_maps
################################################################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
VANILLA_MAP_REPO="https://github.com/cocolabs/pz-vanilla-map-project.git"
DEFAULT_OUTPUT_DIR="./extracted_maps"
TEMP_DIR="/tmp/pz-map-extraction-$$"

################################################################################
# Helper Functions
################################################################################

print_header() {
    echo ""
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_info() {
    echo -e "${BLUE}→ $1${NC}"
}

check_prerequisite() {
    if ! command -v "$1" &> /dev/null; then
        print_error "$1 is not installed or not in PATH"
        return 1
    else
        print_success "$1 is available"
        return 0
    fi
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        print_info "Cleaning up temporary directory..."
        rm -rf "$TEMP_DIR"
    fi
}

################################################################################
# Main Script
################################################################################

main() {
    print_header "Project Zomboid Map Extraction Tool"
    
    # Set output directory
    OUTPUT_DIR="${1:-$DEFAULT_OUTPUT_DIR}"
    
    echo "This script will extract Project Zomboid's vanilla map data"
    echo "using the community-maintained Vanilla Map Exporter tool."
    echo ""
    echo "Output directory: $OUTPUT_DIR"
    echo ""
    
    # Check prerequisites
    print_header "Checking Prerequisites"
    
    local prereqs_ok=true
    
    if ! check_prerequisite "git"; then
        prereqs_ok=false
    fi
    
    if [ "$prereqs_ok" = false ]; then
        print_error "Missing required prerequisites. Please install them and try again."
        exit 1
    fi
    
    # Create output directory
    print_header "Setting Up Directories"
    
    if [ -d "$OUTPUT_DIR" ]; then
        print_warning "Output directory already exists: $OUTPUT_DIR"
        read -p "Do you want to continue? This may overwrite existing files. (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Aborted by user"
            exit 0
        fi
    else
        print_info "Creating output directory: $OUTPUT_DIR"
        mkdir -p "$OUTPUT_DIR"
        print_success "Output directory created"
    fi
    
    mkdir -p "$TEMP_DIR"
    print_success "Temporary directory created: $TEMP_DIR"
    
    # Clone the Vanilla Map Exporter repository
    print_header "Cloning Vanilla Map Exporter"
    
    print_info "Cloning from: $VANILLA_MAP_REPO"
    print_info "This may take a few minutes..."
    
    local clone_success=false
    
    # Use GIT_TERMINAL_PROMPT=0 to prevent interactive prompts
    # Capture output and check directory existence for success
    GIT_TERMINAL_PROMPT=0 git clone --depth 1 "$VANILLA_MAP_REPO" "$TEMP_DIR/pz-vanilla-map-project" 2>&1 | sed 's/^/  /'
    
    if [ -d "$TEMP_DIR/pz-vanilla-map-project/.git" ]; then
        print_success "Repository cloned successfully"
        clone_success=true
    fi
    
    if [ "$clone_success" = false ]; then
        print_warning "Primary repository unavailable or requires authentication"
        print_info "The repository might have been moved, renamed, or made private."
        echo ""
        print_info "Alternative approaches:"
        echo "  1. Download pre-extracted maps from Project Zomboid modding community"
        echo "  2. Use TileZed to manually extract from your game installation"
        echo "  3. Check the Project Zomboid modding Discord/forums for updated tools"
        echo ""
        print_info "Manual extraction steps:"
        echo "  1. Locate your Project Zomboid installation"
        echo "  2. Navigate to: ProjectZomboid/media/maps/"
        echo "  3. Use TileZed (in ProjectZomboid/Tools/TileZed/) to open .lotheader files"
        echo "  4. Export to TMX format for editing"
        echo ""
        print_warning "Creating a guide file with manual instructions..."
        
        # Create a helpful guide file
        cat > "$OUTPUT_DIR/MANUAL_EXTRACTION_GUIDE.txt" << 'GUIDE_EOF'
# Manual Map Extraction Guide for Project Zomboid

The automated extraction tool repository is currently unavailable.
Here are manual extraction methods:

## Method 1: Using TileZed (Recommended)

TileZed is the official map editor included with Project Zomboid.

1. Locate TileZed:
   - Windows: ProjectZomboid/Tools/TileZed/TileZed.exe
   - Linux/Mac: ProjectZomboid/Tools/TileZed/

2. Launch TileZed

3. Open existing maps:
   File > Open Project
   Navigate to: ProjectZomboid/media/maps/

4. Browse and select map files:
   - Look for .lotheader files
   - Open the area you want to edit

5. Export to TMX:
   File > Export > TMX Format
   Choose output location

## Method 2: From Game Save

If you have an existing save:

1. Find your save directory:
   - Windows: %USERPROFILE%\Zomboid\Saves\
   - Linux: ~/.zomboid/Saves/
   - Mac: ~/Zomboid/Saves/

2. Navigate to: <SaveName>/map/

3. Files are in .bin format (binary)
   These need TileZed or community tools to convert

## Method 3: Community Tools

Alternative extraction tools:

1. pz-mapmap (PNG Converter)
   - GitHub: https://github.com/quarantin/pz-mapmap
   - Converts map chunks to PNG images
   - Good for visualization

2. Check Project Zomboid Modding Community:
   - Indie Stone Discord: #mapping channel
   - Reddit: r/projectzomboid
   - PZ Modding Discord

## Map File Locations

Vanilla maps are in:
  ProjectZomboid/media/maps/

Common map directories:
  - Muldraugh, KY
  - West Point, KY  
  - Riverside, KY
  - Louisville, KY

## Important Notes

- Map coordinates: Use https://map.projectzomboid.com to find locations
- Cell format: map_<X>_<Y>.bin (300x300 tile chunks)
- TMX files can be edited in TileZed
- Always backup original files before editing

## Integration with The Infection Mod

After extracting/editing maps:

1. Place edited maps in:
   TheInfection/media/maps/CustomArea/

2. Create worldmap.xml to define map cells

3. See docs/MAP_MODDING.md for detailed integration steps

## Getting Help

- See docs/MAP_MODDING.md in this repository
- Project Zomboid Wiki: https://pzwiki.net/wiki/Mapping
- Indie Stone Forums: Map modding section

GUIDE_EOF
        
        print_success "Manual extraction guide created: $OUTPUT_DIR/MANUAL_EXTRACTION_GUIDE.txt"
        echo ""
        print_info "You can proceed with manual extraction using the guide above"
        return 0
    fi
    
    # Navigate to the cloned repository
    cd "$TEMP_DIR/pz-vanilla-map-project"
    
    # Check if README exists and display extraction instructions
    print_header "Extraction Instructions"
    
    if [ -f "README.md" ]; then
        print_info "The Vanilla Map Exporter has been downloaded."
        echo ""
        print_warning "IMPORTANT: Please read the repository's README.md for specific extraction instructions."
        echo ""
        print_info "The repository typically contains:"
        echo "  - Pre-extracted map files (TMX/TBX format)"
        echo "  - Instructions for updating to latest PZ version"
        echo "  - Documentation on map structure"
        echo ""
        
        # Check if map files already exist in the repository
        if [ -d "map" ] || [ -d "maps" ] || find . -name "*.tmx" -type f 2>/dev/null | grep -q .; then
            print_success "Map files detected in repository!"
            echo ""
            print_info "Copying extracted map files to output directory..."
            
            # Copy map files to output directory
            if [ -d "map" ] && [ -n "$(ls -A map 2>/dev/null)" ]; then
                cp -r map/* "$OUTPUT_DIR/" 2>/dev/null || true
            fi
            
            if [ -d "maps" ] && [ -n "$(ls -A maps 2>/dev/null)" ]; then
                cp -r maps/* "$OUTPUT_DIR/" 2>/dev/null || true
            fi
            
            # Copy any TMX files found (portable across systems)
            if find . -name "*.tmx" -type f | grep -q .; then
                find . -name "*.tmx" -type f -print0 | while IFS= read -r -d '' file; do
                    # Strip leading ./ to avoid creating $OUTPUT_DIR/./ paths
                    clean_file="${file#./}"
                    target_dir="$OUTPUT_DIR/$(dirname "$clean_file")"
                    mkdir -p "$target_dir"
                    cp "$file" "$target_dir/" 2>/dev/null || true
                done
            fi
            
            # Check if any files were actually copied by looking at output directory
            if [ -n "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
                print_success "Map files copied to: $OUTPUT_DIR"
            else
                print_warning "No map files were copied (directory might be empty)"
            fi
        else
            print_warning "No pre-extracted map files found in repository"
            print_info "You may need to run the extraction tool manually"
        fi
    fi
    
    # Provide next steps
    print_header "Next Steps"
    
    echo "Map extraction repository is located at:"
    echo "  $TEMP_DIR/pz-vanilla-map-project"
    echo ""
    echo "Output directory:"
    echo "  $(cd "$(dirname "$OUTPUT_DIR")" && pwd)/$(basename "$OUTPUT_DIR")"
    echo ""
    print_info "To use the extracted maps:"
    echo "  1. Review the extracted files in $OUTPUT_DIR"
    echo "  2. Use TileZed (ProjectZomboid/Tools/TileZed/) to edit TMX files"
    echo "  3. Follow docs/MAP_MODDING.md for integration steps"
    echo ""
    print_info "To manually run extraction (if needed):"
    echo "  1. cd $TEMP_DIR/pz-vanilla-map-project"
    echo "  2. Follow instructions in README.md"
    echo "  3. Check for extraction scripts or tools"
    echo ""
    print_warning "Note: The temporary directory will be cleaned up automatically"
    print_info "If you need to keep it, copy it before the script exits:"
    echo "  cp -r $TEMP_DIR/pz-vanilla-map-project /your/desired/location"
    echo ""
    
    # Ask if user wants to keep temp directory
    read -p "Do you want to keep the temporary directory for manual extraction? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_success "Temporary directory preserved: $TEMP_DIR"
        print_warning "Remember to clean it up manually when done!"
        return 0
    fi
    
    # Cleanup
    print_header "Cleanup"
    cleanup
    print_success "Temporary files removed"
    
    print_header "Extraction Complete"
    print_success "Map extraction process completed successfully!"
    echo ""
}

# Set trap for cleanup on exit
trap cleanup EXIT INT TERM

# Run main function
main "$@"
