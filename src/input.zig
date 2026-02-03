const std = @import("std");
const rl = @import("raylib");

pub const InputState = struct {
    // Movement
    move_left: bool,
    move_right: bool,

    // Actions
    jump: bool,
    dash: bool,
};

pub fn init() InputState {
    return .{
        .move_left = false,
        .move_right = false,
        .jump = false,
        .dash = false,
    };
}

pub fn update(input: *InputState) void {
    // Update basic movement states
    input.move_left = rl.isKeyDown(.a) or rl.isKeyDown(.left);
    input.move_right = rl.isKeyDown(.d) or rl.isKeyDown(.right);

    // Update action states
    input.jump = rl.isKeyDown(.space);
    input.dash = rl.isKeyDown(.left_shift);
}
