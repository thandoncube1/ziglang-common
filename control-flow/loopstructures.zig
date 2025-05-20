const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var i: usize = 0;

    while (true) : (i += 1) {
        if (i == 10) {
            break;
        }
    }

    try std.testing.expect(i == 10);
    try stdout.print("Everything worked!\n", .{});

    const ns = [_]u8{ 1, 2, 3, 4, 5, 6 };
    for (ns) |item| {
        if (item % 2 == 0) {
            continue;
        }

        try stdout.print("{d} | ", .{item});
    }
    try stdout.print("\n", .{});
}
