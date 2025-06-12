const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;

test "createFile, write, seekTo, read" {
    const file = try std.fs.cwd().createFile("junk_file.txt", .{ .read = true });
    defer file.close();

    try file.writeAll("Hello File!");

    var buffer: [100]u8 = undefined;
    try file.seekTo(0);
    const bytes_read = try file.readAll(&buffer);

    try expect(eql(u8, buffer[0..bytes_read], "Hello File!"));
}

pub fn main() !void {
    try std.io.getStdOut().writer().print("Welcome to the Print! [quit] `to exit program`\n", .{});

    const stdin = std.io.getStdIn().reader();

    while (true) {
        try std.io.getStdOut().writer().print("\n> ", .{});
        var buffer: [1024]u8 = undefined;

        const result = try stdin.readUntilDelimiter(&buffer, '\n');

        if (eql(u8, result, "quit")) {
            return;
        }

        try std.io.getStdOut().writer().print("{s}", .{result});
    }
}
