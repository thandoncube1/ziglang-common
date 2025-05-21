const std = @import("std");

fn add2(x: u32) u32 {
    // Mutation doesn't work on constants in Zig, parameters
    // are constants e.g. x = x + 2; immutable constant error

    return x + 2;
}

fn add3(x: *u32) void {
    const d: u32 = 3;
    x.* = x.* + d;
}

pub fn main() !void {
    const y = add2(4);
    // This is the next piece
    var x: u32 = 4;
    add3(&x);
    std.debug.print("Result: {d}\n", .{x});
    std.debug.print("{d}\n", .{y});
}
