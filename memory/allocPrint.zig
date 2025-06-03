const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const name = "Thando";
    const output = try std.fmt.allocPrint(allocator, "Hello {s}!!!", .{name});

    std.debug.print("{s}\n", .{output});

    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = @as(u32, 45);

    std.debug.print("{d}\n", .{some_number.*});
    // To the get the memory address, you just call the variable
    std.debug.print("{d}\n", .{some_number});
}
