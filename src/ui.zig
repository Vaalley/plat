const rl = @import("raylib");
const std = @import("std");

pub fn drawText(x: i32, y: i32, fontSize: i32, color: rl.Color, comptime fmt: []const u8, args: anytype) void {
    var buf: [128]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, fmt, args) catch "error";
    rl.drawText(text, x, y, fontSize, color);
}
