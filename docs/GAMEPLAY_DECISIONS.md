# Current gameplay decisions

## Latest user direction: mobile timed stealth and simpler dialogue

The user's dialogue reference establishes the broad layout only: a bottom text box with speaker identification. The implementation uses a plain Oil 6 panel, text/continue/skip controls on the left and a small speaker token/name on the right. Julia's existing Miro sprite supplies his token; other tokens remain code-native placeholders. Final portrait art is not required to use the UI.

The user's latest stealth request supersedes the original class guide's stationary shadow requirement. Press **2** after collecting supplies to activate stealth anywhere, including while moving or airborne. Current tunable defaults on `IntroPlayer`:

- Duration: **5 seconds**.
- Cooldown: **8 seconds**, starting when stealth ends.
- Walking and ladder speed: **55%** of normal.
- Walking, jumping and climbing preserve stealth.
- Contact with a living guard breaks stealth and immediately alerts that guard. A corpse does not break it.
- Attacking, firing, damage, dodging or pressing 2 again cancel stealth and start the cooldown. These cancellation rules are implementation defaults for balancing; duration/cooldown/speed were not numerically specified by the user.
- Dialogue, pause and completion screens freeze stealth timers.

Guards and security cameras cannot visually detect concealed Miro. Physical guard contact is checked independently of vision. The HUD shows remaining active time or cooldown. Shadow areas still provide visual landmarks but are no longer required for activation.

The nonlethal playthrough test uses natural patrols, elevated routes and timed activations. It finishes without kills, damage or confirmed detection. Dedicated tests cover activation outside cover and in midair, slower walking, jumping, duration, cooldown, pause/dialogue, live/dead guard contact and manual cancellation.

## Checkpoint and ward interpretation

The specification requires disabling Level 3's security checkpoint and traversing Level 4's sealed experimental area. The checkpoint's physical seal opens when the linked terminal hack completes. The ward has a manual release after its experiment records; this is a simple implementation of sealed access, not a new story revelation. Both gates are reusable editable scenes driven by blueprint milestone names.

## Windows build

Run `Build Windows.ps1` to create `build/windows/Miro.exe`. The release executable contains the game pack and level JSON. Build output is ignored by Git. Matching official Godot 4.7.2 export templates are installed locally; their archive checksum was verified against the release SHA-512 list.

Launch the executable normally for a new run. For development, `Miro.exe -- --level=3` starts a specific floor. Starting a later floor is an independent test entry; it does not fabricate completed earlier sigils. Release builds do not accept Godot scene path overrides, so this argument is handled by the game itself.

Source playthrough tests and standalone executable startup checks are separate validation steps. An exported five-floor startup smoke test does not constitute a full exported playthrough.
