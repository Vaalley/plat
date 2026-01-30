const rl = @import("raylib");
const input_mod = @import("input.zig");
const InputState = input_mod.InputState;

pub const PlayerState = enum {
    STATE_IDLE,
    STATE_RUNNING,
    STATE_JUMPING,
    STATE_FALLING,
    STATE_WALL_SLIDING,
    STATE_DASHING,
    STATE_ATTACKING,
};

pub const Player = struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    acceleration: rl.Vector2,

    state: PlayerState,
    previousState: PlayerState,

    // Timers for state transitions
    coyoteTime: f32,
    jumpBufferTime: f32,

    // Movement parameters
    moveSpeed: f32,
    jumpPower: f32,
    gravity: f32,

    // Collision
    hitbox: rl.Rectangle,
    isGrounded: bool,
    isTouchingWall: bool,
    wallDirection: i32, // -1 for left, 1 for right

    // Animation
    currentFrame: i32,
    animationTimer: f32,
};

pub fn init() Player {
    return .{
        .position = .{ .x = 100, .y = 100 },
        .velocity = .{ .x = 0, .y = 0 },
        .acceleration = .{ .x = 0, .y = 0 },
        .state = .STATE_IDLE,
        .previousState = .STATE_IDLE,
        .coyoteTime = 0,
        .jumpBufferTime = 0,
        .moveSpeed = 200,
        .jumpPower = 400,
        .gravity = 800,
        .hitbox = .{ .x = 0, .y = 0, .width = 32, .height = 64 },
        .isGrounded = false,
        .isTouchingWall = false,
        .wallDirection = 0,
        .currentFrame = 0,
        .animationTimer = 0,
    };
}

pub fn update(player: *Player, input: InputState, deltaTime: f32) void {
    if (input.move_left and !input.move_right) {
        player.velocity.x = -player.moveSpeed;
    } else if (input.move_right and !input.move_left) {
        player.velocity.x = player.moveSpeed;
    } else {
        player.velocity.x = 0;
    }

    // Apply gravity
    // player.velocity.y += player.gravity * deltaTime;

    // Update position
    player.position.x += player.velocity.x * deltaTime;
    player.position.y += player.velocity.y * deltaTime;
}

pub fn draw(player: *Player) void {
    rl.drawRectangleV(
        player.position,
        .{ .x = player.hitbox.width, .y = player.hitbox.height },
        .{ .r = 255, .g = 0, .b = 0, .a = 255 },
    );
}
