//! Static platform definitions and hitbox utilities.
const std = @import("std");

const rl = @import("raylib");

pub const ColliderType = enum {
    Solid, // Blocks from all sides
    OneWay, // Can jump through from below, land on top
    Crumbling, // Breaks after player stands on it for a short time
};

pub const Collider = struct {
    collider_type: ColliderType,

    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,

    crumble_delay: f32,
    respawn: bool,
    respawn_delay: f32,
    timer: f32,
    is_active: bool,
};

pub fn init(position: rl.Vector2, size: rl.Vector2, color: rl.Color, collider_type: ColliderType) Collider {
    return .{
        .collider_type = collider_type,
        .position = position,
        .size = size,
        .color = color,
        .crumble_delay = 0,
        .respawn = false,
        .respawn_delay = 0,
        .timer = 0,
        .is_active = true,
    };
}

pub fn draw(collider: *const Collider) void {
    if (collider.collider_type == .Crumbling and collider.timer > 0) {
        // Calculate crumble progress (1.0 = full, 0.0 = about to break)
        const progress = collider.timer / collider.crumble_delay;
        rl.drawRectangle(@intFromFloat(collider.position.x), @intFromFloat(collider.position.y), @intFromFloat(collider.size.x), @intFromFloat(collider.size.y), rl.colorLerp(collider.color, .red, 1.0 - progress));
        return;
    }
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
