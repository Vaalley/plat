const rl = @import("raylib");
const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const std = @import("std");

pub fn drawText(x: i32, y: i32, fontSize: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [128]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, fontSize, color);
}

pub fn drawDebugHUD(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera) void {
    const fontSize = 20;

    var y: i32 = 10;
    drawText(10, y, fontSize, rl.Color.black, "Debug HUD", .{});
    drawText(10, y + fontSize, fontSize, rl.Color.black, "FPS: {d}", .{rl.getFPS()});

    y += 40;
    const deltaTime: f32 = rl.getFrameTime();
    drawText(10, y, fontSize, rl.Color.black, "Delta time: {d:.5}", .{deltaTime});
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Player Position: ({d:.2}, {d:.2})", .{ player.position.x, player.position.y });
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Player isGrounded: {s}", .{if (player.isGrounded) "YES" else "NO"});
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Player jumpsRemaining: {d}", .{player.jumpsRemaining});
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Player dashCooldown: {d:.2}", .{player.dashCooldown});
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Platform count: {d}", .{level.platforms.len});
    y += fontSize + 5;
    drawText(10, y, fontSize, rl.Color.black, "Camera target position: ({d:.2}, {d:.2})", .{ camera.camera.target.x, camera.camera.target.y });
}
