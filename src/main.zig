const rl = @import("raylib");
const std = @import("std");

const player_mod = @import("player.zig");
const input_mod = @import("input.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const physics_mod = @import("physics.zig");
const ui_mod = @import("ui.zig");
const level_loader_mod = @import("level_loader.zig");

pub fn main() anyerror!void {
    // this is just to test the level loader, it will be removed later
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit(); // Frees EVERYTHING at once

    const level_data = try level_loader_mod.load_level_data_from_file(arena.allocator(), "level_1.json");
    std.debug.print("Level name: {s}\n", .{level_data.name});
    std.debug.print("Player spawn point: {d}, {d}\n", .{ level_data.player_spawn_point.position_x, level_data.player_spawn_point.position_y });
    std.debug.print("Number of platforms: {d}\n", .{level_data.platforms.len});
    std.debug.print("Number of coins: {d}\n", .{level_data.coins.len});
    // this is just to test the level loader, it will be removed later

    // Initialization phase - set up window and basic systems
    const screenWidth = 1280;
    const screenHeight = 720;

    rl.setConfigFlags(.{ .window_resizable = true, .vsync_hint = true });

    rl.initWindow(screenWidth, screenHeight, "plat");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setWindowMinSize(720, 480);

    // rl.setTargetFPS(60);

    // Initialize game objects
    var player: player_mod.Player = player_mod.init();
    var input = input_mod.init();
    var level: level_mod.Level = level_mod.init();
    var camera: camera_mod.Camera = camera_mod.init(screenWidth, screenHeight);

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const deltaTime: f32 = rl.getFrameTime();

        // Input phase - gather all inputs
        input_mod.update(&input);

        // Update phase - process game logic
        player_mod.update(&player, deltaTime, input);

        // Physics phase - resolve movement and collisions
        physics_mod.resolvePlayerCollisions(&player, &level);

        // Camera phase - update camera position
        camera_mod.update(&camera, &player);

        // Draw phase - render everything
        rl.beginDrawing();
        rl.clearBackground(.white);
        rl.beginMode2D(camera.camera);

        player_mod.draw(&player);
        level_mod.draw(&level);

        // We don't want to defer this right after beginMode2D because we may want to draw UI stuff independent of the camera (in between endMode2D and endDrawing)
        rl.endMode2D();
        if (input.show_debug) {
            ui_mod.draw_debug_hud(&player, &level, &camera);
        }

        ui_mod.draw_text(@intCast(screenWidth - 100), 10, 20, rl.Color.black, "Coins: {d}", .{player.coins_collected});
        rl.endDrawing();
    }
}
