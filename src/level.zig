const rl = @import("raylib");
const platform_mod = @import("platform.zig");
const coin_mod = @import("coin.zig");

pub const Level = struct {
    platforms: [100]platform_mod.Platform,
    platform_count: usize,
    coins: [100]coin_mod.Coin,
    coin_count: usize,
};

pub fn init() Level {
    var level: Level = undefined;
    level.platform_count = 2;
    level.coin_count = 2;

    level.platforms[0] = platform_mod.init(rl.Vector2{ .x = 100, .y = 650 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);
    level.platforms[1] = platform_mod.init(rl.Vector2{ .x = 350, .y = 580 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);

    level.coins[0] = coin_mod.init(200, 600);
    level.coins[1] = coin_mod.init(400, 530);

    return level;
}

pub fn draw(level: *Level) void {
    for (0..level.platform_count) |index| {
        platform_mod.draw(&level.platforms[index]);
    }
    for (0..level.coin_count) |index| {
        coin_mod.draw(&level.coins[index]);
    }
}
