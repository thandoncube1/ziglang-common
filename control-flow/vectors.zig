const std = @import("std");
const m = std.math;

const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = m.pow(f64, self.x - other.x, 2.0);
        const yd = m.pow(f64, self.y - other.y, 2.0);
        const zd = m.pow(f64, self.z - other.z, 2.0);
        return m.floor(m.sqrt(xd + yd + zd));
    }
};

pub fn main() !void {
    const v1 = Vec3{ .x = 4.2, .y = 2.4, .z = 0.9 };
    const v2 = Vec3{ .x = 5.1, .y = 5.6, .z = 1.6 };

    try std.io.getStdOut().writer().print("Distance: {d}\n", .{v1.distance(v2)});
}
