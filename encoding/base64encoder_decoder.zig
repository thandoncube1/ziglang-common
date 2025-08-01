const std = @import("std");
const expect = std.testing.expect;

pub const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";
        return Base64{
            ._table = upper ++ lower ++ numbers_symb,
        };
    }

    fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
    }

    fn _char_index(self: Base64, char: u8) u8 {
        if (char == '=')
            return 64;
        var index: u8 = 0;
        for (0..63) |i| {
            if (self._char_at(i) == char)
                break;
            index += 1;
        }

        return index;
    }

    // If you don’t have any previous experience with base64, you might not understand the differences between “encode” and “decode”. Essentially, the terms “encode” and “decode” here have the exact same meaning as they have in the field of encryption (i.e., they mean the same thing as “encode” and “decode” in hashing algorithms, like the MD5 algorithm).

    // One task that we need to do is to calculate how much space we need to reserve for the output, both of the encoder and decoder. This is simple math, and can be done easily in Zig because every array has its length (its number of elements) easily accesible by consulting the .len property of the array.

    // For the encoder, the logic is the following: for each 3 bytes that we find in the input, 4 new bytes are created in the output. So, we take the number of bytes in the input, divide it by 3, use a ceiling function, then, we multiply the result by 4. That way, we get the total number of bytes that will be produced by the encoder in its output.

    // Calculate the encoding length
    pub fn _calc_encode_length(self: Base64, input: []const u8) !usize {
        _ = self;
        if (input.len < 3) {
            return 4;
        }
        const n_groups: usize = try std.math.divCeil(usize, input.len, 3);
        return n_groups * 4;
    }

    //  for each 4 bytes in the input, 3 bytes will be produced in the output of the decoder.

    // [Logic]: we take the length of the input and divide it by 4, then we apply a floor function on the result, then we multiply the result by 3, and then, we subtract from the result how much times the character = is found in the input.

    pub fn _calc_decode_length(self: Base64, input: []const u8) !usize {
        _ = self; // Explicitly mark as used
        if (input.len < 4) {
            return 3;
        }
        const n_groups: usize = try std.math.divFloor(usize, input.len, 4);
        var multiple_groups: usize = n_groups * 3;
        var i: usize = input.len - 1;

        while (i > 0) : (i -= 1) {
            if (input[i] == '=') {
                multiple_groups -= 1;
            } else {
                break;
            }
        }

        return multiple_groups;
    }

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
                out[iout] = self._char_at(((buf[0] & 0x03) << 4) + (buf[1] >> 4));
                out[iout + 2] = self._char_at(((buf[1] & 0x0f) << 2) + (buf[2] >> 6));
                out[iout + 3] = self._char_at(buf[2] & 0x3f);
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

    pub fn decode(self: Base64, allocator: std.mem.Allocator, input: []const u8) ![]u8 {
        if (input.len == 0) {
            return "";
        }
        const n_output = try self._calc_decode_length(input);
        var output = try allocator.alloc(u8, n_output);
        var count: u8 = 0;
        var iout: u64 = 0;
        var buf = [4]u8{ 0, 0, 0, 0 };

        for (0..input.len) |i| {
            buf[count] = self._char_index(input[i]);
            count += 1;
            if (count == 4) {
                output[iout] = (buf[0] << 2) + (buf[1] >> 4);
                if (buf[2] != 64) {
                    output[iout + 1] = (buf[1] << 4) + (buf[2] >> 2);
                }
                if (buf[3] != 64) {
                    output[iout + 2] = (buf[2] << 6) + buf[3];
                }
                iout += 3;
                count = 0;
            }
        }

        return output;
    }
};

test "is Character at index isAlphebetic" {
    const base64 = Base64.init();
    const character: u8 = base64._char_at(28); // Is character a 'c'

    try expect(std.ascii.isAlphabetic(character));
    try expect(std.ascii.isLower(character));
    try expect(character == 'c');
}

pub fn main() !void {
    const base64 = Base64.init();

    // Print a character at an index
    try std.io.getStdOut().writer().print("Character at index 28: {c}\n", .{base64._char_at(28)});

    // Bit-shifting in Zig works similarly to bit-shifting in C. All bitwise operators that exist in C are available in Zig. Here, in the base64 encoder algorithm, they are essential to produce the result we want.
    const input = "Hi";
    try std.io.getStdOut().writer().print("Shift Right - {d}\n", .{input[0] >> 2});
    const char_index: i32 = input[0] >> 2;
    try std.io.getStdOut().writer().print("Converting after shifting: {c}\n", .{base64._char_at(char_index)});

    try std.io.getStdOut().writer().print("Shift left - {d}\n", .{input[0] << 2});
    try std.io.getStdOut().writer().print("Converting after shifting: {c}\n", .{base64._char_at(input[0] << 2)});

    // Working with bits
    const bits = 0b10010111;
    try std.io.getStdOut().writer().print("{d}\n", .{bits & 0b00110000});
}
