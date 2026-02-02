# Velocity Threshold Issue

## Problem

The Petine solenoids require a minimum velocity (~50) to physically actuate the piano keys. Notes with velocity below this threshold don't play at all.

## Impact

Some transcribed MIDI files have velocities as low as 32. These quiet notes will be silent on the player piano, potentially causing missing melody notes or accompaniment.

## Proposed Fix

Modify `fix_midi_for_petine.py` to remap velocity range from 1-127 → 50-127, preserving relative dynamics while ensuring all notes exceed the mechanical threshold.

```python
# Remap velocity: 1-127 → 50-127
min_velocity = 50
for note in inst.notes:
    note.velocity = min_velocity + int((note.velocity / 127) * (127 - min_velocity))
```

## Files to Modify

- `fix_midi_for_petine.py` - add velocity remapping
- `CLAUDE.md` - document the threshold

## Testing

1. Re-convert a track with quiet passages (e.g., "Dolce Droga" has velocity minimum of 32)
2. Verify all notes play on the piano
3. Confirm dynamics still sound natural (quiet parts should still be quieter than loud parts)

## Notes

- The exact threshold may vary by piano condition and solenoid adjustment
- Consider making the minimum velocity configurable (command-line argument)
- Current Einaudi album velocity ranges:
  - Lowest: 32 (multiple tracks)
  - Highest: 111
