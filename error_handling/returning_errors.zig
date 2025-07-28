const std = @import("std");

fn print_name(name: []const u8) !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("My name is {s}\n", .{name});
}

pub fn main() !void {
    try print_name("Thando");
}
