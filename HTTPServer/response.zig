const std = @import("std");
const Connection = std.net.Server.Connection;

pub fn send_file(conn: Connection, file_path: []const u8, status: []const u8) !void {
    const allocator = std.heap.page_allocator;
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const file_size = try file.getEndPos();
    const buffer = try allocator.alloc(u8, file_size);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    const message = try std.fmt.allocPrint(allocator, "HTTP/1.1 {s}\r\nContent-Length: {d}\r\nContent-Type: text/html\r\nConnection: close\r\n\r\n{s}", .{ status, buffer.len, buffer });
    defer allocator.free(message);

    _ = try conn.stream.write(message);
}

pub fn send_200(conn: Connection) !void {
    try send_file(conn, "index.html", "200 OK");
}

pub fn send_404(conn: Connection) !void {
    try send_file(conn, "404.html", "404 Not Found");
}
