const std = @import("std");
const encoder_decoder = @import("base64encoder_decoder.zig");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var memory_buffer: [1000]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&memory_buffer);
    const allocator = fba.allocator();

    const text = "Testing some more stuff";
    const base64 = encoder_decoder.Base64.init();

    const encoded_text = try base64.encode(allocator, text);
    // Encode the text and get the response
    try stdout.print("Encoded text: {s}\n", .{encoded_text});
}
