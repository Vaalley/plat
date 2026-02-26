# AGENTS.md

## Project: 2D Platformer

A simple 2D platformer built with Zig and Raylib.

## Tech Stack

- **Language:** Zig 0.15.1
- **Graphics:** Raylib (via raylib-zig bindings)
- **Build System:** Zig build

## Architecture

### Modules

| Module             | Purpose                                         |
| ------------------ | ----------------------------------------------- |
| `main.zig`         | Game loop, initialization, orchestration        |
| `player.zig`       | Player movement, physics, collision, dash       |
| `input.zig`        | Input gathering (keyboard → game actions)       |
| `level.zig`        | Collection of colliders and coins               |
| `collider.zig`     | Collider types (OneWay, Solid, Crumbling)       |
| `camera.zig`       | 2D camera following player                      |
| `coin.zig`         | Collectible coins                               |
| `ui.zig`           | UI drawing and debug HUD                        |
| `physics.zig`      | Collision resolution                            |
| `level_loader.zig` | JSON level loading, hot reload, arena allocator |

### Key Patterns

1. **Phase-based game loop:** Input → Update → Physics → Camera → Draw
2. **Module separation:** Each system in its own file with clear
   responsibilities
3. **Screen vs World space:** UI in screen space, game objects in world space
4. **Arena allocator:** Level data uses arena allocation - everything freed at
   once on reload

### Memory Management

- **Arena allocator** for level data: All colliders/coins allocated from arena
- **Hot reload:** Reset arena (free all), reload JSON, reallocate - no leaks, no
  fragmentation
- **Lifetime:** Level data lives for entire level duration; reset only on F5 or
  death

### Collider Behaviors

| Type      | Collision          | Special                           |
| --------- | ------------------ | --------------------------------- |
| Solid     | Blocks all sides   | -                                 |
| OneWay    | Only land from top | Pass through from below           |
| Crumbling | Like OneWay        | Timer starts on land; can respawn |

## Current State

- ✅ Player movement (left/right)
- ✅ Jumping (space)
- ✅ Dashing (shift)
- ✅ Platform collision
- ✅ Death/respawn
- ✅ Camera following player
- ✅ Double jump
- ✅ Coins to collect
- ✅ Three collider types: Solid, OneWay (pass-through), Crumbling (breaks after
  standing on it)
- ✅ JSON level loading
- ✅ Hot level reload (F5)
- ✅ Debug HUD (F1 toggle)

## Code Style

- KISS: Simple solutions over clever ones
- No premature optimization (measure first)
- Functions extracted when update() gets too long
- Magic numbers extracted as named constants
