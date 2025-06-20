const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var number: ?i32 = 21;
    number = null; // Error null cannot be assigned as type - @TypeOf(null)
    // but adding the ? before the type clears the error.
    number = 5;
    const pointer: *?i32 = &number;
    if (pointer.*) |not_null| {
        try stdout.print("{d}\n", .{not_null});
    }

    // Unwrapping with the orelse
    const x: ?i32 = null;
    const dbl = (x orelse 15) * 2;
    try stdout.print("{d}\n", .{dbl});
}
