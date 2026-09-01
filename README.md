# Luna's Quest (Lunina potraga)

A little QBASIC adventure game where **Luna** - a girl with long hair and glasses - hops around a galaxy, collects hidden items, and runs from enemies.

> This project has a personal history: I first built it and took it to the **informatics competition in 7th grade of elementary school**. This repo keeps that original idea alive, with a more complete second version added later.

## Versions

| File | Description |
|------|-------------|
| `LUNA.BAS` | The original, turn-based version. Move around, find 5 items, get a gift for each one. |
| `LUNA2.BAS` | Extended real-time version: enemies that chase Luna, a 3-life health system, and sound effects. |

## Features (v2)

- **Real-time gameplay** — enemies move on their own, not just on your turn.
- **Enemies to flee from** — three red `Q` creatures chase Luna and take a life if they catch her.
- **Health system** — 3 lives, shown as hearts in the HUD; lose them all and it's game over.
- **Sound effects** — a thud when Luna hits a wall, a falling tone when a creature catches her, cheerful tones on pickups, and a short melody on win/lose.
- **Rewards** — every item found unlocks a gift message that motivates the search: a glowing crystal, a star map, a droid companion, a magic flower, and a golden star.

## Controls

| Key | Action |
|-----|--------|
| Arrow keys | Jump / move |
| `ESC` | Quit |

## How to run

### Easiest: QB64 (Windows / macOS / Linux)

1. Download QB64 from [qb64.com](https://qb64.com) (or [qb64phoenix.com](https://qb64phoenix.com)).
2. Open QB64, then **File → Open** and select `LUNA2.BAS` (or `LUNA.BAS`).
3. Press **F5** to run.

### Classic: QBASIC in DOSBox

1. Install [DOSBox](https://www.dosbox.com).
2. Mount the folder and enter it:
   ```
   mount c C:\path\to\this\repo
   c:
   ```
3. Run it:
   ```
   qbasic /run LUNA2.BAS
   ```

## Notes

- Text is written without Croatian diacritics because the classic DOS code page (CP437) doesn't display č, ć, ž, š, đ correctly.
- The `.BAS` files are plain text — open them in any editor to read or tweak the code.

---

Made with QBASIC, and a lot of nostalgia.
