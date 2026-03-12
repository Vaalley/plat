//! Checkpoint system for level progression
const rl = @import("raylib");

pub const Checkpoint = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
    active_color: rl.Color,
    is_active: bool,
};

pub fn init(position: rl.Vector2, size: rl.Vector2) Checkpoint {
    return Checkpoint{
        .position = position,
        .size = size,
        .color = rl.Color.blue,
        .active_color = rl.Color.sky_blue,
        .is_active = false,
    };
}

pub fn draw(checkpoint: *Checkpoint) void {
    if (checkpoint.is_active) {
        rl.drawRectangleV(checkpoint.position, checkpoint.size, checkpoint.active_color);
    } else {
        rl.drawRectangleV(checkpoint.position, checkpoint.size, checkpoint.color);
    }
}

pub fn get_hitbox(checkpoint: *Checkpoint) rl.Rectangle {
    return rl.Rectangle{
        .x = checkpoint.position.x,
        .y = checkpoint.position.y,
        .width = checkpoint.size.x,
        .height = checkpoint.size.y,
    };
}
