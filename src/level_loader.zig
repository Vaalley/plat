//! JSON level loading and data parsing.
const std = @import("std");

const rl = @import("raylib");

const level_mod = @import("level.zig");
const collider_mod = @import("collider.zig");
const coin_mod = @import("coin.zig");
const player_mod = @import("player.zig");

const ColorData = struct {
    r: u8,
    g: u8,
    b: u8,
};

const PlayerSpawnPoint = struct {
    position_x: f32,
    position_y: f32,
};

const ColliderData = struct {
    collider_type: collider_mod.ColliderType,
    position_x: f32,
    position_y: f32,
    width: f32,
    height: f32,
    color: ColorData,
};

const CoinData = struct {
    position_x: f32,
    position_y: f32,
};

pub const LevelData = struct {
    name: []const u8,
    player_spawn_point: PlayerSpawnPoint,
    colliders: []ColliderData,
    coins: []CoinData,
};

/// Loads level data from a JSON file using std.json
pub fn load_level_data_from_file(allocator: std.mem.Allocator, file_path: []const u8) !LevelData {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    // TODO: readToEndAlloc is deprecated, use reader in the future instead (I am too stupid to figure it out now, and this works)
    // Additionally, 1024 * 1024 is a magic number (maybe fix this in the future?)
    const content = try file.readToEndAlloc(allocator, 1024 * 1024);

    const level_data = try std.json.parseFromSliceLeaky(LevelData, allocator, content, .{});
    return level_data;
}

/// Takes an object (typically from load_level_data_from_file) and converts it to a Level
pub fn load_level(level_data: LevelData, allocator: std.mem.Allocator) !level_mod.Level {
    var level: level_mod.Level = undefined;

    // Copy colliders
    level.colliders = try allocator.alloc(collider_mod.Collider, level_data.colliders.len);
    for (0..level.colliders.len) |i| {
        const collider_data = level_data.colliders[i];
        const color = rl.Color{ .r = collider_data.color.r, .g = collider_data.color.g, .b = collider_data.color.b, .a = 255 };
        level.colliders[i] = collider_mod.init(.{ .x = collider_data.position_x, .y = collider_data.position_y }, .{ .x = collider_data.width, .y = collider_data.height }, color, collider_data.collider_type);
    }

    errdefer allocator.free(level.colliders);

    // Copy coins
    level.coins = try allocator.alloc(coin_mod.Coin, level_data.coins.len);
    for (0..level.coins.len) |i| {
        const coin_data = level_data.coins[i];
        level.coins[i] = coin_mod.init(coin_data.position_x, coin_data.position_y);
    }

    return level;
}

pub fn reloadLevel(arena: *std.heap.ArenaAllocator, level: *level_mod.Level, player: *player_mod.Player) !void {
    _ = arena.reset(.retain_capacity); // Free all, keep memory
    const level_data = try load_level_data_from_file(arena.allocator(), "assets/levels/level_1.json");
    level.* = try load_level(level_data, arena.allocator());
    player.spawn_position = .{ .x = level_data.player_spawn_point.position_x, .y = level_data.player_spawn_point.position_y };
    player_mod.reset(player);
}
