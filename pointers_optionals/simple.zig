const std = @import("std");

pub fn main() void {
    const number: u8 = 5;
    const pointer = &number;

    // Pointer is an object that contains a memory address.
    // This memory address is the address where a particular value is stored in memory
    std.debug.print("{d}\n", .{pointer.*});

    // We can run oprations on pointers
    const doubled = 2 * pointer.*;
    std.debug.print("{d}\n", .{doubled});
}
