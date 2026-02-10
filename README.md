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

You may also check `src/input.zig` for the input configuration.

## Structure

- `src/main.zig` - Entry point and game loop
- `src/player.zig` - Player logic
- `src/level.zig` - Level/world management
- `src/input.zig` - Input handling
- `src/platform.zig` - Platform/collision utilities
- `src/coin.zig` - Coin collection logic
- `src/camera.zig` - Camera management
- `src/ui.zig` - User interface elements
- `src/physics.zig` - Physics and collision resolution

## Dependencies

- [Raylib](https://www.raylib.com/) - Graphics/Windowing
