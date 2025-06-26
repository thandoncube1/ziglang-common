const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    // Setup an enum for primaryColor
    const PrimaryColorRGB = enum { RED, GREEN, BLUE };

    const acolor = PrimaryColorRGB.RED;
    try stdout.print("{}\n", .{acolor});
}
