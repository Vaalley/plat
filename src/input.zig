const std = @import("std");
const rl = @import("raylib");

pub const InputState = struct {
    // Movement
    move_left: bool,
    move_right: bool,
    move_up: bool,
    move_down: bool,

    // Actions
    jump: bool,
    // attack: bool,
    // dash: bool,

    // Raw key states for more complex input handling
    // keys_down: [512]bool,
    // keys_pressed: [512]bool,
    // keys_released: [512]bool,
};

pub fn init() InputState {
    return .{
        .move_left = false,
        .move_right = false,
        .move_up = false,
        .move_down = false,
        .jump = false,
        // .attack = false,
        // .dash = false,
        // .keys_down = std.mem.zeroes([512]bool),
        // .keys_pressed = std.mem.zeroes([512]bool),
        // .keys_released = std.mem.zeroes([512]bool),
    };
}

pub fn update(input: *InputState) void {
    // Reset one-frame states
    // input.keys_pressed = std.mem.zeroes([512]bool);
    // input.keys_released = std.mem.zeroes([512]bool);

    // Update basic movement states
    input.move_left = rl.isKeyDown(.a);
    input.move_right = rl.isKeyDown(.d);
    input.move_up = rl.isKeyDown(.w);
    input.move_down = rl.isKeyDown(.s);

    // Update action states
    input.jump = rl.isKeyDown(.space);
    // input.attack = rl.isKeyDown(.j);
    // input.dash = rl.isKeyDown(.k);

    // Update raw key states
    // for (0..512) |i| {
    //     const key = @enumFromInt(@intCast(i));
    //     input.keys_down[i] = rl.isKeyDown(key);

    //     if (rl.isKeyPressed(key)) {
    //         input.keys_pressed[i] = true;
    //     }
    //     if (rl.isKeyReleased(key)) {
    //         input.keys_released[i] = true;
    //     }
    // }
}
