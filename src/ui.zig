//! UI rendering and debug HUD display.
const std = @import("std");

const rl = @import("raylib");
const rg = @import("raygui");

const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const config = @import("config.zig");

pub fn drawText(x: i32, y: i32, font_size: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [config.UI_DEBUG_BUFFER_SIZE]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, font_size, color);
}

pub fn drawDebugHud(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera, show_debug: bool) void {
    if (!show_debug) return;

    const debug_panel_h = config.UI_DEBUG_HEADER_HEIGHT + (config.UI_DEBUG_LINE_COUNT * config.UI_DEBUG_LINE_HEIGHT) + config.UI_DEBUG_PADDING;

    _ = rg.panel(rl.Rectangle{
        .x = config.UI_DEBUG_PANEL_X,
        .y = config.UI_DEBUG_PANEL_Y,
        .width = config.UI_DEBUG_PANEL_WIDTH,
        .height = debug_panel_h,
    }, "Debug HUD");

    var buf: [config.UI_DEBUG_BUFFER_SIZE]u8 = undefined;

    var line_y: f32 = config.UI_DEBUG_PANEL_Y + config.UI_DEBUG_HEADER_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "FPS: {d}", .{rl.getFPS()}) catch "FPS: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Frame Time: {d:.3}ms", .{rl.getFrameTime() * 1000}) catch "Frame Time: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Pos: ({d:.1}, {d:.1})", .{ player.position.x, player.position.y }) catch "Pos: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Grounded: {s}", .{if (player.is_grounded) "yes" else "no"}) catch "Grounded: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Vel: ({d:.1}, {d:.1})", .{ player.velocity.x, player.velocity.y }) catch "Vel: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Jumps Remaining: {d}", .{player.jumps_remaining}) catch "Jumps Remaining: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Dash Cooldown: {d:.1}s", .{player.dash_cooldown}) catch "Dash Cooldown: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Coins Collected: {d}", .{player.coins_collected}) catch "Coins: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Coins: {d}", .{level.coins.len}) catch "Coins: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Camera Target: ({d:.1}, {d:.1})", .{ camera.camera.target.x, camera.camera.target.y }) catch "Camera Target: err");
    line_y += config.UI_DEBUG_LINE_HEIGHT;

    drawDebugLine(config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING, line_y, std.fmt.bufPrintZ(&buf, "Current loaded level: {s}", .{level.name}) catch "Current loaded level: err");
}

fn drawDebugLine(x: f32, y: f32, text: [:0]const u8) void {
    const rect = rl.Rectangle{
        .x = x,
        .y = y,
        .width = config.UI_DEBUG_PANEL_WIDTH - config.UI_DEBUG_PADDING * 2,
        .height = config.UI_DEBUG_LINE_HEIGHT,
    };

    _ = rg.label(rect, text);
}
