const rl = @import("raylib");
const platform_mod = @import("platform.zig");
const coin_mod = @import("coin.zig");

pub const Level = struct {
    platforms: [2]platform_mod.Platform,
    coins: [2]coin_mod.Coin,
};

pub fn init() Level {
    return Level{
        .platforms = [_]platform_mod.Platform{
            platform_mod.init(rl.Vector2{ .x = 100, .y = 650 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green),
            platform_mod.init(rl.Vector2{ .x = 350, .y = 580 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green),
        },
        .coins = [_]coin_mod.Coin{
            coin_mod.init(200, 600),
            coin_mod.init(400, 530),
        },
    };
}

pub fn draw(level: *Level) void {
    for (level.platforms) |platform| {
        platform_mod.draw(&platform);
    }
    for (level.coins) |coin| {
        coin_mod.draw(&coin);
    }
}
