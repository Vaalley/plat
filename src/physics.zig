const rl = @import("raylib");

const player_mod = @import("player.zig");
const level_mod = @import("level.zig");
const platform_mod = @import("platform.zig");

const LANDING_TOLERANCE: f32 = 10.0;

pub fn resolvePlayerCollisions(player: *player_mod.Player, level: *level_mod.Level) void {
    const feetY = player.position.y + player.hitboxHeight;

    // Platforms
    for (0..level.platform_count) |index| {
        const platform = level.platforms[index];
        const platform_hitbox = platform_mod.get_hitbox(&platform);
        const platform_top = platform_hitbox.y;
        const near_top = feetY >= platform_top and feetY <= platform_top + LANDING_TOLERANCE;

        if (rl.checkCollisionRecs(player_mod.get_hitbox(player), platform_hitbox) and player.velocity.y >= 0 and near_top) {
            player.is_grounded = true;
            player.position.y = platform_hitbox.y - player.hitbox_height;
            player.velocity.y = 0;
        }
    }

    // Coins
    for (0..level.coin_count) |index| {
        const coin = &level.coins[index];
        if (!coin.is_collected and rl.checkCollisionCircleRec(coin.position, coin.radius, player_mod.get_hitbox(player))) {
            coin.is_collected = true;
            player.coins_collected += 1;
        }
    }

    if (player.is_grounded) {
        player.jumps_remaining = 2;
    }
}

// Future: pub fn resolveEnemyCollisions(enemies: []Enemy, level: *Level) void
