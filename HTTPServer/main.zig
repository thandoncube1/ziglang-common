const std = @import("std");
const SocketConf = @import("socketConnection.zig");
const Request = @import("request.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("Server Addr: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});
    const connection = try server.accept();
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0; // Initialize all values to 0 in memory.
    }
    _ = try Request.read_request(connection, buffer[0..buffer.len]);
    try stdout.print("{s}\n", .{buffer});
}
