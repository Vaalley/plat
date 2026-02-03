const rl = @import("raylib");
const platform_mod = @import("platform.zig");

pub const Level = struct {
    platforms: [2]platform_mod.Platform,
};

pub fn init() Level {
    return Level{
        .platforms = [_]platform_mod.Platform{
            platform_mod.init(rl.Vector2{ .x = 100, .y = 650 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green),
            platform_mod.init(rl.Vector2{ .x = 350, .y = 580 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green),
        },
    };
}

pub fn draw(level: *Level) void {
    for (level.platforms) |platform| {
        platform_mod.draw(&platform);
    }
}

pub fn getPlatforms(level: *const Level) []const platform_mod.Platform {
    return &level.platforms;
}
