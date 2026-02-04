const rl = @import("raylib");

const player_mod = @import("player.zig");
const input_mod = @import("input.zig");
const level_mod = @import("level.zig");

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

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        const deltaTime: f32 = rl.getFrameTime();

        // Input phase - gather all inputs
        input_mod.update(&input);

        // Update phase - process game logic
        player_mod.update(&player, deltaTime, input, &level);

        // Physics phase - resolve movement and collisions
        // ResolveCollisions();

        // Draw phase - render everything
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);
        rl.drawFPS(10, 10);

        player_mod.draw(&player);
        level_mod.draw(&level);
    }
}
