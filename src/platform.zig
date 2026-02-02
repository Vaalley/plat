const std = @import("std");
const rl = @import("raylib");

pub const Platform = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
    hitbox: rl.Rectangle,
};

pub fn init(position: rl.Vector2, size: rl.Vector2, color: rl.Color) Platform {
    return .{
        .position = position,
        .size = size,
        .color = color,
        .hitbox = .{ .x = position.x, .y = position.y, .width = size.x, .height = size.y },
    };
}

pub fn draw(platform: *const Platform) void {
    rl.drawRectangle(@intFromFloat(platform.position.x), @intFromFloat(platform.position.y), @intFromFloat(platform.size.x), @intFromFloat(platform.size.y), platform.color);
}
