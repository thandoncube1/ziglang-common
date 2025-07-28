const std = @import("std");
const dir = std.fs.cwd();

pub fn main() !void {
    _ = dir.openFile("doesnt_exist.txt", .{});
}
