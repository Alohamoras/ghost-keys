# MP3 to MIDI for Player Piano

Convert audio files to MIDI files compatible with QRS Petine (and similar) player piano systems.

Uses Spotify's [basic-pitch](https://github.com/spotify/basic-pitch) for audio-to-MIDI transcription, with post-processing to ensure compatibility with player piano solenoid systems.

## Requirements

- macOS, Linux, or Windows
- Python 3.11 (basic-pitch doesn't support 3.12+)
- yt-dlp and ffmpeg (optional, for YouTube downloads)

## Setup

```bash
# Install Python 3.11 if needed (macOS)
brew install python@3.11

# Create virtual environment
python3.11 -m venv venv
source venv/bin/activate

# Install dependencies
pip install basic-pitch mido

# Optional: for YouTube downloads
brew install yt-dlp ffmpeg
```

## Usage

### From YouTube

```bash
# Download and convert in one command
./download.sh "https://youtube.com/watch?v=..."

# With custom output name
./download.sh "https://youtube.com/watch?v=..." "nuvole-bianche"
```

> **Note:** Downloading YouTube content may violate YouTube's Terms of Service. This tool is provided for personal, non-commercial use only. Please respect copyright and the rights of content creators.

### From local files

```bash
# Convert audio files to player-piano-compatible MIDI
./convert.sh "path/to/song.mp3"

# Convert multiple files
./convert.sh "Artist/Album/"*.mp3
```

Output MIDI files are saved to the `output/` directory.

## What It Does

1. **Transcribes audio to MIDI** using basic-pitch (neural network trained on piano)
2. **Fixes MIDI for player piano**:
   - Sets instrument to Acoustic Grand Piano (program 0)
   - Removes pitch bends (physical keys can't bend)
   - Converts to Type 0 MIDI (single track) for compatibility
   - Outputs on MIDI channel 1

## Files

| File | Purpose |
|------|---------|
| `download.sh` | Download from YouTube and convert to MIDI |
| `convert.sh` | Convert local audio files to MIDI |
| `copy-to-card.sh` | Copy MIDI files to CompactFlash with 8.3 naming |
| `fix_midi_for_petine.py` | MIDI post-processor for player piano compatibility |
| `tests/velocity-test.mid` | Test file for calibrating piano velocity threshold |
| `CLAUDE.md` | Documentation for AI assistants |

## Player Piano Compatibility

Tested with QRS Petine system. Should work with any player piano that accepts standard MIDI files on channel 1.

### Petine-Specific Notes

- Load MIDI files via CompactFlash card (2GB max, Type I, FAT16 format)
- Files must use MIDI channel 1, program 0-5
- **Use 8.3 filenames** (e.g., `TRACK01.MID`) - long filenames may not be recognized
- **Use Type 0 MIDI** (single track) - Type 1 may not play
- Insert card **before** powering on the piano
- 127 velocity levels supported

### Copying Files to CompactFlash

Use the included script to copy files with proper naming:

```bash
./copy-to-card.sh /Volumes/YOUR_CF_CARD
```

This will:
- Rename files to 8.3 format (TRACK01.MID, TRACK02.MID, etc.)
- Clean up macOS junk files (._*, .DS_Store, etc.)
- Print a track list for reference

### Velocity Calibration

Player piano solenoids need a minimum velocity to actuate the keys. Use the included test file to find your piano's threshold:

```bash
./copy-to-card.sh /Volumes/YOUR_CF_CARD tests/velocity-test.mid
```

The test file contains:
1. **Velocity sweep** (0-25s) - Same note at velocities 127→10. Note when keys stop sounding.
2. **Low/Medium/High comparison** (27-40s) - Patterns at velocity 40, 80, 120.
3. **Crescendo** (41-47s) - Scale from velocity 30→127.

## Credits

- [basic-pitch](https://github.com/spotify/basic-pitch) by Spotify's Audio Intelligence Lab
