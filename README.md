# Plat

A simple 2D platformer written in Zig using Raylib.

## Build & Run

```bash
zig build run
```

## Controls

- **A** / **D** or **←** / **→** - Move left/right
- **Space** - Jump (double jump available)
- **Shift** - Dash
- **F1** - Toggle debug HUD
- **F5** - Reload level from JSON (hot reload)

You may also check `src/input.zig` for the input configuration.

## Structure

- `src/main.zig` - Entry point and game loop
- `src/player.zig` - Player logic
- `src/level.zig` - Level/world management
- `src/collider.zig` - Collider definitions (OneWay, Solid)
- `src/input.zig` - Input handling
- `src/coin.zig` - Coin collection logic
- `src/camera.zig` - Camera management
- `src/ui.zig` - User interface elements
- `src/physics.zig` - Physics and collision resolution
- `src/level_loader.zig` - JSON level loading and hot reload

## Dependencies

- [Raylib](https://www.raylib.com/) - Graphics/Windowing

## Level Editing

Levels are defined in `assets/levels/level_1.json`. Edit while the game is
running and press **F5** to reload instantly.
