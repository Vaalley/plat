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
        const platformHitbox = platform_mod.getHitbox(&platform);
        const platformTop = platformHitbox.y;
        const nearTop = feetY >= platformTop and feetY <= platformTop + LANDING_TOLERANCE;

        if (rl.checkCollisionRecs(player_mod.getHitbox(player), platformHitbox) and player.velocity.y >= 0 and nearTop) {
            player.isGrounded = true;
            player.position.y = platformHitbox.y - player.hitboxHeight;
            player.velocity.y = 0;
        }
    }

    // Coins
    for (0..level.coin_count) |index| {
        const coin = &level.coins[index];
        if (!coin.isCollected and rl.checkCollisionCircleRec(coin.position, coin.radius, player_mod.getHitbox(player))) {
            coin.isCollected = true;
            player.coinsCollected += 1;
        }
    }

    if (player.isGrounded) {
        player.jumpsRemaining = 2;
    }
}

// Future: pub fn resolveEnemyCollisions(enemies: []Enemy, level: *Level) void
