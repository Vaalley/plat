//! Main entry point and game loop orchestration.
const std = @import("std");

const rl = @import("raylib");

const player_mod = @import("player.zig");
const input_mod = @import("input.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const physics_mod = @import("physics.zig");
const ui_mod = @import("ui.zig");
const level_loader_mod = @import("level_loader.zig");

const FIRST_LEVEL_PATH = "assets/levels/level_1.json";
const MAX_PATH_LEN = 260;

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit(); // Frees EVERYTHING at once

    // Initialization phase - set up window and basic systems
    const SCREEN_WIDTH = 1280;
    const MIN_SCREEN_WIDTH = 720;
    const SCREEN_HEIGHT = 720;
    const MIN_SCREEN_HEIGHT = 480;
    var current_level_path: []const u8 = FIRST_LEVEL_PATH;
    var current_level_path_buffer: [MAX_PATH_LEN]u8 = undefined;

    rl.setConfigFlags(.{ .window_resizable = true, .vsync_hint = true });

    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "plat");
    defer rl.closeWindow(); // Close window and OpenGL context
    rl.setWindowMinSize(MIN_SCREEN_WIDTH, MIN_SCREEN_HEIGHT);
    rl.maximizeWindow();

    // rl.setTargetFPS(60);

    // Initialize game objects
    const level_data = try level_loader_mod.loadLevelDataFromFile(arena.allocator(), current_level_path);
    var player: player_mod.Player = player_mod.init(level_data.player_spawn_point.position_x, level_data.player_spawn_point.position_y);
    var input = input_mod.init();
    var level = try level_loader_mod.buildLevel(level_data, arena.allocator());
    var camera: camera_mod.Camera = camera_mod.init(
        @as(f32, @floatFromInt(rl.getScreenWidth())),
        @as(f32, @floatFromInt(rl.getScreenHeight())),
    );

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const DELTA_TIME: f32 = rl.getFrameTime();
        const CURRENT_SCREEN_WIDTH: i32 = rl.getScreenWidth();
        const CURRENT_SCREEN_HEIGHT: i32 = rl.getScreenHeight();

        if (!level.is_completed) {
            // Input phase - gather all inputs
            input_mod.update(&input);

            // Update phase - process game logic
            player_mod.update(&player, DELTA_TIME, input);
            level_mod.update(&level, DELTA_TIME);
            if (input.reload_level) {
                try level_loader_mod.loadLevelFromPath(&arena, &level, &player, current_level_path);
            }

            // Physics phase - resolve movement and collisions
            physics_mod.resolvePlayerCollisions(&player, &level);
        } else {
            level.completion_timer -= DELTA_TIME;
            if (level.completion_timer <= 0) {
                if (level.goal) |goal| {
                    if (goal.next_level) |next_level_path| {
                        current_level_path = try std.fmt.bufPrint(&current_level_path_buffer, "{s}", .{next_level_path});
                        try level_loader_mod.loadLevelFromPath(&arena, &level, &player, current_level_path);
                    }
                }
            }
        }

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

        ui_mod.drawDebugHud(&player, &level, &camera, input.show_debug);

        // Coin counter in the top right corner
        ui_mod.drawText(@intCast(CURRENT_SCREEN_WIDTH - 100), 10, 20, rl.Color.black, "Coins: {d}", .{player.coins_collected});

        if (level.is_completed) {
            ui_mod.drawText(
                @intCast(@divTrunc(CURRENT_SCREEN_WIDTH, 2)),
                @intCast(@divTrunc(CURRENT_SCREEN_HEIGHT, 2)),
                40,
                rl.Color.black,
                "Level completed! Loading next level...",
                .{},
            );
        }

        rl.endDrawing();
    }
}
