const std = @import("std");
const expect = std.testing.expect;

const Base64 = struct {
    _table: *const [64]u8,

    pub fn init() Base64 {
        const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        const lower = "abcdefghijklmnopqrstuvwxyz";
        const numbers_symb = "0123456789+/";
        return Base64{
            ._table = upper ++ lower ++ numbers_symb,
        };
    }

    pub fn _char_at(self: Base64, index: usize) u8 {
        return self._table[index];
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
}

// If you don’t have any previous experience with base64, you might not understand the differences between “encode” and “decode”. Essentially, the terms “encode” and “decode” here have the exact same meaning as they have in the field of encryption (i.e., they mean the same thing as “encode” and “decode” in hashing algorithms, like the MD5 algorithm).

// One task that we need to do is to calculate how much space we need to reserve for the output, both of the encoder and decoder. This is simple math, and can be done easily in Zig because every array has its length (its number of elements) easily accesible by consulting the .len property of the array.

// For the encoder, the logic is the following: for each 3 bytes that we find in the input, 4 new bytes are created in the output. So, we take the number of bytes in the input, divide it by 3, use a ceiling function, then, we multiply the result by 4. That way, we get the total number of bytes that will be produced by the encoder in its output.

// Calculate the encoding length
fn _calc_encode_length(input: []const u8) !usize {
    if (input.len < 3) {
        return 4;
    }
    const n_groups: usize = try std.math.divCeil(usize, input.len, 3);
    return n_groups * 4;
}

//  for each 4 bytes in the input, 3 bytes will be produced in the output of the decoder.

// [Logic]: we take the length of the input and divide it by 4, then we apply a floor function on the result, then we multiply the result by 3, and then, we subtract from the result how much times the character = is found in the input.

fn _calc_decode_length(input: []const u8) !usize {
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
