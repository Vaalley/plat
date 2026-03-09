//! 2D camera that follows the player.
const rl = @import("raylib");

const player_mod = @import("player.zig");

pub const Camera = struct {
    camera: rl.Camera2D,
};

pub fn init(screen_width: f32, screen_height: f32) Camera {
    return .{
        .camera = .{
            .target = .{ .x = 0, .y = 0 },
            .offset = .{ .x = screen_width / 2, .y = screen_height / 2 },
            .rotation = 0,
            .zoom = 1,
        },
    };
}

pub fn update(camera: *Camera, player: *player_mod.Player) void {
    camera.camera.offset = .{
        .x = @as(f32, @floatFromInt(rl.getScreenWidth())) / 2,
        .y = @as(f32, @floatFromInt(rl.getScreenHeight())) / 2,
    };

    camera.camera.target = player.position;
}
