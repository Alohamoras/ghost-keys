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
pip install basic-pitch

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
   - Outputs on MIDI channel 1

## Files

| File | Purpose |
|------|---------|
| `download.sh` | Download from YouTube and convert to MIDI |
| `convert.sh` | Convert local audio files to MIDI |
| `fix_midi_for_petine.py` | MIDI post-processor for player piano compatibility |
| `CLAUDE.md` | Documentation for AI assistants |

## Player Piano Compatibility

Tested with QRS Petine system. Should work with any player piano that accepts standard MIDI files on channel 1.

### Petine-Specific Notes

- Load MIDI files via CompactFlash card (2GB max, Type I)
- Files must use MIDI channel 1, program 0-5
- 127 velocity levels supported

## Credits

- [basic-pitch](https://github.com/spotify/basic-pitch) by Spotify's Audio Intelligence Lab
