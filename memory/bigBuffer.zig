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

    // Arenas - Allocating memory more than once
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var aa = std.heap.ArenaAllocator.init(gpa.allocator());
    defer aa.deinit();
    const arenaAllocator = aa.allocator();

    const in1 = try arenaAllocator.alloc(u8, 5);
    const in2 = try arenaAllocator.alloc(u8, 10);
    const in3 = try arenaAllocator.alloc(u8, 15);

    std.debug.print("{d}\n", .{in1});
    std.debug.print("{d}\n", .{in2});
    std.debug.print("{d}\n", .{in3});
}
