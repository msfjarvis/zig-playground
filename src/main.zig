const std = @import("std");

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

pub fn main() void {
    const inferred_constant: Vec3 = undefined;
    std.debug.print("Hello, {d}!\n", .{inferred_constant});

    const implicitly_sized_array = [_]u8{0, 1, 2, 3};
    std.debug.print("This is an array: {}\n", .{implicitly_sized_array});
}
