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
}

// If you don’t have any previous experience with base64, you might not understand the differences between “encode” and “decode”. Essentially, the terms “encode” and “decode” here have the exact same meaning as they have in the field of encryption (i.e., they mean the same thing as “encode” and “decode” in hashing algorithms, like the MD5 algorithm).

// One task that we need to do is to calculate how much space we need to reserve for the output, both of the encoder and decoder. This is simple math, and can be done easily in Zig because every array has its length (its number of elements) easily accesible by consulting the .len property of the array.

// For the encoder, the logic is the following: for each 3 bytes that we find in the input, 4 new bytes are created in the output. So, we take the number of bytes in the input, divide it by 3, use a ceiling function, then, we multiply the result by 4. That way, we get the total number of bytes that will be produced by the encoder in its output.

// Calculate the encoding length
fn _calc_encode_lengt(input: []const u8) !usize {
    if (input.len < 3) {
        return 4;
    }
    const n_groups: usize = try std.math.divCeil(usize, input.len, 3);
    return n_groups * 4;
}
