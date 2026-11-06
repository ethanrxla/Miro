# Miro local baseline

## Open and play

Project: `C:\towerdefense\Miro\project.godot`.
Run `Open Miro.ps1` to edit, then F5 to play. `Play Miro.ps1` starts the intro directly.
Desktop shortcuts are also provided. Move with A/D or arrows, jump with Space, reset with R.

The first story floor is now implemented with Forward+ rendering. See [the intro guide](INTRO.md) for its controls, three escape choices, guard detection, tiered layout and verification. The original asset sandbox remains available as `scenes/asset_sandbox.tscn`.

## Versions and locations

- Miro cloned from https://github.com/ethanrxla/Miro.git at `dc022529027d9dad73337d1b95bc181f9568e09f`, verified against remote HEAD during setup.
- Godot standard 4.7.2, official build `ed1daf0bf`, in `C:\towerdefense\tools\godot`. Download SHA-512 verified against the official release checksum file.
- Coding-Solo server cloned into `C:\towerdefense\MCP\godot-mcp`, upstream commit `1209744fad78f3998f98c7394fd0f6ef50da5281`.
- Server dependencies updated locally: MCP SDK 1.32.2 and compatible dependency fixes. Build and MCP checks pass; npm audit reports zero vulnerabilities. Keep the local package files when updating upstream.
- Codex global MCP name: `godot`, stdio command `C:\Program Files\nodejs\node.exe`, argument `C:\towerdefense\MCP\godot-mcp\build\index.js`, GODOT_PATH points to the installed console executable.
- Server starts on demand through Codex; no separate daemon or cloud account is needed.

## Natural-language level work

In Codex, ask: "In C:\towerdefense\Miro, create a draft Level 1 prison scene using Julia's tiles and the reusable player. Follow docs/class.md and docs/miroguide.pdf, then run it and inspect debug output."

The AI interprets the request and uses filesystem edits plus MCP tools. The server itself is not an NLP model. Available tools include scene creation, adding nodes, loading sprites, saving scenes, launching the editor, running/stopping the game, and reading debug output. Changes made by MCP are saved to disk; reopen a scene if the editor has stale unsaved state.

## Assets

Original PNGs are unchanged:

| Asset | Size | Use |
| --- | --- | --- |
| miro_idle.png | 32 x 32 | Idle |
| miro_jump.png | 32 x 32 | Jump |
| miro_walk.png | 64 x 32 | Two 32 x 32 walk frames |
| standard_tile.png | 28 x 27 | Floor |
| cracked_tile.png | 28 x 27 | Floor variation |
| connector.png | 28 x 27 | Floor connector |

Nearest filtering preserves pixel art. Tiles are intentionally not assumed to be 32 x 32. The Kenney archive stays in the parent workspace, outside Godot imports. Reference documents were copied from the supplied workspace docs.

## Alternative MCP

https://godotengine.org/asset-library/asset/5245 is IvanMurzak/Godot-MCP, a separate .NET addon with .NET SDK/NuGet and cloud or self-hosted backend requirements. It was reviewed but not installed; the requested Coding-Solo server is active.

## Verification

- Headless editor import: all six textures imported, scripts parsed.
- Headless sandbox run: clean exit after 120 frames.
- SDK smoke check: 14 tools discovered; version, project inspection, scene creation, node insertion, texture loading passed.
- Native Codex godot tool: version and project launch passed.
- The upstream headless load_sprite helper emits a dummy-renderer texture RID cleanup warning at exit; the saved scene and texture are valid. The actual sandbox run does not emit this warning.
- Re-run integration check: `node C:\towerdefense\MCP\godot-mcp\smoke-test.mjs`.

The initial setup and intro were pushed in commit `40e1c5a`. See Git status for subsequent local changes.
