const std = @import("std");

pub fn main() !void {
    const number: u8 = 5;
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
