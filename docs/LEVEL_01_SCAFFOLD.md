# Level 1 scaffold: The Prisoner

## Authoring entry points

Open `scenes/intro.tscn`. The saved scene runs directly; no generation step is required to play. Its `StoneFloors` node references the shared, physics-enabled `assets/environment/prison_tiles.tres`. All original Julia PNGs remain unchanged.

For layout work, `data/levels/level_01.json` specifies floor bands and gaps, raised tiles, walls, interactables, guards, patrol limits, spawn and the ten story/tutorial beats. `tools/build_intro.gd` converts this blueprint into the saved Godot scene. Generation replaces that scene, so use either the blueprint workflow or hand editing for a given layout revision; preserve hand edits before regenerating.

```text
ThePrisoner
  Architecture                 brick walls, cages, torches and prop placeholders
  StoneFloors                  editable TileMapLayer; shared TileSet collision
  LeftWall / RightWall
  CellDoor                     solid locked boundary
  Interactables
    Bed / CellLock             hidden supplies and three escape choices
    CellShadow / FirstRefuge / GalleryShadow / StairShadow
    FirstLadder / SecondLadder
    LandingShadow / PassageShadow / LowerShadow / ExitShadow
    VoiceGate / QuarantineOrder / SigilAnchor / StairGate
  Guards
    CorruptKeeper / GalleryKeeper / PassageKeeper / LowerKeeper
  LevelPlan
    PlayerSpawn                actual runtime spawn point
    01_WakeInCell ... 10_Exit  editor markers; purpose stored in metadata
  Player                       reusable CharacterBody2D and camera
```

Reusable scenes include the player, guard, bed, cell lock, voice gate, note, cover zone, ladder, sigil anchor and exit. The `area_size` property updates both the interaction boundary and its collision shape independently for each instance. The cell lock's drawn gate and physical `CellDoor` boundary are separate nodes: move them together when editing the cell.

## Spec and meeting traceability

| Source | Level 1 requirement | Scaffold / implementation |
| --- | --- | --- |
| Meeting 1, first-level example | Cell, key, C4, shank; quiet or offensive escape | Bed, corrupt Keeper, cell lock; all three playable routes |
| Meeting 2, tile workflow | Reusable tiles with physics | Shared prison TileSet and StoneFloors layer |
| Meeting 2, annotated sketch | Bed, torches, cages, door, guards, platforms and ladder | Three tiers, raised bypasses, two ladders, editable placements and prop placeholders |
| Class guide | CharacterBody2D, three hearts, recovery window | BaseCharacter and IntroPlayer |
| Class guide | Patrol, suspicious, alert, search; bodies alert witnesses | IntroGuard with sight-ray occlusion, corpse discovery and remembered-location searches |
| Class guide | Shank, blanket, C4, optional dropped gun | 1/2/3 item controls; guard loot enables 4 |
| Specification, Level 1 row | Teach movement, interaction, combat and first sigil | Named beats 01–10; contextual prompts; required sigil before exit |
| Specification, brother presence | Familiar voice beyond locked gate | VoiceGate and casualty-sensitive dialogue |
| PDF Level 1 flow | Lethal / quiet / loud choices converge on ladder and sigil | Escape route flag, common descent, idempotent support mark |
| Specification, restart and skipping | Restore entry state; never leave controls locked | Scene retry and shared dialogue completion logic |
| Latest user direction | Miro has amnesia; sickness follows dialogue; C4 hidden under bed | Opening sequence and supply retrieval |
| Latest user direction | Intro includes basic stealth; heights and Forward+ | Shadow teaching recesses, raised routes and Forward+ project configuration |

The latest user direction resolves the older documents' open name/amnesia questions. Detailed security cameras, hacking terminals, boss systems and later story revelations remain outside this first-floor scaffold. Basic cover is introduced here; Level 2 can develop it further.

## Art handoff

Julia's idle, jump, walk, standard, cracked and connector PNGs are already integrated. Bed, Keeper silhouette, gate, torch, masonry, cage, note and sigil visuals currently use code-native placeholders. Replace those visuals while preserving node origins and collision/interaction dimensions. The supplied Oil 6 palette remains the color reference. Music, final animation and cinematic production are separate polish work; no generated visual assets were added.

## Validation

Run `Run Checks.ps1`: three full escape-route playthroughs, keyboard/lifecycle checks, plus scaffold checks for spawn markers, shared tiles, reusable objects and independent collision sizing. The quiet route must finish without kills, damage or confirmed detection.

## Superseding stealth and dialogue direction

The current user-approved mechanic is timed mobile stealth anywhere, with duration/cooldown and contact reveal. Stationary shadow-only statements above describe the original scaffold. See [current gameplay decisions](GAMEPLAY_DECISIONS.md). Dialogue now uses a simple bottom panel with body text and controls on the left and a compact speaker token/name on the right.
