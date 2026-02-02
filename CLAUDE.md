# MP3 to MIDI for QRS Petine Player Piano

This project converts audio files to MIDI files compatible with a QRS Petine player piano system.

## Setup

The virtual environment uses Python 3.11 (required - basic-pitch doesn't support Python 3.12+).

```bash
source venv/bin/activate
```

## Converting Audio to MIDI

### Step 1: Run basic-pitch

```bash
basic-pitch output "path/to/audio.mp3" --save-midi
```

This creates a MIDI file in the `output/` directory with `_basic_pitch` suffix.

### Step 2: Fix MIDI for Petine Compatibility

The raw basic-pitch output needs adjustments for the Petine system:

```python
import pretty_midi
import mido

midi = pretty_midi.PrettyMIDI("output/filename_basic_pitch.mid")

for inst in midi.instruments:
    inst.program = 0      # Set to Acoustic Grand Piano
    inst.pitch_bends = [] # Remove pitch bends (physical keys can't bend)

midi.write("output/filename.mid")

# Convert to Type 0 MIDI (required for Petine compatibility)
mid = mido.MidiFile("output/filename.mid")
if mid.type != 0:
    merged = mido.merge_tracks(mid.tracks)
    new_mid = mido.MidiFile(type=0)
    new_mid.tracks.append(merged)
    new_mid.ticks_per_beat = mid.ticks_per_beat
    new_mid.save("output/filename.mid")
```

### Petine Requirements

- **MIDI Type**: Type 0 (single track) - Type 1 multi-track files may not play
- **MIDI Channel**: 1 (default, no change needed)
- **Program/Patch**: 0-5 (patches 1-6 in 1-indexed terms). Use 0 for Acoustic Grand Piano.
- **Pitch bends**: Must be removed - physical piano keys cannot bend pitch
- **Note range**: Standard 88-key piano (A0/MIDI 21 to C8/MIDI 108)
- **Velocity**: 0-127 (matches Petine's 127 expression levels)
- **Velocity threshold**: Solenoids may not actuate below ~50 velocity (piano-dependent)

### Batch Processing

To convert all tracks in a directory:

```bash
source venv/bin/activate
basic-pitch output "./Artist/Album/"*.mp3 --save-midi
```

Then run the fix script on each output file.

## CompactFlash Card Requirements

- **Size**: 2GB maximum (larger cards won't be recognized)
- **Type**: Type I CompactFlash
- **Format**: FAT16 (FAT32 may work but FAT16 is safer)
- **Filenames**: Use 8.3 format (e.g., `TRACK01.MID`) - long filenames may not be recognized
- **Insert timing**: Insert card BEFORE powering on the piano

### Copying Files to Card

Use the copy-to-card.sh script:

```bash
./copy-to-card.sh /Volumes/CARD_NAME
```

This will:
- Rename files to 8.3 format (TRACK01.MID, TRACK02.MID, etc.)
- Clean macOS junk files (._*, .DS_Store, .Spotlight-V100, etc.)
- Print a track list for reference

### FAT Filesystem File Order

Files display in the order they were written to the filesystem, NOT alphabetically.
To control playback order, copy files one at a time in desired sequence,
or use a FAT sorting utility like `fatsort`.

## Troubleshooting

- **"000" shows but won't play**: Check filenames are 8.3 format, MIDI is Type 0
- **Python version errors**: Must use Python 3.11, not 3.12+
- **Pitch bend artifacts**: Remove pitch bends in post-processing
- **Wrong instrument sound**: Ensure program is set to 0-5
- **Notes not playing**: Check notes are within 88-key range (MIDI 21-108)
- **Quiet notes not playing**: Velocity may be below solenoid threshold (~50)
- **Card not recognized**: Must be ≤2GB, FAT16 format, inserted before power on
- **macOS junk files**: Run `dot_clean /Volumes/CARD/` to remove ._* files
