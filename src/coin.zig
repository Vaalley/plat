const rl = @import("raylib");

pub const Coin = struct {
    position: rl.Vector2,
    radius: f32,
    is_collected: bool,
};

pub fn init(x: f32, y: f32) Coin {
    return .{
        .position = .{ .x = x, .y = y },
        .radius = 10,
        .is_collected = false,
    };
}

pub fn draw(coin: *const Coin) void {
    if (!coin.is_collected) {
        rl.drawCircleV(coin.position, coin.radius, rl.Color.gold);
    }
}
