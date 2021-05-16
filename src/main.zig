const std = @import("std");
const testing = @import("std").testing;
const print = std.debug.print;

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,
};

const NumericError = error{};

pub fn main() void {
    const inferred_constant: Vec3 = undefined;
    std.debug.print("Hello, {d}!\n", .{inferred_constant});

    const implicitly_sized_array = [_]u8{ 0, 1, 2, 3 };
    std.debug.print("This is an array: {}\n", .{implicitly_sized_array});
}

test "implicitly sized array length" {
    const arr = [_]u8{ 10, 20, 30, 40 };
    testing.expectEqual(arr.len, 4);
}

test "while with continue expression" {
    var sum: u32 = 0;
    var i: u8 = 64;
    while (i > 0) : (i -= 1) {
        sum += i;
    }
    testing.expectEqual(sum, 2080);
}

test "for" {
    const base: u32 = 97;
    for ([_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g' }) |char, idx| {
        testing.expect(char == (base + idx));
    }
}

test "multi defer" {
    var x: u8 = 10;
    {
        // Executed in reverse order, so the division happens before addition
        defer x += 3;
        defer x /= 5;
    }
    testing.expect(x == 5);
}

fn mayError(shouldError: bool) anyerror!u32 {
    return if (shouldError) error.NumericError else 10;
}

test "error handling" {
    const r1 = mayError(true) catch 0;
    testing.expectEqual(r1, 0);
    const r2 = mayError(false) catch 0;
    testing.expectEqual(r2, 10);
    const r3 = mayError(true) catch |err| {
        testing.expectEqual(err, error.NumericError);
        return;
    };
}

test "const pointers" {
    const x: u8 = 32;
    var y = &x;
    // This will fail to compile with
    // error: cannot assign to constant
    // y.* += 1;
}

test "0 pointer" {
    const x: u8 = 0;
    // This will fail to compile with
    // error: pointer type '*u8' does not allow address zero
    // const y: *u8 = @intToPtr(*u8, x);
}
