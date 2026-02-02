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

midi = pretty_midi.PrettyMIDI("output/filename_basic_pitch.mid")

for inst in midi.instruments:
    inst.program = 0      # Set to Acoustic Grand Piano
    inst.pitch_bends = [] # Remove pitch bends (physical keys can't bend)

midi.write("output/filename.mid")
```

### Petine Requirements

- **MIDI Channel**: 1 (default, no change needed)
- **Program/Patch**: 0-5 (patches 1-6 in 1-indexed terms). Use 0 for Acoustic Grand Piano.
- **Pitch bends**: Must be removed - physical piano keys cannot bend pitch
- **Note range**: Standard 88-key piano (A0/MIDI 21 to C8/MIDI 108)
- **Velocity**: 0-127 (matches Petine's 127 expression levels)

### Batch Processing

To convert all tracks in a directory:

```bash
source venv/bin/activate
basic-pitch output "./Artist/Album/"*.mp3 --save-midi
```

Then run the fix script on each output file.

## File Delivery

- Copy final `.mid` files to a CompactFlash card (2GB max, Type I)
- Files on root directory display as numbers (000-509)
- Can organize into subdirectories (Programs) which display as P01-P99

## Audio Sources

The `Ludovico Einaudi/Una Mattina/` folder contains 13 piano tracks suitable for conversion.

## Troubleshooting

- **Python version errors**: Must use Python 3.11, not 3.12+
- **Pitch bend artifacts**: Remove pitch bends in post-processing
- **Wrong instrument sound**: Ensure program is set to 0-5
- **Notes not playing**: Check notes are within 88-key range (MIDI 21-108)
