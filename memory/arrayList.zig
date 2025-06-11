const std = @import("std");
const expect = std.testing.expect;
const eql = std.mem.eql;
const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

test "arraylist" {
    var list = ArrayList(u8).init(test_allocator);
    defer list.deinit();
    try list.append('H');
    try list.append('e');
    try list.append('l');
    try list.append('l');
    try list.append('o');
    try list.appendSlice(" World!");

    try expect(eql(u8, list.items, "Hello World!"));
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var names = ArrayList([]const u8).init(allocator);
    defer names.deinit();

    try names.append("Thando");
    try names.append("Wilson");
    try names.append("James");
    try names.append("Cooley");
    try names.append("Timothy");
    try names.append("Blake");
    try names.append("Damon");
    try names.append("Brett");
    try names.append("Kyliann");

    try std.io.getStdOut().writer().print("{d}\n", .{names.capacity});
}
