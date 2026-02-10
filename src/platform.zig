const std = @import("std");
const rl = @import("raylib");

pub const Platform = struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
};

pub fn init(position: rl.Vector2, size: rl.Vector2, color: rl.Color) Platform {
    return .{
        .position = position,
        .size = size,
        .color = color,
    };
}

pub fn draw(platform: *const Platform) void {
    rl.drawRectangle(@intFromFloat(platform.position.x), @intFromFloat(platform.position.y), @intFromFloat(platform.size.x), @intFromFloat(platform.size.y), platform.color);
}

pub fn get_hitbox(platform: *const Platform) rl.Rectangle {
    return .{
        .x = platform.position.x,
        .y = platform.position.y,
        .width = platform.size.x,
        .height = platform.size.y,
    };
}
