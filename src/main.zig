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

fn slice_len(slice: []const u8) u8 {
    var sum: u8 = 0;
    for (slice) |_| sum += 1;
    return sum;
}

test "slice count" {
    const array = [_]u8{ 1, 2, 3, 4, 5, 6 };
    const slice = array[0..5];
    testing.expectEqual(@as(u8, 5), slice_len(slice));
}

const Game = enum {
    var count: u8 = 0;
    rocketleague,
    minecraft,
    valorant,

    pub fn isGood(self: Game) bool {
        return self != Game.valorant;
    }
};

test "is game gud" {
    testing.expect(!Game.valorant.isGood());
    testing.expect(Game.minecraft.isGood());
    Game.count += 1;
    testing.expectEqual(@as(u8, 1), Game.count);
}

const Rectangle = struct {
    length: i32,
    width: i32,

    pub fn swap(self: *Rectangle) void {
        const tmp = self.length;
        self.length = self.width;
        self.width = tmp;
    }
};

test "swap rectangle sides" {
    var rect = Rectangle{ .length = 100, .width = 50 };
    testing.expectEqual(rect.length, @as(i32, 100));
    testing.expectEqual(rect.width, @as(i32, 50));
    rect.swap();
    testing.expectEqual(rect.length, @as(i32, 50));
    testing.expectEqual(rect.width, @as(i32, 100));
}

// union(enum) converts this to a tagged union
// backed by an enum which means we can switch
// over the tags to find the value which is
// currently set.
const Monad = union(enum) {
    ok: i32,
    err: [1]u8,
};

test "union" {
    var onion = Monad{ .err = [1]u8{'a'} };
    // The names in the || closure are the temporary
    // variables created to be used in the RHS expression
    switch (onion) {
        .ok => |*ok| ok.* += 1,
        .err => |*err| err.* = [1]u8{'b'},
    }
    testing.expectEqual(onion.err[0], 'b');
}
