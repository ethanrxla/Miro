# Levels 2–5: scaffold and source map

These are traversable Godot blockouts, not finished levels. Each saved scene uses Julia's existing tiles and player assets, the shared physics TileSet, Oil 6 colors, three tiers, ladders, shadow cover and reusable interaction scenes. Dialogue is draft staging text derived from the story requirements, not a quotation from the documents.

## Sources for each floor

| Floor / blueprint | Required story and gameplay sequence | Primary references | Remaining production work |
| --- | --- | --- | --- |
| 2 — The Symptoms (`data/levels/level_02.json`) | Sick prisoner → brother's surrender offer; transfer ledger shows persecution; second sigil → exit. Patrols and cover support stealth practice. | [Specification: Level 2](mirospec.md), [reference guide p. 8](miroguide.pdf), [class guide: guards and stealth](class.md) | Animated symptomatic prisoners, dedicated stealth tutorial and encounter tuning. The prisoner is currently an interaction marker. |
| 3 — The Order (`data/levels/level_03.json`) | Checkpoint terminal → rank record → brother confirms their relationship and shared responsibility → third sigil → exit. | [Specification: Level 3](mirospec.md), [reference guide p. 8](miroguide.pdf), [class guide: RemoteTerminal and SecurityCamera](class.md) | Terminal currently records a milestone. Implement the one-second hack, linked camera shutdown and physical checkpoint gating; editor markers reserve these placements. |
| 4 — The Ward (`data/levels/level_04.json`) | Experiment records and containment evidence → brother's warning → fourth sigil → exit. Evidence preserves both institutional abuse and a credible containment rationale. | [Specification: Level 4 and narrative rules](mirospec.md), [reference guide p. 8](miroguide.pdf), [class guide: interaction and sigils](class.md) | Sealed laboratory art, experimentation staging and physical ward access. Exact illness details remain open; current evidence text is provisional. |
| 5 — The Brother (`data/levels/level_05.json`) | Final sigil → final offer → confrontation placeholder → fatal scripted exchange → forest viewpoint and demolition storyboard → completion. | [Specification: Level 5, final encounter, narrative and cinematic rules](mirospec.md), [reference guide p. 8](miroguide.pdf), [class guide: Brother and MovementController](class.md) | Actual boss with readable rush/projectile attacks and vulnerable recovery, fatal animation, forest scene, charge reveal, tower collapse, head bow and fade. Encounter interaction currently simulates the boss handoff. |

Every blueprint also cites [Meeting 1](miromeeting1.md) for reusable components, controls and limited dialogue branching, and [Meeting 2](miromeeting2.md) for physics-enabled tiles, tiered composition and human art review. Its `sources` array records document paths and relevant sections. Level 1 has its own [source map](LEVEL_01_SCAFFOLD.md).

The floor-specific ladder openings differ, but the blockouts deliberately share a reusable three-tier structural template. Final room composition, art, sound and difficulty balance still need authoring. Later floors start with supplies for independent testing. There is no persistent inventory/casualty campaign state yet. Enter on a completed later floor loads the next scaffold; Level 5 returns to the intro. Level 1 retains its existing standalone completion behavior.

## Editing and playing

Open `scenes/levels/level_02.tscn` through `level_05.tscn` in Godot, or run `./Play Level.ps1 -Level 2` (accepts 1–5). Controls follow the intro; E interacts and Tab skips dialogue. Skipping applies the same milestone as finishing dialogue. Required stations block out-of-order progress; sigils and milestones cannot be consumed twice.

Each blueprint contains floor bands, gaps, shelves, interactables, guards, spawn, story beats, stations, dependencies and source references. `LevelPlan` contains editor markers for story beats and unfinished systems. `scripts/scaffold_level.gd` handles the shared milestone flow; `scripts/scaffold_art.gd` draws placeholder masonry.

Regenerate saved later-floor scenes with Godot's `--headless --path . --script res://tools/build_remaining_levels.gd`. This overwrites the generated scenes, so preserve manual scene edits before regenerating or make layout changes in the blueprints.

## Verification

`Run Checks.ps1` includes the Level 1 playthrough/control/scaffold regressions and `tools/test_remaining_levels.gd`. The latter walks and climbs each floor with real player physics, interacts with all stations, verifies source paths, checks idempotent completion and reaches each exit alive. These checks validate the blockout progression; they do not validate the explicitly unfinished cameras, boss or cinematic systems.
