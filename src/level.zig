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

pub fn draw(level: *Level) void {
    for (0..level.collider_count) |index| {
        collider_mod.draw(&level.colliders[index]);
    }
    for (0..level.coin_count) |index| {
        coin_mod.draw(&level.coins[index]);
    }
}
