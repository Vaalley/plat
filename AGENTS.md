# AGENTS.md

## Project: 2D Platformer

A simple 2D platformer built with Zig and Raylib.

## Tech Stack

- **Language:** Zig 0.15.1
- **Graphics:** Raylib (via raylib-zig bindings)
- **Build System:** Zig build

## Architecture

### Modules

| Module         | Purpose                                   |
| -------------- | ----------------------------------------- |
| `main.zig`     | Game loop, initialization, orchestration  |
| `player.zig`   | Player movement, physics, collision, dash |
| `input.zig`    | Input gathering (keyboard → game actions) |
| `level.zig`    | Collection of platforms                   |
| `platform.zig` | Static platform definitions               |
| `camera.zig`   | 2D camera following player                |
| `coin.zig`     | Collectible coins                         |
| `ui.zig`       | UI drawing and debug HUD                  |
| `physics.zig`  | Collision resolution                      |

### Key Patterns

1. **Phase-based game loop:** Input → Update → Physics → Camera → Draw
2. **Module separation:** Each system in its own file with clear
   responsibilities
3. **Screen vs World space:** UI in screen space, game objects in world space

## Current State

- ✅ Player movement (left/right)
- ✅ Jumping (space)
- ✅ Dashing (shift)
- ✅ Platform collision
- ✅ Death/respawn
- ✅ Camera following player
- ✅ Double jump
- ✅ Coins to collect
- ✅ Debug HUD (F1 toggle)
- ✅ Basic debug level with a couple platforms and coins

## Code Style

- KISS: Simple solutions over clever ones
- No premature optimization (measure first)
- Functions extracted when update() gets too long
- Magic numbers extracted as named constants
