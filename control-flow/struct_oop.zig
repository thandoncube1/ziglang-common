const std = @import("std");
const stdout = std.io.getStdOut().writer();

const User = struct {
    id: u64,
    name: []const u8,
    email: []const u8,

    fn init(id: u64, name: []const u8, email: []const u8) User {
        return User{ .id = id, .name = name, .email = email };
    }

    fn print_name(self: User) !void {
        try stdout.print("{s}\n", .{self.name});
    }
};

pub fn main() !void {
    const u = User.init(1, "Pedro", "email@gmail.con");
    try u.print_name();
}
