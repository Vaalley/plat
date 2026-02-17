//! JSON level loading and data parsing.
const std = @import("std");

const rl = @import("raylib");

const level_mod = @import("level.zig");
const platform_mod = @import("platform.zig");
const coin_mod = @import("coin.zig");

const ColorData = struct {
    r: u8,
    g: u8,
    b: u8,
};

const PlayerSpawnPoint = struct {
    position_x: f32,
    position_y: f32,
};

const PlatformData = struct {
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
    platforms: []PlatformData,
    coins: []CoinData,
};

/// Loads level data from a JSON file using std.json
pub fn load_level_data_from_file(allocator: std.mem.Allocator, file_path: []const u8) !LevelData {
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    // TODO: readToEndAlloc is deprecated, use reader in the future instead (I am too stupid to figure it out now, and this works)
    // Additionally, 1024 * 1024 is a magic number (maybe fix this in the future?)
    const content = try file.readToEndAlloc(allocator, 1024 * 1024);

    const parsed = try std.json.parseFromSlice(LevelData, allocator, content, .{});
    defer parsed.deinit();

    return parsed.value;
}

pub fn load_level(level_data: LevelData) level_mod.Level {
    var level: level_mod.Level = undefined;

    // Copy platforms (limit to 100)
    level.platform_count = @min(level_data.platforms.len, 100);
    for (0..level.platform_count) |i| {
        const platform_data = level_data.platforms[i];
        const color = rl.Color{ .r = platform_data.color.r, .g = platform_data.color.g, .b = platform_data.color.b, .a = 255 };
        level.platforms[i] = platform_mod.init(.{ .x = platform_data.position_x, .y = platform_data.position_y }, .{ .x = platform_data.width, .y = platform_data.height }, color);
    }

    // Copy coins (limit to 100)
    level.coin_count = @min(level_data.coins.len, 100);
    for (0..level.coin_count) |i| {
        const coin_data = level_data.coins[i];
        level.coins[i] = coin_mod.init(coin_data.position_x, coin_data.position_y);
    }

    return level;
}
