const rl = @import("raylib");
const rg = @import("raygui");

const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const std = @import("std");

const DEBUG_PANEL_X: f32 = 10;
const DEBUG_PANEL_Y: f32 = 10;
const DEBUG_PANEL_W: f32 = 280;
const LINE_COUNT = 11;
const LINE_HEIGHT: f32 = 20;
const DEBUG_PANEL_H: f32 = 30 + (LINE_COUNT * LINE_HEIGHT) + 10; // header + lines + padding
const PADDING: f32 = 10;

pub fn draw_text(x: i32, y: i32, font_size: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [128]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, font_size, color);
}

pub fn draw_debug_hud(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera) void {
    _ = rg.panel(rl.Rectangle{
        .x = DEBUG_PANEL_X,
        .y = DEBUG_PANEL_Y,
        .width = DEBUG_PANEL_W,
        .height = DEBUG_PANEL_H,
    }, "Debug HUD");

    var buf: [128]u8 = undefined;

    var line_y: f32 = DEBUG_PANEL_Y + 30;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "FPS: {d}", .{rl.getFPS()}) catch "FPS: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Frame Time: {d:.3}ms", .{rl.getFrameTime() * 1000}) catch "Frame Time: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Pos: ({d:.1}, {d:.1})", .{ player.position.x, player.position.y }) catch "Pos: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Grounded: {s}", .{if (player.is_grounded) "yes" else "no"}) catch "Grounded: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Vel: ({d:.1}, {d:.1})", .{ player.velocity.x, player.velocity.y }) catch "Vel: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Jumps Remaining: {d}", .{player.jumps_remaining}) catch "Jumps Remaining: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Dash Cooldown: {d:.1}s", .{player.dash_cooldown}) catch "Dash Cooldown: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Coins Collected: {d}", .{player.coins_collected}) catch "Coins: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Platforms: {d}", .{level.platform_count}) catch "Platforms: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Coins: {d}", .{level.coin_count}) catch "Coins: err");
    line_y += LINE_HEIGHT;

    draw_debug_line(DEBUG_PANEL_X + PADDING, line_y, std.fmt.bufPrintZ(&buf, "Camera Target: ({d:.1}, {d:.1})", .{ camera.camera.target.x, camera.camera.target.y }) catch "Camera Target: err");
}

fn draw_debug_line(x: f32, y: f32, text: [:0]const u8) void {
    const rect = rl.Rectangle{
        .x = x,
        .y = y,
        .width = DEBUG_PANEL_W - PADDING * 2,
        .height = LINE_HEIGHT,
    };

    _ = rg.label(rect, text);
}
