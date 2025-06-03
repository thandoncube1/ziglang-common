const std = @import("std");
const heap = std.heap.page_allocator;

pub fn main() !void {
    // 100 MB memory
    const memory_buffer = try heap.alloc(u8, 100 * 1024 * 1024);

    defer heap.free(memory_buffer);
    var fba = std.heap.FixedBufferAllocator.init(memory_buffer);

    const allocator = fba.allocator();

    const input = try allocator.alloc(u8, 1000);
    defer allocator.free(input);

    std.debug.print("{d}\n", .{input});
}
