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

const LevelData = struct {
    name: []const u8,
    player_spawn_point: PlayerSpawnPoint,
    platforms: []PlatformData,
    coins: []CoinData,
};
