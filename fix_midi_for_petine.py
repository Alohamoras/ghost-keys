#!/usr/bin/env python3
"""
Fix MIDI files for QRS Petine player piano compatibility.

Usage:
    python fix_midi_for_petine.py input.mid [output.mid]
    python fix_midi_for_petine.py output/*_basic_pitch.mid  # batch mode

If output path is not specified, replaces '_basic_pitch.mid' with '.mid'
or appends '_fixed.mid' to the filename.
"""

import sys
from pathlib import Path
import pretty_midi


def fix_midi_for_petine(input_path: str, output_path: str = None) -> str:
    """
    Fix a MIDI file for Petine compatibility:
    - Set program to 0 (Acoustic Grand Piano)
    - Remove all pitch bends

    Returns the output path.
    """
    input_path = Path(input_path)

    # Determine output path
    if output_path is None:
        if "_basic_pitch.mid" in input_path.name:
            output_path = input_path.parent / input_path.name.replace("_basic_pitch.mid", ".mid")
        else:
            output_path = input_path.parent / (input_path.stem + "_fixed.mid")
    else:
        output_path = Path(output_path)

    # Load and fix
    midi = pretty_midi.PrettyMIDI(str(input_path))

    total_notes = 0
    removed_pitch_bends = 0

    for inst in midi.instruments:
        inst.program = 0  # Acoustic Grand Piano
        removed_pitch_bends += len(inst.pitch_bends)
        inst.pitch_bends = []
        total_notes += len(inst.notes)

    # Save
    midi.write(str(output_path))

    print(f"✓ {input_path.name}")
    print(f"  → {output_path.name}")
    print(f"  Notes: {total_notes}, Pitch bends removed: {removed_pitch_bends}")

    return str(output_path)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    input_files = sys.argv[1:]

    # Check if last arg is an output path (only valid for single file)
    if len(input_files) == 2 and not Path(input_files[1]).exists():
        fix_midi_for_petine(input_files[0], input_files[1])
    else:
        # Batch mode
        for input_file in input_files:
            if Path(input_file).exists():
                fix_midi_for_petine(input_file)
            else:
                print(f"✗ File not found: {input_file}")


if __name__ == "__main__":
    main()
