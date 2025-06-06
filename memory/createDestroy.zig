const std = @import("std");
const expect = std.testing.expect;

const User = struct {
    id: usize,
    name: []const u8,

    pub fn init(id: usize, name: []const u8) User {
        return .{ .id = id, .name = name };
    }
};

test "General purpose allocator" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer {
        const deinit_status = gpa.deinit();
        // fail test: can't try in defer is executed after we return
        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    const bytes = try allocator.alloc(u8, 100);
    defer allocator.free(bytes);
}

test "allocation" {
    var allocator = std.heap.page_allocator;

    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const user = try allocator.create(User);
    defer allocator.destroy(user);

    user.* = User.init(0, "Thando");

    std.debug.print("{}\n", .{user.*});
}
