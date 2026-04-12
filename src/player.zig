//! Player movement, physics state, and abilities (jump, dash).
const rl = @import("raylib");

const input_mod = @import("input.zig");
const config = @import("config.zig");

pub const Player = struct {
    position: rl.Vector2,
    spawn_position: rl.Vector2,
    velocity: rl.Vector2,
    acceleration: rl.Vector2,

    // Movement parameters
    move_speed: f32,
    gravity: f32,
    jump_power: f32,
    jumps_remaining: u32,
    dash_cooldown: f32,
    dash_power: f32,

    // Collision
    hitbox_width: f32,
    hitbox_height: f32,
    is_grounded: bool,

    // Collectibles
    coins_collected: u32,
};

pub fn init(spawn_x: f32, spawn_y: f32) Player {
    return .{
        .position = .{ .x = spawn_x, .y = spawn_y },
        .spawn_position = .{ .x = spawn_x, .y = spawn_y },
        .velocity = .{ .x = 0, .y = 0 },
        .acceleration = .{ .x = 0, .y = 0 },
        .move_speed = config.PLAYER_MOVE_SPEED,
        .jump_power = config.PLAYER_JUMP_POWER,
        .gravity = config.PLAYER_GRAVITY,
        .dash_power = config.PLAYER_DASH_POWER,
        .dash_cooldown = 0,
        .jumps_remaining = config.PLAYER_MAX_JUMPS,
        .hitbox_width = config.PLAYER_HITBOX_WIDTH,
        .hitbox_height = config.PLAYER_HITBOX_HEIGHT,
        .is_grounded = false,
        .coins_collected = 0,
    };
}

pub fn respawnPlayer(player: *Player) void {
    player.position = player.spawn_position;
    player.velocity = .{ .x = 0, .y = 0 };
    player.acceleration = .{ .x = 0, .y = 0 };
    player.dash_cooldown = 0;
    player.is_grounded = false;
    player.jumps_remaining = config.PLAYER_MAX_JUMPS;
}

pub fn update(player: *Player, deltaTime: f32, input: input_mod.InputState) void {
    handleMovement(player, input);
    handleJump(player, input);
    handleDash(player, input, deltaTime);

    // Reset grounded state before collision resolution
    player.is_grounded = false;

    // Gravity
    player.velocity.y += player.gravity * deltaTime;

    updatePosition(player, deltaTime);
}

pub fn draw(player: *Player) void {
    rl.drawRectangleV(player.position, .{ .x = player.hitbox_width, .y = player.hitbox_height }, rl.Color.orange);
}

pub fn get_hitbox(player: *Player) rl.Rectangle {
    return .{
        .x = player.position.x,
        .y = player.position.y,
        .width = player.hitbox_width,
        .height = player.hitbox_height,
    };
}

fn handleMovement(player: *Player, input: input_mod.InputState) void {
    // During dash, don't allow movement input (for the first lockout duration)
    if (player.dash_cooldown > config.PLAYER_DASH_COOLDOWN - config.PLAYER_DASH_LOCKOUT_DURATION) return;

    if (input.move_left and !input.move_right) {
        player.velocity.x = -player.move_speed;
    } else if (input.move_right and !input.move_left) {
        player.velocity.x = player.move_speed;
    } else {
        player.velocity.x = 0;
    }
}

fn handleJump(player: *Player, input: input_mod.InputState) void {
    if (input.jump and (player.is_grounded or player.jumps_remaining > 0)) {
        player.velocity.y = -player.jump_power;
        player.is_grounded = false;
        player.jumps_remaining -= 1;
    }
}

fn updatePosition(player: *Player, deltaTime: f32) void {
    player.position.x += player.velocity.x * deltaTime;
    player.position.y += player.velocity.y * deltaTime;

    if (player.position.y > config.DEATH_Y) {
        respawnPlayer(player);
    }
}

fn handleDash(player: *Player, input: input_mod.InputState, deltaTime: f32) void {
    // Decrease cooldown
    if (player.dash_cooldown > 0) {
        player.dash_cooldown -= deltaTime;
    }

    // Start dash
    if (input.dash and player.dash_cooldown <= 0) {
        // Dash in current facing direction
        const dashDirection: f32 = if (player.velocity.x >= 0) 1.0 else -1.0;
        player.velocity.x = dashDirection * player.dash_power;
        player.dash_cooldown = config.PLAYER_DASH_COOLDOWN;
    }
}
