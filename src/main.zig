const rl = @import("raylib");

const player_mod = @import("player.zig");
const input_mod = @import("input.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");

fn drawDebugHUD(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera) void {
    _ = player;
    _ = level;
    _ = camera;
    const fontSize = 20;

    // TODO: Implement debug HUD drawing
    rl.drawText("Debug HUD", 10, 10, fontSize, rl.Color.black);
    rl.drawFPS(10, 20 + fontSize);
}

pub fn main() anyerror!void {
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
        player_mod.update(&player, deltaTime, input, &level);

        // Physics phase - resolve movement and collisions
        // ResolveCollisions();

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
            drawDebugHUD(&player, &level, &camera);
        }
        rl.endDrawing();
    }
}
