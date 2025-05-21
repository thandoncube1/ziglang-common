const std = @import("std");

fn add2(x: u32) u32 {
    // Mutation doesn't work on constants in Zig, parameters
    // are constants e.g. x = x + 2; immutable constant error

    return x + 2;
}

pub fn main() !void {
    const y = add2(4);
    std.debug.print("{d}\n", .{y});
}
