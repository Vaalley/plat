# Plat

A simple 2D platformer written in Zig using Raylib.

## Build & Run

```bash
zig build run
```

## Controls

Check `src/input.zig` for input handling.

## Structure

- `src/main.zig` - Entry point and game loop
- `src/player.zig` - Player logic
- `src/level.zig` - Level/world management
- `src/input.zig` - Input handling
- `src/platform.zig` - Platform/collision utilities

## Dependencies

- [Raylib](https://www.raylib.com/) - Graphics/Windowing
