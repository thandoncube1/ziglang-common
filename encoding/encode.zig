const std = @import("std");
const Base64 = @import("./base64encoder_decoder.zig");
const stdout = std.io.getStdOut().writer();
// Initialize the Base64
const base64 = Base64.init();

pub fn encode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    if (input.len == 0) {
        return "";
    }

    const n_out = try self._calc_encode_length(input);
    var out = try allocator.alloc(u8, n_out);
    var buf = [3]u8{ 0, 0, 0 };
    var count: u8 = 0;
    var iout: u64 = 0;

    for (input, 0..) |_, i| {
        buf[count] = input[i];
        count += 1;
        if (count == 3) {
            out[iout] = base64._char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
            out[iout + 2] = base64._char_at(((buf[1] & 0x0f) << 2) + (buf[2] >> 6));
            out[iout + 3] = base64._char_at(buf[2] & 0x3f);
            iout += 4;
            count = 0;
        }
    }
    if (count == 1) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at((buf[0] & 0x03) << 4);
        out[iout + 2] = '=';
        out[iout + 3] = '=';
    }

    if (count == 2) {
        out[iout] = self._char_at(buf[0] >> 2);
        out[iout + 1] = self._char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
        out[iout + 2] = self._char_at((buf[1] & 0x0f) << 2);
        out[iout + 3] = '=';
        iout += 4;
    }

    return out;
}
