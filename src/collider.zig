//! Static platform definitions and hitbox utilities.
const std = @import("std");

const rl = @import("raylib");

pub const ColliderType = enum {
    OneWay, // Can jump through from below, land on top
    Solid, // Blocks from all sides
};

pub const Collider = struct {
    collider_type: ColliderType,
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
};

pub fn init(position: rl.Vector2, size: rl.Vector2, color: rl.Color, collider_type: ColliderType) Collider {
    return .{
        .collider_type = collider_type,
        .position = position,
        .size = size,
        .color = color,
    };
}

pub fn draw(collider: *const Collider) void {
    rl.drawRectangle(@intFromFloat(collider.position.x), @intFromFloat(collider.position.y), @intFromFloat(collider.size.x), @intFromFloat(collider.size.y), collider.color);
}

pub fn get_hitbox(collider: *const Collider) rl.Rectangle {
    return .{
        .x = collider.position.x,
        .y = collider.position.y,
        .width = collider.size.x,
        .height = collider.size.y,
    };
}
