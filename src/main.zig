const std = @import("std");

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

pub fn main() void {
    const inferred_constant: Vec3 = undefined;
    std.debug.print("Hello, {d}!\n", .{inferred_constant});
}
