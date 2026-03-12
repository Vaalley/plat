//! Container for all level objects (colliders and coins).
const collider_mod = @import("collider.zig");
const coin_mod = @import("coin.zig");
const hazard_mod = @import("hazard.zig");
const checkpoint_mod = @import("checkpoint.zig");

pub const Level = struct {
    colliders: []collider_mod.Collider,
    coins: []coin_mod.Coin,
    hazards: []hazard_mod.Hazard,
    checkpoints: []checkpoint_mod.Checkpoint,
};

pub fn draw(level: *Level) void {
    for (level.colliders) |*collider| {
        if (collider.collider_type == .Crumbling and !collider.is_active) continue;
        collider_mod.draw(collider);
    }
    for (level.checkpoints) |*checkpoint| {
        checkpoint_mod.draw(checkpoint);
    }
    for (level.coins) |*coin| {
        coin_mod.draw(coin);
    }
    for (level.hazards) |*hazard| {
        hazard_mod.draw(hazard);
    }
}

pub fn update(level: *Level, deltaTime: f32) void {
    for (level.colliders) |*collider| {
        if (collider.collider_type != .Crumbling) continue;

        if (collider.is_active) {
            // Active: count down crumble timer (started when player landed)
            if (collider.timer > 0) {
                collider.timer -= deltaTime;
                if (collider.timer <= 0) {
                    // Crumble!
                    collider.is_active = false;
                    if (collider.respawn) {
                        collider.timer = collider.respawn_delay; // Reuse timer for respawn
                    }
                }
            }
        } else if (collider.respawn) {
            // Inactive but respawns: count down respawn timer
            collider.timer -= deltaTime;
            if (collider.timer <= 0) {
                collider.is_active = true;
                collider.timer = 0;
            }
        }
    }
}
