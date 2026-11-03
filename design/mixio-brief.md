# mix.io — studio brief

**Pitch:** a mobile color-mixing game. You drop food-coloring dyes into a glass of water and stir to match a named color from a real place on Earth. 2,000 colors, each pinned to a location with a postcard fact.

**Platform:** single-file HTML5 web app (WebGL2 fluid sim), installed to iPhone home screen; App Store via Capacitor later. Free, no ads, no coins (deliberate).

**Brand:** dark theme, liquid / Frutiger Aero glass, clean. Everything should feel fluid and soothing.

**Core loop:** target color → add drops (12 dyes + water) → stir → hold "lock it in" → % match (CIEDE2000) → chroma change → next color (random per-player order of all 2,000; level 1 always easy).

**Systems:**
- Chroma: 0–100 skill score (coverage × accuracy × Elo-style skill); above 100 = world ranked. Ranks: obsidian, moonstone, gold, ruby, sapphire, amethyst, emerald, diamond.
- Difficulty tiers: easy / medium / hard / extra hard, with harder tiers paying more.
- Hints cost part of the round's score (−6% main dye, −14% full recipe).
- Color DNA: name + birthday + favorite color → a personal color shown as a 3D jelly orb on home; the orb grows with chroma.
- Passport (countries stamped), collections, 43 milestone badges, atlas globe with pins + journey playback, daily color.
- Level-up screens every 10/25/50 levels.
- Accounts (username + password via Supabase), cloud save, world leaderboard.
- First-run: welcome → name → birthday → favorite color → DNA reveal → create account → tutorial.

**Source:** `index.html` (the whole game). Owner: Alec (solo dev, wants speed, scores on evaluations, "keep what we've built").
