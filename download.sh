#!/bin/bash
#
# Download YouTube audio and convert to Petine-compatible MIDI
#
# Usage:
#   ./download.sh "https://youtube.com/watch?v=..."
#   ./download.sh "https://youtube.com/watch?v=..." "custom-name"
#
# Requirements:
#   brew install yt-dlp ffmpeg
#

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./download.sh <youtube-url> [output-name]"
    echo ""
    echo "Examples:"
    echo "  ./download.sh \"https://youtube.com/watch?v=xyz\""
    echo "  ./download.sh \"https://youtube.com/watch?v=xyz\" \"song-name\""
    exit 1
fi

URL="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Create downloads directory
mkdir -p downloads

# Determine output name
if [ -n "$2" ]; then
    OUTPUT_NAME="$2"
    OUTPUT_TEMPLATE="downloads/${OUTPUT_NAME}.%(ext)s"
else
    OUTPUT_TEMPLATE="downloads/%(title)s.%(ext)s"
fi

echo "=== Downloading audio from YouTube ==="
yt-dlp -x --audio-format mp3 --audio-quality 0 -o "$OUTPUT_TEMPLATE" "$URL"

# Find the downloaded file (most recent mp3 in downloads/)
DOWNLOADED_FILE=$(ls -t downloads/*.mp3 2>/dev/null | head -1)

if [ -z "$DOWNLOADED_FILE" ]; then
    echo "Error: No MP3 file found after download"
    exit 1
fi

echo ""
echo "Downloaded: $DOWNLOADED_FILE"
echo ""

# Convert to MIDI
./convert.sh "$DOWNLOADED_FILE"
