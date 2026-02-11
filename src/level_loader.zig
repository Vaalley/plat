const std = @import("std");

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

    const content = try file.readToEndAlloc(allocator, 1024 * 1024);

    const parsed = try std.json.parseFromSlice(LevelData, allocator, content, .{});
    defer parsed.deinit();

    return parsed.value;
}
