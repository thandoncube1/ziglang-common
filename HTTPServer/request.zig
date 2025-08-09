const std = @import("std");
const Connection = std.net.Server.Connection;
const Map = std.static_string_map.StaticStringMap;

pub fn read_request(conn: Connection, buffer: []u8) !void {
    const reader = conn.stream.reader();
    _ = try reader.read(buffer);
}

const MethodMap = Map(Method).initComptime(.{ .{ "GET", Method.GET }, .{ "POST", Method.POST }, .{ "PUT", Method.PUT }, .{ "DELETE", Method.DELETE } });

pub const Method = enum {
    GET,
    POST,
    PUT,
    DELETE,
    pub fn init(text: []const u8) !Method {
        return MethodMap.get(text) orelse error.UnsupportedMethod;
    }
    pub fn is_supported(m: []const u8) bool {
        return MethodMap.has(m);
    }
};

const Headers = std.HashMap([]const u8, []const u8, std.hash_map.StringContext, std.hash_map.default_max_load_percentage);

const Request = struct {
    method: Method,
    version: []const u8,
    uri: []const u8,
    headers: Headers,
    body: ?[]const u8,

    pub fn init(method: Method, uri: []const u8, version: []const u8) Request {
        return Request{
            .method = method,
            .uri = uri,
            .version = version,
            .headers = Headers.init(std.heap.page_allocator),
            .body = null,
        };
    }
};

pub fn parse_request(text: []u8) !Request {
    const line_index = std.mem.indexOfScalar(u8, text, '\n') orelse text.len;
    var iterator = std.mem.splitScalar(u8, text[0..line_index], ' ');

    const method = try Method.init(iterator.next().?);
    const uri = iterator.next().?;
    const version = iterator.next().?;
    const request = Request.init(method, uri, version);
    return request;
}
