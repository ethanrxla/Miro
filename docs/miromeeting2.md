## Key Concepts

- The project is being developed in Godot using reusable 32×32-style tiles, with the current tile dimensions clarified as approximately 28×28×27.
- Tiles require physics/collision configuration in the TileSet so the player can stand on and interact with level geometry.
- The player character currently supports movement, jumping, idle animation, and collision handling, though the player hitbox and vertical positioning still need adjustment.
- The first level is envisioned as a prison/tower introduction featuring Miro/Nero in a cell, a bed, C4, a key, a gun, a collapsed or sick guard, torches, doors, brick walls, platforms, ladders, and stealth opportunities.
- The team is using GitHub as the shared repository. Julia pushed initial environmental assets, and the team discussed cloning, staging, committing, pushing, and pulling changes.
- The team is exploring an MCP connection to Godot so an AI coding agent can implement controlled changes from prompts, screenshots, and design documents rather than autonomously generating an entire game.
- AI-generated level layouts should be reviewed and polished by the team to preserve the intended gameplay and visual direction.

## Worked Examples

- A basic tile workflow was demonstrated: add physics to a TileSet, create reusable tiles, and place them in a TileMap.
- A rough first-level sketch showed a cell, bed, C4, key, gun, torch, door, guards, platforms, a ladder, and optional collectibles.
- The player was demonstrated moving forward and backward and jumping as a baseline prototype.
- A proposed workflow is to provide an annotated level screenshot and supporting game documents to an AI agent, generate an initial layout, and then have Julia refine the tiles, assets, and visual details.

## Quick Checks

- Julia has pushed the current assets, including environmental elements and a crack tile, to the GitHub repository.
- Fran has access to the repository and plans to contribute mechanics code and testing after the foundational structure is available.
- The first level needs a concrete asset list and a more detailed visual/layout reference.
- The player collision box and starting height require debugging before the prototype is considered stable.
- The repository structure and Godot-to-Git workflow still need to be documented and verified.
- Potential future assets include moss tiles, crates, mushrooms or other power-up objects, torches, cages, and themed environmental pieces.

## Decisions

- Use Godot and GitHub as the core development tools.
- Use reusable tiles with physics/collision configured in the TileSet.
- Focus initial development on the prison/tower first level and its introductory sequence.
- Julia will continue creating and pushing environmental assets to the repository.
- The project lead will use the shared assets and character classes to establish the initial game structure and mechanics.
- Fran will contribute mechanics code and testing once the baseline structure is available.
- Explore MCP/AI-assisted Godot development for controlled level and code generation, with human review and polish.
- Use the annotated first-level sketch and related design documents as references for future AI prompts.
- Consider adding music and additional environmental assets, including brick backgrounds, moss, crates, and possible power-ups.

## Risks

- The player hitbox and vertical positioning are currently misaligned, causing the character to behave incorrectly in the scene.
- Team members are still learning the Godot workflow and are uncertain about how to synchronize Godot changes with GitHub.
- The repository structure and complete game-file organization are not yet finalized.
- AI-generated levels may drift from the intended design or appear generic unless reviewed and refined by the team.
- The first level’s exact layout, asset requirements, and visual style remain only partially specified.
- Team availability is constrained by classes, travel, and other commitments.
- Additional mechanics such as stealth, guard behavior, item interaction, sickness, and power-ups are not yet fully defined.
- The MCP integration is exploratory and may introduce technical setup or reliability issues.

## Recommendations

- Push the Godot project assets and reusable tile files to the GitHub repository.
- Add physics and collision configuration to the reusable tiles and fix the player hitbox and character positioning issues.
- Create a list of requested assets for the intro and first level, including prison cells, beds, doors, keys, guns, torches, C4, brick walls, cracks, moss, crates, and related environmental elements.
- Continue creating and pushing environmental assets to the repository, including the crack tile and potential moss, crate, mushroom, and brick-background elements.
- Use the rough annotated sketch as a reference to block out the first level, starting with the protagonist's cell, bed, C4, collapsed guard, dropped key and gun, door, torches, platforms, ladders, guards, and optional stealth routes.
- Set up the initial game blueprint in Godot using the existing character classes and repository assets.
- Implement and test core mechanics, including movement, jumping, guard behavior, stealth interactions, pickups, and other mechanics needed for the first-level flow.
- Have Fran contribute coding and testing, and review the implemented mechanics for missing behaviors.

## Action items

- [ ] Push the Godot project files and reusable tile assets to the GitHub repository — Julia
- [ ] Add additional environmental assets for the first level and intro, including prison/dungeon elements such as torches, cages, moss, cracks, crates, and related tiles — Julia
- [ ] Create a list of desired assets and ideas for the intro and first level
- [ ] Add the character classes/code guide to the GitHub repository and use them as the foundation for the game's mechanics
- [ ] Set up the game's initial mechanics and implementation using the repository assets and character classes
- [ ] Work on coding and testing the game mechanics, including identifying missing mechanics and testing the playable baseline — Fran (due Nov 7)
- [ ] Create a basic base model and variations for different guard types and implement guard behavior
- [ ] Create music or beats for the game — Julia
- [ ] Create a custom dark brick-style background for the game — Julia
- [ ] Create or generate a first-level layout from the annotated screenshot and project documents, then have Julia polish it
- [ ] Review any AI-generated level design to ensure it matches the intended game concept and does not look generic or disconnected from the design