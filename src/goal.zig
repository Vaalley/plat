//! Goal system for level completion
const rl = @import("raylib");

pub const Goal = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
    next_level: ?[]const u8,
};

pub fn init(position: rl.Vector2, size: rl.Vector2, next_level: ?[]const u8) Goal {
    return Goal{
        .position = position,
        .size = size,
        .color = rl.Color.blue,
        .next_level = next_level,
    };
}

pub fn draw(goal: *const Goal) void {
    rl.drawRectangleV(goal.position, goal.size, goal.color);
}

pub fn get_hitbox(goal: *const Goal) rl.Rectangle {
    return rl.Rectangle{
        .x = goal.position.x,
        .y = goal.position.y,
        .width = goal.size.x,
        .height = goal.size.y,
    };
}
