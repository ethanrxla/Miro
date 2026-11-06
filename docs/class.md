### Character Classes

In Godot, characters should inherit from `CharacterBody2D` to handle 2D physics and collisions.

* **`BaseCharacter` (extends `CharacterBody2D`)**
* **Variables**: `health` (base 3 hearts for player), `movement_speed`, `is_dead`.


* **Methods**: `take_damage(amount)`, `die()`.
* **Details**: Provides a brief invulnerability window (e.g., ~0.8 seconds) upon taking damage to prevent instant multi-hits.




* **`Player` (extends `BaseCharacter`)**
* **Variables**: `casualty_count` (tracks guards killed for dialogue variants), `detection_state`, `is_concealed`.


* **Methods**: `handle_input()`, `toggle_stealth()`, `plant_c4()`.
* **Details**: Controls Nero/Miro and tracks the `c4_planted` flag.




* **`Guard` (extends `BaseCharacter`)**
* **Variables**: `alert_state` (Patrol, Suspicious, Alert, Search), `detection_range`, `patrol_waypoints`.


* **Methods**: `update_state_machine()`, `detect_player()`, `attack()`.
* **Details**: Uses a finite-state machine for AI and leaves a body marker upon defeat that can alert other guards.




* **`Brother` (extends `BaseCharacter`)**
* **Variables**: `current_phase`, `is_vulnerable`.
* **Methods**: `execute_rush_attack()`, `throw_projectile()`, `trigger_dialogue_exchange()`.
* **Details**: Functions as the final boss with two readable attacks and clear vulnerability windows. Defeat triggers a scripted exchange instead of an additional combat phase.





### Movement and Mechanics

A separate component can handle the core physics inputs to keep the player script clean.

* **`MovementController` (extends `Node`)**
* **Variables**: `jump_velocity`, `gravity`, `ladder_climb_speed`.
* **Methods**: `apply_gravity()`, `handle_movement()`, `climb()`, `dodge()`.
* **Details**: Maps directly to WASD for movement and ladder climbing, Space for jumping, and C for dodging.





### Inventory Item Classes

Since the design relies on fixed-use items rather than a grid inventory, these can be structured as custom `Node` or `Resource` classes.

* **`InventoryItem` (extends `Node`)**
* **Variables**: `item_name`, `input_key`.
* **Methods**: `use_item()`.


* **`Shank` (extends `InventoryItem`)**
* **Details**: Mapped to key 1. Features a short melee hitbox and short cooldown. One hit performs a stealth takedown on unaware guards, while open combat requires two hits.




* **`Cloak` / `Blanket` (extends `InventoryItem`)**
* **Details**: Mapped to key 2. Hides the player in marked shadow or wall cover zones. Moving, attacking, jumping, or leaving the cover zone immediately ends the concealment.




* **`C4_Explosive` (extends `InventoryItem`)**
* **Details**: Mapped to key 3. Breaches locks and doors, but exposes the player's position. The player plants it at designated load-bearing supports or sigil anchors.




* **`Gun` (extends `InventoryItem`)**
* **Details**: Dropped by guards. Firing the weapon exposes the player's position.





### Environment and Interactable Classes

Interactable objects should extend `Area2D` to detect when the player's collision shape enters their radius.

* **`InteractableArea` (extends `Area2D`)**
* **Variables**: `is_active`, `prompt_text`.
* **Methods**: `on_player_entered()`, `on_player_exited()`, `interact()`.
* **Details**: Listens for the interact key to trigger specific environmental actions.




* **`Door` (extends `InteractableArea`)**
* **Variables**: `requires_key`, `is_locked`.
* **Methods**: `unlock()`, `open()`.
* **Details**: Can be bypassed by using C4 on the lock or by finding a key from a guard.




* **`Ladder` (extends `Area2D`)**
* **Details**: Alters the player's movement state to allow vertical WASD movement while disabling gravity. Guards cannot climb ladders.




* **`RemoteTerminal` (extends `InteractableArea`)**
* **Variables**: `is_hacked`, `connected_cameras` (Array).
* **Methods**: `reprogram()`.
* **Details**: Interaction takes 1 second and flips connected security cameras from hostile to disabled.




* **`SecurityCamera` (extends `Area2D`)**
* **Variables**: `detection_cone`, `is_active`.
* **Methods**: `sweep()`, `trigger_alert()`.
* **Details**: Sweeps or faces a fixed direction with a colored visible cone. Raises the global floor alert if an unhidden player is spotted.




* **`BreakerPanel` / `SigilAnchor` (extends `InteractableArea`)**
* **Variables**: `has_sigil_planted`.
* **Methods**: `arm_charge()`.
* **Details**: Fixed locations where the player places the floor's sigil or C4. Planting the charge raises the alert level and can activate additional patrols.