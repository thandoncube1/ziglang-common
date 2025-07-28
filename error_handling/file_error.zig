const std = @import("std");
const dir = std.fs.cwd();
const logger = std.io.getStdErr();

pub fn main() !void {
    const file_path = "doesnt_exist.txt";
    const file = dir.openFile(file_path, .{}) catch |err| switch (err) {
        error.FileNotFound => {
            std.debug.print("File '{s}' does not exist.\n", .{file_path});
            return;
        },
        else => {
            std.debug.print("Error opening file 's': {any}\n", .{file_path});
            return err;
        },
    };

    defer file.close();
}
