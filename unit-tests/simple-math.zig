const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

test "testing simple sum" {
    const a: u8 = 2;
    const b: u8 = 4;
    try expect((a + b) == 6);
}

fn some_memory_leak(allocator: Allocator) !void {
    const buffer = try allocator.alloc(u32, 10);
    _ = buffer;
    // Return without freeing the
    // allocated memory
}

test "memory leak" {
    const allocator = std.testing.allocator;
    try some_memory_leak(allocator);
}
