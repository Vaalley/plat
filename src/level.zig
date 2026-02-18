//! Container for all level objects (colliders and coins).
const rl = @import("raylib");

const collider_mod = @import("collider.zig");
const coin_mod = @import("coin.zig");

pub const Level = struct {
    // Maximum capacity for colliders and coins is 100 because I decided so (arbitrary limit for simplicity)
    colliders: [100]collider_mod.Collider,
    collider_count: usize,
    coins: [100]coin_mod.Coin,
    coin_count: usize,
};

pub fn init() Level {
    var level: Level = undefined;
    level.collider_count = 4;
    level.coin_count = 5;

    level.colliders[0] = collider_mod.init(rl.Vector2{ .x = 100, .y = 650 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);
    level.colliders[1] = collider_mod.init(rl.Vector2{ .x = 350, .y = 580 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);
    level.colliders[2] = collider_mod.init(rl.Vector2{ .x = 600, .y = 510 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);
    level.platforms[3] = collider_mod.init(rl.Vector2{ .x = 850, .y = 550 }, rl.Vector2{ .x = 200, .y = 32 }, rl.Color.green);

    level.coins[0] = coin_mod.init(200, 600);
    level.coins[1] = coin_mod.init(400, 530);
    level.coins[2] = coin_mod.init(650, 460);
    level.coins[3] = coin_mod.init(900, 440);
    level.coins[4] = coin_mod.init(1000, 440);

    return level;
}

pub fn draw(level: *Level) void {
    for (0..level.collider_count) |index| {
        collider_mod.draw(&level.colliders[index]);
    }
    for (0..level.coin_count) |index| {
        coin_mod.draw(&level.coins[index]);
    }
}
