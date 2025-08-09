const std = @import("std");
const SocketConf = @import("socketConnection.zig");
const Request = @import("request.zig");
const Response = @import("response.zig");
const Method = Request.Method;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const socket = try SocketConf.Socket.init();
    try stdout.print("Server Addr: {any}\n", .{socket._address});
    var server = try socket._address.listen(.{});

    while (true) {
        const connection = try server.accept();
        // Spawn a thread for each connection
        _ = try std.Thread.spawn(.{}, handle_connection, .{connection});
    }
}

fn handle_connection(connection: std.net.Server.Connection) !void {
    var buffer: [1000]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0;
    }
    try Request.read_request(connection, buffer[0..buffer.len]);
    const request = try Request.parse_request(buffer[0..buffer.len]);

    if (request.method == Method.GET) {
        if (std.mem.eql(u8, request.uri, "/")) {
            try Response.send_200(connection);
        } else {
            try Response.send_404(connection);
        }
    }
    // Add POST/PUT/DELETE handling here as needed
}
