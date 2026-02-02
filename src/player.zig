const rl = @import("raylib");

const input_mod = @import("input.zig");

const level_mod = @import("level.zig");

pub const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    acceleration: rl.Vector2,

    // Movement parameters
    moveSpeed: f32,
    jumpPower: f32,
    gravity: f32,

    // Collision
    hitboxWidth: f32,
    hitboxHeight: f32,
    isGrounded: bool,
};

pub fn init() Player {
    return .{
        .position = .{ .x = 100, .y = 100 },
        .velocity = .{ .x = 0, .y = 0 },
        .acceleration = .{ .x = 0, .y = 0 },
        .moveSpeed = 200,
        .jumpPower = 400,
        .gravity = 800,
        .hitboxWidth = 32,
        .hitboxHeight = 64,
        .isGrounded = false,
    };
}

pub fn update(player: *Player, deltaTime: f32, input: input_mod.InputState, level: *level_mod.Level) void {
    if (input.move_left and !input.move_right) {
        player.velocity.x = -player.moveSpeed;
    } else if (input.move_right and !input.move_left) {
        player.velocity.x = player.moveSpeed;
    } else {
        player.velocity.x = 0;
    }

    // Apply gravity
    player.velocity.y += player.gravity * deltaTime;

    // Update position and hitbox
    player.position.x += player.velocity.x * deltaTime;
    player.position.y += player.velocity.y * deltaTime;

    // Handle jumping
    if (input.jump and player.isGrounded) {
        player.velocity.y = -player.jumpPower;
        player.isGrounded = false;
    }

    // Reset grounded state
    player.isGrounded = false;

    const floorY = @as(f32, @floatFromInt(rl.getScreenHeight())) - player.hitboxHeight;
    // Check collisions
    // Floor
    if (player.position.y >= floorY and player.velocity.y >= 0) {
        player.position.y = floorY;
        player.velocity.y = 0;
        player.isGrounded = true;
    }
    // Platforms
    for (level.platforms) |platform| {
        const feetY = player.position.y + player.hitboxHeight;
        const platformTop = platform.hitbox.y;
        const nearTop = feetY >= platformTop and feetY <= platformTop + 10.0;

        if (rl.checkCollisionRecs(getHitbox(player), platform.hitbox) and player.velocity.y >= 0 and nearTop) {
            player.isGrounded = true;
            player.position.y = platform.hitbox.y - player.hitboxHeight;
            player.velocity.y = 0;
        }
    }
}

pub fn draw(player: *Player) void {
    rl.drawRectangleV(
        player.position,
        .{ .x = player.hitboxWidth, .y = player.hitboxHeight },
        .{ .r = 255, .g = 0, .b = 0, .a = 255 },
    );
}

pub fn getHitbox(player: *Player) rl.Rectangle {
    return .{
        .x = player.position.x,
        .y = player.position.y,
        .width = player.hitboxWidth,
        .height = player.hitboxHeight,
    };
}
