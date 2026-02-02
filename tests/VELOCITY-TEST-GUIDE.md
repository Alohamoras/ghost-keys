# Velocity Test Guide

Use `velocity-test.mid` to calibrate your player piano's velocity threshold.

## Setup

1. Copy `velocity-test.mid` to your CompactFlash card
2. Insert card into Petine (before powering on)
3. Have a notepad ready to write down the cutoff velocity

---

## Test 1: Velocity Sweep (0:00 - 0:25)

**What happens:** Middle C plays 17 times, each time softer:

| Time | Velocity | Note # |
|------|----------|--------|
| 0.0s | 127 (loudest) | 1 |
| 1.5s | 120 | 2 |
| 3.0s | 110 | 3 |
| 4.5s | 100 | 4 |
| 6.0s | 90 | 5 |
| 7.5s | 80 | 6 |
| 9.0s | 70 | 7 |
| 10.5s | 60 | 8 |
| 12.0s | 50 | 9 |
| 13.5s | 45 | 10 |
| 15.0s | 40 | 11 |
| 16.5s | 35 | 12 |
| 18.0s | 30 | 13 |
| 19.5s | 25 | 14 |
| 21.0s | 20 | 15 |
| 22.5s | 15 | 16 |
| 24.0s | 10 (softest) | 17 |

**What to do:** Count the notes. When you hear silence (key doesn't play), note which number you're on. That's your cutoff.

**Example:** If you hear 12 notes then silence, the cutoff is around velocity 35.

---

## Test 2: Low/Medium/High (0:27 - 0:40)

**What happens:** Three-note patterns at velocities 40, 80, 120, repeated three times.

**What to listen for:**
- Can you hear the difference between soft/medium/loud?
- Does velocity 40 play at all?

---

## Test 3: Crescendo (0:41 - 0:47)

**What happens:** C major scale going up, getting louder:

| Note | Velocity |
|------|----------|
| C4 | 30 |
| D4 | 40 |
| E4 | 50 |
| F4 | 60 |
| G4 | 80 |
| A4 | 100 |
| B4 | 115 |
| C5 | 127 |

**What to listen for:** Does the scale sound like it's getting louder? Or do the first few notes not play?

---

## Recording Your Results

After testing, note:

1. **Cutoff velocity** - What's the lowest velocity that still plays?
2. **Can you hear dynamics?** - Do louder velocities sound noticeably louder?

Use these results to configure velocity remapping in `fix_midi_for_petine.py`.
