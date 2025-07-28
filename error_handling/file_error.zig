const std = @import("std");
const dir = std.fs.cwd();
const logger = std.io.getStdErr();

pub fn main() !void {
    _ = dir.openFile("doesnt_exist.txt", .{}) catch |err| {
        try logger.writer().print("{any}\n", .{err});
        return;
    };
}
