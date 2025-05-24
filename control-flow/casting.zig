const std = @import("std");
const expect = std.testing.expect;

test "Checking type of pointer to be u32" {
    const bytes align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    try expect(@TypeOf(u32_ptr) == *const u32);
}
