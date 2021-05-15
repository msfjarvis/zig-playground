const std = @import("std");
const testing = @import("std").testing;

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

pub fn main() void {
    const inferred_constant: Vec3 = undefined;
    std.debug.print("Hello, {d}!\n", .{inferred_constant});

    const implicitly_sized_array = [_]u8{ 0, 1, 2, 3 };
    std.debug.print("This is an array: {}\n", .{implicitly_sized_array});
}

test "implicitly sized array length" {
    const arr = [_]u8{ 10, 20, 30, 40 };
    std.testing.expect(arr.len == 4);
}

test "while with continue expression" {
    var sum: u32 = 0;
    var i: u8 = 64;
    while (i > 0) : (i -= 1) {
        sum += i;
    }
    testing.expectEqual(sum, 2080);
}
