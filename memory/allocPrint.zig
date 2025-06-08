const std = @import("std");
const expect = std.testing.expect;

// Testing the FIxed Buffer Allocation
test "fixed buffer allocator" {
    var buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    // Memory allocation
    const memory = try allocator.alloc(u8, 100);
    defer allocator.free(memory);

    try expect(memory.len == 100);
    try expect(@TypeOf(memory) == []u8);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const name = "Thando";
    const output = try std.fmt.allocPrint(allocator, "Hello {s}!!!", .{name});

    std.debug.print("{s}\n", .{output});

    const some_number = try allocator.create(u32);
    defer allocator.destroy(some_number);

    some_number.* = @as(u32, 45);

    std.debug.print("{d}\n", .{some_number.*});
    // To the get the memory address, you just call the variable
    std.debug.print("{d}\n", .{some_number});

    // Fixed size buffer - Allocation
    var buffer: [10]u8 = undefined;
    for (0..buffer.len) |i| {
        buffer[i] = 0; // Initialize to 0
    }

    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const fAllocator = fba.allocator();
    const input = try fAllocator.alloc(u8, 5);
    defer fAllocator.free(input);

    std.debug.print("{d}\n", .{input});
}
