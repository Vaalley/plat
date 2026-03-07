//! Hazard entities (spikes, lava, etc.)
const rl = @import("raylib");

pub const Hazard = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
};

pub fn init(x: f32, y: f32, size: rl.Vector2, color: rl.Color) Hazard {
    return .{
        .position = .{ .x = x, .y = y },
        .size = size,
        .color = color,
    };
}

pub fn draw(hazard: *const Hazard) void {
    rl.drawRectangleV(hazard.position, hazard.size, hazard.color);
}

pub fn get_hitbox(hazard: *const Hazard) rl.Rectangle {
    return rl.Rectangle{
        .x = hazard.position.x,
        .y = hazard.position.y,
        .width = hazard.size.x,
        .height = hazard.size.y,
    };
}
