const std = @import("std");
const m = std.math;
const stdout = std.io.getStdOut().writer();

const Vec3 = struct {
    x: f64,
    y: f64,
    z: f64,

    pub fn distance(self: Vec3, other: Vec3) f64 {
        const xd = m.pow(f64, self.x - other.x, 2.0);
        const yd = m.pow(f64, self.y - other.y, 2.0);
        const zd = m.pow(f64, self.z - other.z, 2.0);
        return m.sqrt(xd + yd + zd);
    }

    pub fn magnitude(self: Vec3) f64 {
        const xp = self.x * self.x;
        const yp = self.y * self.y;
        const zp = self.z * self.z;
        return m.sqrt(xp + yp + zp);
    }

    // I could also use a Struct inference @TypeOf(.{ .vec = @as(f64, 0), ... })
    // Anonymousstruct works too.
    pub fn magnitudes(self: Vec3, other: Vec3) struct { vecA: f64, vecB: f64 } {
        // Magnitude of the first vector
        const xp = m.pow(f64, self.x, 2.0);
        const yp = m.pow(f64, self.y, 2.0);
        const zp = m.pow(f64, self.z, 2.0);
        // Magnitude of the second vector
        const xpo = m.pow(f64, other.x, 2.0);
        const ypo = m.pow(f64, other.y, 2.0);
        const zpo = m.pow(f64, other.z, 2.0);
        // Calculate the magnitude
        const vecA = m.sqrt(xp + yp + zp);
        const vecB = m.sqrt(xpo + ypo + zpo);
        // Result
        return .{ .vecA = vecA, .vecB = vecB };
    }

    pub fn dotProduct(self: Vec3, other: Vec3) f64 {
        return (self.x * other.x) + (self.y * other.y) + (self.z * other.z);
    }

    // Calculate the angle between 2 poles
    pub fn calculateAngle(mag1: f64, mag2: f64, dotP: f64) f64 {
        // Get the magnitude of both vectors
        // cosø = dot.Product/mag1 * mag2
        const result = dotP / (mag1 * mag2);
        return m.radiansToDegrees(m.acos(result));
    }
};

pub fn main() !void {
    // Type of the return result
    const MagnitudeType = @TypeOf(Vec3.magnitudes(undefined, undefined));

    const v1 = Vec3{ .x = 4.2, .y = 2.4, .z = 0.9 };
    const v2 = Vec3{ .x = 5.1, .y = 5.6, .z = 1.6 };

    const distance = v1.distance(v2);

    const dotProductResult = Vec3.dotProduct(v1, v2);

    // Get the magnitude of the 2 vectors
    const magnitude1 = v1.magnitude();
    const magnitude2 = v2.magnitude();
    const result: MagnitudeType = v1.magnitudes(v2);

    // Calculate the angle of poles
    const angleOfPoles = Vec3.calculateAngle(magnitude1, magnitude2, dotProductResult);

    // Print out of the calculations
    try stdout.print("Distance: {d:.2}\n", .{distance});
    try stdout.print("V1 Magnitude: {d:.2}\n", .{magnitude1});
    try stdout.print("V2 Magnitude: {d:.2}\n", .{magnitude2});
    try stdout.print("Angle of Poles: {d:.2}\n", .{angleOfPoles});
    try stdout.print("Magnitude: \nVector A - {d:.2}\nVector B - {d:.2}\n", .{ result.vecA, result.vecB });
}
