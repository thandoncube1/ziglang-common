const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const name = "Thando";
    const output = try std.fmt.allocPrint(allocator, "Hello {s}!!!", .{name});

    std.debug.print("{s}\n", .{output});
}
