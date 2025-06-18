const std = @import("std");
const encoder_decoder = @import("base64encoder_decoder.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var memory_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();

    // Encoded text
    const eText = "G�VzG�luy�Bz2�1lG�1vm�Ug3�R1ZmY=";
    const base64 = encoder_decoder.Base64.init();

    const decoded_text = try base64.decode(allocator, eText);
    try stdout.print("Decoded text: {s}\n", .{decoded_text});
}
