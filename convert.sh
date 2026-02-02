#!/bin/bash
#
# Convert audio files to Petine-compatible MIDI
#
# Usage:
#   ./convert.sh "path/to/song.mp3"
#   ./convert.sh "path/to/album/"*.mp3
#   ./convert.sh "Artist/Album/"*.mp3
#

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./convert.sh <audio-files...>"
    echo ""
    echo "Examples:"
    echo "  ./convert.sh \"Artist/Album/song.mp3\""
    echo "  ./convert.sh \"Artist/Album/\"*.mp3"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Activate virtual environment
source venv/bin/activate

# Create output directory if needed
mkdir -p output

echo "=== Converting audio to MIDI ==="
basic-pitch output "$@" --save-midi 2>&1 | grep -E "(Predicting|Saved|Done|Error|WARNING)" | grep -v "WARNING"

echo ""
echo "=== Fixing MIDI files for Petine ==="
python fix_midi_for_petine.py output/*_basic_pitch.mid

echo ""
echo "=== Cleaning up intermediate files ==="
rm -f output/*_basic_pitch.mid

echo ""
echo "=== Done ==="
echo "MIDI files ready in: $SCRIPT_DIR/output/"
ls -1 output/*.mid
