//! UI rendering and debug HUD display.
const std = @import("std");

const rl = @import("raylib");
const rg = @import("raygui");

const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const camera_mod = @import("camera.zig");
const config = @import("config.zig");

const DebugHud = struct {
    const LINE_COUNT: i32 = 11;
    const TEXT_X: f32 = config.UI_DEBUG_PANEL_X + config.UI_DEBUG_PADDING;
    const TEXT_WIDTH: f32 = config.UI_DEBUG_PANEL_WIDTH - config.UI_DEBUG_PADDING * 2;
    const PANEL_HEIGHT: f32 = config.UI_DEBUG_HEADER_HEIGHT + @as(f32, @floatFromInt(LINE_COUNT)) * config.UI_DEBUG_LINE_HEIGHT + config.UI_DEBUG_PADDING;

    line_count: i32 = 0,
    buf: [config.UI_DEBUG_BUFFER_SIZE]u8 = undefined,

    fn writeLine(self: *DebugHud, comptime fmt: []const u8, args: anytype) void {
        const y = config.UI_DEBUG_PANEL_Y + config.UI_DEBUG_HEADER_HEIGHT + @as(f32, @floatFromInt(self.line_count)) * config.UI_DEBUG_LINE_HEIGHT;
        const text = std.fmt.bufPrintZ(&self.buf, fmt, args) catch "err";
        _ = rg.label(.{ .x = TEXT_X, .y = y, .width = TEXT_WIDTH, .height = config.UI_DEBUG_LINE_HEIGHT }, text);
        self.line_count += 1;
    }
};

pub fn drawText(x: i32, y: i32, font_size: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [config.UI_DEBUG_BUFFER_SIZE]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, font_size, color);
}

pub fn drawDebugHud(player: *player_mod.Player, level: *level_mod.Level, camera: *camera_mod.Camera, show_debug: bool) void {
    if (!show_debug) return;

    _ = rg.panel(.{
        .x = config.UI_DEBUG_PANEL_X,
        .y = config.UI_DEBUG_PANEL_Y,
        .width = config.UI_DEBUG_PANEL_WIDTH,
        .height = DebugHud.PANEL_HEIGHT,
    }, "Debug HUD");

    var hud = DebugHud{};
    hud.writeLine("FPS: {d}", .{rl.getFPS()});
    hud.writeLine("Frame Time: {d:.3}ms", .{rl.getFrameTime() * 1000});
    hud.writeLine("Pos: ({d:.1}, {d:.1})", .{ player.position.x, player.position.y });
    hud.writeLine("Grounded: {s}", .{if (player.is_grounded) "yes" else "no"});
    hud.writeLine("Vel: ({d:.1}, {d:.1})", .{ player.velocity.x, player.velocity.y });
    hud.writeLine("Jumps Remaining: {d}", .{player.jumps_remaining});
    hud.writeLine("Dash Cooldown: {d:.1}s", .{player.dash_cooldown});
    hud.writeLine("Coins Collected: {d}", .{player.coins_collected});
    hud.writeLine("Coins: {d}", .{level.coins.len});
    hud.writeLine("Camera Target: ({d:.1}, {d:.1})", .{ camera.camera.target.x, camera.camera.target.y });
    hud.writeLine("Current loaded level: {s}", .{level.name});
}
