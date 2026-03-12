//! Collision resolution between player and level objects.
const rl = @import("raylib");

const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const collider_mod = @import("collider.zig");
const hazard_mod = @import("hazard.zig");
const checkpoint_mod = @import("checkpoint.zig");

const LANDING_TOLERANCE: f32 = 10.0;

pub fn resolvePlayerCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    resolveColliderCollisions(player, level);
    resolveCoinCollisions(player, level);
    resolveCheckpointCollisions(player, level);
    resolveHazardCollisions(player, level);
}

fn resolveColliderCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    const FEET_Y = player.position.y + player.hitbox_height;

    for (level.colliders) |*collider| {
        const collider_hitbox = collider_mod.get_hitbox(collider);
        const collider_top = collider_hitbox.y;
        const near_top = FEET_Y >= collider_top and FEET_Y <= collider_top + LANDING_TOLERANCE;

        // Handle collisions for Solid colliders
        if (collider.collider_type == .Solid and rl.checkCollisionRecs(player_mod.get_hitbox(player), collider_hitbox)) {
            // Calculate overlap on each axis to find smallest penetration
            const overlap_top = (player.position.y + player.hitbox_height) - collider_hitbox.y; // how far into collider from top
            const overlap_bottom = (collider_hitbox.y + collider_hitbox.height) - player.position.y; // how far into collider from bottom
            const overlap_left = (player.position.x + player.hitbox_width) - collider_hitbox.x;
            const overlap_right = (collider_hitbox.x + collider_hitbox.width) - player.position.x;

            // Find smallest overlap to determine collision side
            const min_overlap = @min(@min(overlap_top, overlap_bottom), @min(overlap_left, overlap_right));

            if (min_overlap == overlap_top and player.velocity.y > 0) {
                // Landing on top
                player.is_grounded = true;
                player.position.y = collider_hitbox.y - player.hitbox_height;
                player.velocity.y = 0;
            } else if (min_overlap == overlap_bottom and player.velocity.y < 0) {
                // Hitting head on bottom
                player.position.y = collider_hitbox.y + collider_hitbox.height;
                player.velocity.y = 0;
            } else if (min_overlap == overlap_left and player.velocity.x > 0) {
                // Hitting left wall
                player.position.x = collider_hitbox.x - player.hitbox_width;
                player.velocity.x = 0;
            } else if (min_overlap == overlap_right and player.velocity.x < 0) {
                // Hitting right wall
                player.position.x = collider_hitbox.x + collider_hitbox.width;
                player.velocity.x = 0;
            }
        }

        // Handle collisions for OneWay colliders
        if (collider.collider_type == .OneWay and rl.checkCollisionRecs(player_mod.get_hitbox(player), collider_hitbox) and player.velocity.y >= 0 and near_top) {
            player.is_grounded = true;
            player.position.y = collider_hitbox.y - player.hitbox_height;
            player.velocity.y = 0;
        }

        // Handle collisions for Crumbling colliders (like OneWay + start timer)
        if (collider.collider_type == .Crumbling and collider.is_active and rl.checkCollisionRecs(player_mod.get_hitbox(player), collider_hitbox) and player.velocity.y >= 0 and near_top) {
            player.is_grounded = true;
            player.position.y = collider_hitbox.y - player.hitbox_height;
            player.velocity.y = 0;
            // Start crumble timer if not already started
            if (collider.timer == 0) {
                collider.timer = collider.crumble_delay;
            }
        }
    }

    // This is here for now, but may be moved later on
    if (player.is_grounded) {
        player.jumps_remaining = 2;
    }
}

fn resolveCoinCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    // Coins
    for (level.coins) |*coin| {
        if (!coin.is_collected and rl.checkCollisionCircleRec(coin.position, coin.radius, player_mod.get_hitbox(player))) {
            coin.is_collected = true;
            player.coins_collected += 1;
        }
    }
}

fn resolveHazardCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    // Hazards
    for (level.hazards) |*hazard| {
        if (rl.checkCollisionRecs(hazard_mod.get_hitbox(hazard), player_mod.get_hitbox(player))) {
            player_mod.respawnPlayer(player);
            break;
        }
    }
}

fn resolveCheckpointCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    // Checkpoints
    for (level.checkpoints) |*checkpoint| {
        if (rl.checkCollisionRecs(checkpoint_mod.get_hitbox(checkpoint), player_mod.get_hitbox(player))) {
            // deactivate all checkpoints and then activate this one
            for (level.checkpoints) |*other_checkpoint| {
                other_checkpoint.is_active = false;
            }

            if (!checkpoint.is_active) {
                checkpoint.is_active = true;
                player.spawn_position = checkpoint.position;
            }
        }
    }
}
