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
    handleMovement(player, input);
    handleJump(player, input);

    // Apply Gravity (could be moved to a separate function in the future, for now it's simple)
    player.velocity.y += player.gravity * deltaTime;

    updatePosition(player, deltaTime);

    // Reset grounded state
    player.isGrounded = false;

    resolveCollisions(player, level);
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

fn handleMovement(player: *Player, input: input_mod.InputState) void {
    if (input.move_left and !input.move_right) {
        player.velocity.x = -player.moveSpeed;
    } else if (input.move_right and !input.move_left) {
        player.velocity.x = player.moveSpeed;
    } else {
        player.velocity.x = 0;
    }
}

fn handleJump(player: *Player, input: input_mod.InputState) void {
    if (input.jump and player.isGrounded) {
        player.velocity.y = -player.jumpPower;
        player.isGrounded = false;
    }
}

fn updatePosition(player: *Player, deltaTime: f32) void {
    const DEATH_Y: f32 = 800.0; // below screen

    player.position.x += player.velocity.x * deltaTime;
    player.position.y += player.velocity.y * deltaTime;

    if (player.position.y > DEATH_Y) {
        // Respawn or game over
        player.position = .{ .x = 100, .y = 100 };
        player.velocity = .{ .x = 0, .y = 0 };
    }
}

fn resolveCollisions(player: *Player, level: *level_mod.Level) void {
    const LANDING_TOLERANCE: f32 = 10.0;
    const feetY = player.position.y + player.hitboxHeight;

    // Platforms
    for (level.platforms) |platform| {
        const platformTop = platform.hitbox.y;
        const nearTop = feetY >= platformTop and feetY <= platformTop + LANDING_TOLERANCE;

        if (rl.checkCollisionRecs(getHitbox(player), platform.hitbox) and player.velocity.y >= 0 and nearTop) {
            player.isGrounded = true;
            player.position.y = platform.hitbox.y - player.hitboxHeight;
            player.velocity.y = 0;
        }
    }
}
