const rl = @import("raylib");
const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const std = @import("std");

pub fn draw_text(x: i32, y: i32, font_size: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [128]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, font_size, color);
}

pub fn draw_debug_hud(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera) void {
    const font_size = 20;

    var y: i32 = 10;
    draw_text(10, y, font_size, rl.Color.black, "Debug HUD", .{});
    draw_text(10, y + font_size, font_size, rl.Color.black, "FPS: {d}", .{rl.getFPS()});

    y += 40;
    const delta_time: f32 = rl.getFrameTime();
    draw_text(10, y, font_size, rl.Color.black, "Delta time: {d:.5}", .{delta_time});
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Player Position: ({d:.2}, {d:.2})", .{ player.position.x, player.position.y });
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Player is_grounded: {s}", .{if (player.is_grounded) "YES" else "NO"});
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Player jumps_remaining: {d}", .{player.jumps_remaining});
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Player dash_cooldown: {d:.2}", .{player.dash_cooldown});
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Platform count: {d}", .{level.platforms.len});
    y += font_size + 5;
    draw_text(10, y, font_size, rl.Color.black, "Camera target position: ({d:.2}, {d:.2})", .{ camera.camera.target.x, camera.camera.target.y });
}
