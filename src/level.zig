//! Container for all level objects (colliders and coins).
const collider_mod = @import("collider.zig");
const coin_mod = @import("coin.zig");

pub const Level = struct {
    colliders: []collider_mod.Collider,
    coins: []coin_mod.Coin,
};

pub fn draw(level: *Level) void {
    for (level.colliders) |*collider| {
        collider_mod.draw(collider);
    }
    for (level.coins) |*coin| {
        coin_mod.draw(coin);
    }
}
