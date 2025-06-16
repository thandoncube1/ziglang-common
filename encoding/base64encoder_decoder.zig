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
