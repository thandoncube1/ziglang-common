const std = @import("std");
const Connection = std.net.Server.Connection;
const Map = std.static_string_map.StaticStringMap;

pub fn read_request(conn: Connection, buffer: []u8) !void {
    const reader = conn.stream.reader();
    _ = try reader.read(buffer);
}

const MethodMap = Map(Method).initComptime(.{
    .{ "GET", Method.GET },
});

pub const Method = enum {
    GET,
    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text).?;
    }
    pub fn is_supported(m: []const u8) bool {
        const method = MethodMap.get(m);
        if (method) |_| {
            return true;
        }
        return false;
    }
};
