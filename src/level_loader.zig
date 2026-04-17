//! JSON level loading and data parsing.
const std = @import("std");

const rl = @import("raylib");

const level_mod = @import("level.zig");
const collider_mod = @import("collider.zig");
const coin_mod = @import("coin.zig");
const player_mod = @import("player.zig");
const hazard_mod = @import("hazard.zig");
const checkpoint_mod = @import("checkpoint.zig");
const goal_mod = @import("goal.zig");
const config = @import("config.zig");

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
    crumble_delay: f32 = 0,
    respawn: bool = false,
    respawn_delay: f32 = 0,
};

const CoinData = struct {
    position_x: f32,
    position_y: f32,
};

const HazardData = struct {
    position_x: f32,
    position_y: f32,
    size: rl.Vector2,
    color: ColorData,
};

const CheckpointData = struct {
    position_x: f32,
    position_y: f32,
    size: rl.Vector2,
};

const GoalData = struct {
    position_x: f32,
    position_y: f32,
    size: rl.Vector2,
    next_level: ?[]const u8 = null,
};

pub const LevelData = struct {
    name: []const u8,
    player_spawn_point: PlayerSpawnPoint,
    colliders: []ColliderData = &.{},
    coins: []CoinData = &.{},
    hazards: []HazardData = &.{},
    checkpoints: []CheckpointData = &.{},
    goal: ?GoalData = null,
};

/// Loads level data from a JSON file using std.json
pub fn loadLevelDataFromFile(io: std.Io, allocator: std.mem.Allocator, file_path: []const u8) !LevelData {
    const content = try std.Io.Dir.cwd().readFileAlloc(io, file_path, allocator, .unlimited);

    const level_data = try std.json.parseFromSliceLeaky(LevelData, allocator, content, .{});
    return level_data;
}

/// Takes an object (typically from loadLevelDataFromFile) and converts it to a Level
pub fn buildLevel(level_data: LevelData, allocator: std.mem.Allocator) !level_mod.Level {
    var level: level_mod.Level = undefined;
    level.name = level_data.name;

    // Copy colliders
    level.colliders = try allocator.alloc(collider_mod.Collider, level_data.colliders.len);
    errdefer allocator.free(level.colliders);
    for (0..level.colliders.len) |i| {
        const collider_data = level_data.colliders[i];
        const color = rl.Color{ .r = collider_data.color.r, .g = collider_data.color.g, .b = collider_data.color.b, .a = config.COLOR_ALPHA_MAX };

        level.colliders[i] = collider_mod.init(.{ .x = collider_data.position_x, .y = collider_data.position_y }, .{ .x = collider_data.width, .y = collider_data.height }, color, collider_data.collider_type);

        // Set crumbling collider specific properties
        level.colliders[i].crumble_delay = collider_data.crumble_delay;
        level.colliders[i].respawn = collider_data.respawn;
        level.colliders[i].respawn_delay = collider_data.respawn_delay;
    }

    // Copy coins
    level.coins = try allocator.alloc(coin_mod.Coin, level_data.coins.len);
    errdefer allocator.free(level.coins);
    for (0..level.coins.len) |i| {
        const coin_data = level_data.coins[i];

        level.coins[i] = coin_mod.init(coin_data.position_x, coin_data.position_y);
    }

    // Copy hazards
    level.hazards = try allocator.alloc(hazard_mod.Hazard, level_data.hazards.len);
    errdefer allocator.free(level.hazards);
    for (0..level.hazards.len) |i| {
        const hazard_data = level_data.hazards[i];
        const color = rl.Color{ .r = hazard_data.color.r, .g = hazard_data.color.g, .b = hazard_data.color.b, .a = config.COLOR_ALPHA_MAX };

        level.hazards[i] = hazard_mod.init(hazard_data.position_x, hazard_data.position_y, hazard_data.size, color);
    }

    // Copy checkpoints
    level.checkpoints = try allocator.alloc(checkpoint_mod.Checkpoint, level_data.checkpoints.len);
    errdefer allocator.free(level.checkpoints);
    for (0..level.checkpoints.len) |i| {
        const checkpoint_data = level_data.checkpoints[i];

        level.checkpoints[i] = checkpoint_mod.init(.{ .x = checkpoint_data.position_x, .y = checkpoint_data.position_y }, checkpoint_data.size);
    }

    // Copy goal
    if (level_data.goal) |goal_data| {
        const next_level: ?[]const u8 = if (goal_data.next_level) |s| try allocator.dupe(u8, s) else null;
        level.goal = goal_mod.init(.{ .x = goal_data.position_x, .y = goal_data.position_y }, goal_data.size, next_level);
    }

    return level;
}

pub fn loadLevelFromPath(io: std.Io, arena: *std.heap.ArenaAllocator, level: *level_mod.Level, player: *player_mod.Player, path: []const u8) !void {
    _ = arena.reset(.retain_capacity); // Free all, keep memory
    const level_data = try loadLevelDataFromFile(io, arena.allocator(), path);
    level.* = try buildLevel(level_data, arena.allocator());
    player.spawn_position = .{ .x = level_data.player_spawn_point.position_x, .y = level_data.player_spawn_point.position_y };
    player.coins_collected = 0;
    player_mod.respawnPlayer(player);
}
