const std = @import("std");
const Connection = std.net.Server.Connection;

pub fn send_file(conn: Connection, file_path: []const u8, status: []const u8) !void {
    const allocator = std.heap.page_allocator;
    const file = std.fs.cwd().openFile(file_path, .{}) catch |err| {
        if (err == error.FileNotFound) {
            // If file not found, send home page or 404
            if (!std.mem.eql(u8, file_path, "public/index.html")) {
                // Try to send home page
                try send_file(conn, "public/index.html", "200 OK");
            } else {
                // If even home page is missing, send a minimal fallback
                const fallback = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n";
                _ = try conn.stream.write(fallback);
            }
            return;
        }
        return err;
    };
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
    try send_file(conn, "public/index.html", "200 OK");
}

pub fn send_404(conn: Connection) !void {
    try send_file(conn, "public/404.html", "404 Not Found");
}
