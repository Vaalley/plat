const rl = @import("raylib");

const input_mod = @import("input.zig");
const level_mod = @import("level.zig");
const platform_mod = @import("platform.zig");

const LANDING_TOLERANCE: f32 = 10.0;
const DEATH_Y: f32 = 800.0; // below screen
const DASH_LOCKOUT_DURATION: f32 = 0.2;
const DASH_COOLDOWN: f32 = 1.0;

pub const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    acceleration: rl.Vector2,

    // Movement parameters
    moveSpeed: f32,
    gravity: f32,
    jumpPower: f32,
    jumpsRemaining: u32,
    dashCooldown: f32,
    dashPower: f32,

    // Collision
    hitboxWidth: f32,
    hitboxHeight: f32,
    isGrounded: bool,

    // Collectibles
    coinsCollected: u32,
};

pub fn init() Player {
    return .{
        .position = .{ .x = 100, .y = 100 },
        .velocity = .{ .x = 0, .y = 0 },
        .acceleration = .{ .x = 0, .y = 0 },
        .moveSpeed = 200,
        .jumpPower = 550,
        .gravity = 1500,
        .dashPower = 800,
        .dashCooldown = 0,
        .jumpsRemaining = 2,
        .hitboxWidth = 32,
        .hitboxHeight = 64,
        .isGrounded = false,
        .coinsCollected = 0,
    };
}

pub fn reset(player: *Player) void {
    player.position = .{ .x = 100, .y = 100 };
    player.velocity = .{ .x = 0, .y = 0 };
    player.acceleration = .{ .x = 0, .y = 0 };
    player.dashCooldown = 0;
    player.isGrounded = false;
    player.coinsCollected = 0;
    player.jumpsRemaining = 2;
}

pub fn update(player: *Player, deltaTime: f32, input: input_mod.InputState, level: *level_mod.Level) void {
    handleMovement(player, input);
    handleJump(player, input);
    handleDash(player, input, deltaTime);

    // Reset grounded state before collision resolution
    player.isGrounded = false;

    // Gravity
    player.velocity.y += player.gravity * deltaTime;

    updatePosition(player, deltaTime);
    resolveCollisions(player, level);
    if (player.isGrounded) {
        player.jumpsRemaining = 2;
    }
}

pub fn draw(player: *Player) void {
    rl.drawRectangleV(player.position, .{ .x = player.hitboxWidth, .y = player.hitboxHeight }, rl.Color.orange);
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
    // During dash, don't allow movement input (for the first 0.2 seconds) - A dash is 1 second long
    if (player.dashCooldown > DASH_COOLDOWN - DASH_LOCKOUT_DURATION) return;

    if (input.move_left and !input.move_right) {
        player.velocity.x = -player.moveSpeed;
    } else if (input.move_right and !input.move_left) {
        player.velocity.x = player.moveSpeed;
    } else {
        player.velocity.x = 0;
    }
}

fn handleJump(player: *Player, input: input_mod.InputState) void {
    if (input.jump and (player.isGrounded or player.jumpsRemaining > 0)) {
        player.velocity.y = -player.jumpPower;
        player.isGrounded = false;
        player.jumpsRemaining -= 1;
    }
}

fn updatePosition(player: *Player, deltaTime: f32) void {
    player.position.x += player.velocity.x * deltaTime;
    player.position.y += player.velocity.y * deltaTime;

    if (player.position.y > DEATH_Y) {
        reset(player);
    }
}

fn resolveCollisions(player: *Player, level: *level_mod.Level) void {
    const feetY = player.position.y + player.hitboxHeight;

    // Platforms
    for (0..level.platform_count) |index| {
        const platform = level.platforms[index];
        const platformHitbox = platform_mod.getHitbox(&platform);
        const platformTop = platformHitbox.y;
        const nearTop = feetY >= platformTop and feetY <= platformTop + LANDING_TOLERANCE;

        if (rl.checkCollisionRecs(getHitbox(player), platformHitbox) and player.velocity.y >= 0 and nearTop) {
            player.isGrounded = true;
            player.position.y = platformHitbox.y - player.hitboxHeight;
            player.velocity.y = 0;
        }
    }

    // Coins
    for (0..level.coin_count) |index| {
        const coin = &level.coins[index];
        if (!coin.isCollected and rl.checkCollisionCircleRec(coin.position, coin.radius, getHitbox(player))) {
            coin.isCollected = true;
            player.coinsCollected += 1;
        }
    }
}

fn handleDash(player: *Player, input: input_mod.InputState, deltaTime: f32) void {
    // Decrease cooldown
    if (player.dashCooldown > 0) {
        player.dashCooldown -= deltaTime;
    }

    // Start dash
    if (input.dash and player.dashCooldown <= 0) {
        // Dash in current facing direction
        const dashDirection: f32 = if (player.velocity.x >= 0) 1.0 else -1.0;
        player.velocity.x = dashDirection * player.dashPower;
        player.dashCooldown = DASH_COOLDOWN;
    }
}
