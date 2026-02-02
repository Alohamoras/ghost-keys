#!/bin/bash
#
# Copy MIDI files to CompactFlash card for QRS Petine
#
# Usage:
#   ./copy-to-card.sh /Volumes/CARD_NAME
#   ./copy-to-card.sh /Volumes/CARD_NAME output/*.mid
#
# Features:
#   - Renames files to 8.3 format (TRACK01.MID, etc.) for compatibility
#   - Cleans macOS junk files (._*, .DS_Store, etc.)
#   - Lists files in copy order for reference
#

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./copy-to-card.sh <card-path> [midi-files...]"
    echo ""
    echo "Examples:"
    echo "  ./copy-to-card.sh /Volumes/NO\\ NAME"
    echo "  ./copy-to-card.sh /Volumes/CF output/*.mid"
    echo ""
    echo "Available volumes:"
    ls /Volumes/
    exit 1
fi

CARD_PATH="$1"
shift

# Check if card exists
if [ ! -d "$CARD_PATH" ]; then
    echo "Error: Card not found at $CARD_PATH"
    echo ""
    echo "Available volumes:"
    ls /Volumes/
    exit 1
fi

# Get MIDI files - either from args or from output/
if [ $# -gt 0 ]; then
    MIDI_FILES=("$@")
else
    MIDI_FILES=(output/*.mid)
fi

# Check if we have files
if [ ${#MIDI_FILES[@]} -eq 0 ]; then
    echo "Error: No MIDI files found"
    exit 1
fi

echo "=== Copying to $CARD_PATH ==="
echo ""

# Remove existing MIDI files on card
rm -f "$CARD_PATH"/*.MID "$CARD_PATH"/*.mid 2>/dev/null || true

# Copy files with 8.3 naming
TRACK_NUM=1
declare -a TRACK_MAP

for file in "${MIDI_FILES[@]}"; do
    if [ -f "$file" ]; then
        # Format track number with leading zero
        TRACK_NAME=$(printf "TRACK%02d.MID" $TRACK_NUM)

        cp "$file" "$CARD_PATH/$TRACK_NAME"

        BASENAME=$(basename "$file")
        echo "$TRACK_NAME  ←  $BASENAME"
        TRACK_MAP+=("$TRACK_NUM:$BASENAME")

        ((TRACK_NUM++))
    fi
done

# Also copy velocity test if it exists
if [ -f "tests/velocity-test.mid" ]; then
    cp "tests/velocity-test.mid" "$CARD_PATH/VELTEST.MID"
    echo "VELTEST.MID  ←  velocity-test.mid"
fi

echo ""
echo "=== Cleaning macOS junk files ==="
dot_clean "$CARD_PATH/" 2>/dev/null || true
rm -f "$CARD_PATH"/.DS_Store 2>/dev/null || true
rm -rf "$CARD_PATH"/.Spotlight-V100 2>/dev/null || true
rm -rf "$CARD_PATH"/.fseventsd 2>/dev/null || true
rm -rf "$CARD_PATH"/.Trashes 2>/dev/null || true

echo "Done!"
echo ""
echo "=== Track List ==="
echo "Save this for reference:"
echo ""
for entry in "${TRACK_MAP[@]}"; do
    NUM="${entry%%:*}"
    NAME="${entry#*:}"
    printf "  %02d. %s\n" "$NUM" "$NAME"
done
echo ""
echo "Card ready. Eject before removing."
