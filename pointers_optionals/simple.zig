const std = @import("std");

pub fn main() !void {
    var number: u8 = 5;
    const pointer = &number;

    // Pointer is an object that contains a memory address.
    // This memory address is the address where a particular value is stored in memory
    std.debug.print("{d}\n", .{pointer.*});

    // We can run oprations on pointers
    const doubled = 2 * pointer.*;
    std.debug.print("{d}\n", .{doubled});

    // Working with the user struct
    const u = User.init(1, "Pedro", "email@gmail.com");
    const user_pointer = &u;
    try user_pointer.*.print_name();

    // Changing the value of the object.
    pointer.* = 8;
    try std.io.getStdOut().writer().print("{d}\n", .{number});

    // Changing constant values of pointer object references.
    const c1: u8 = 8;
    const c2: u8 = 12;
    var pointer_number = &c1;
    try std.io.getStdOut().writer().print("Before: {d}\n", .{pointer_number.*});
    pointer_number = &c2;
    try std.io.getStdOut().writer().print("After: {d}\n", .{pointer_number.*});

    // Pointer arithmetics
    const ar = [_]i32{ 1, 2, 3, 4 };
    var ptr: [*]const i32 = &ar;
    try std.io.getStdOut().writer().print("{d}\n", .{ptr[0]});
    ptr += 1;
    try std.io.getStdOut().writer().print("{d}\n", .{ptr[0]});
    ptr += 1;
    try std.io.getStdOut().writer().print("{d}\n", .{ptr[0]});
    ptr += 1;
    try std.io.getStdOut().writer().print("{d}\n", .{ptr[0]});

    // Access the elements using slices
    const sl = ar[0..ar.len];
    std.debug.print("Slice: {d}\n", .{sl[2]});
}

const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    fn print_name(self: User) !void {
        try std.io.getStdOut().writer().print("{s}\n", .{self.name});
    }
};
