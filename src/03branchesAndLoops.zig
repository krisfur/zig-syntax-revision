// BRANCHES, LOOPS
const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

pub fn executeBranchesAndLoops() !void { // !void returns void or error
    // if
    var isItDone: bool = false;
    if (isItDone) {
        print("It's done.\n", .{});
    } else if (!isItDone) {
        print("It's not done.\n", .{});
        isItDone = true;
        print("Now it's done.\n", .{});
    }

    // switch
    const myInt: u8 = 3;
    switch (myInt) {
        0...3 => print("Between 0 and 3\n", .{}),
        4...9 => print("Between 4 and 9\n", .{}),
        else => print("Bro too big, I dunno...\n", .{}),
    }

    // while loop
    var i: usize = 0;
    while (i < 10) {
        i += 1;
    }
    try expect(i == 10); //testing expect panics if wrong, does nothing if right

    // break
    while (isItDone) {
        if (i > 15) {
            break;
        }
        i += 1;
    }
    try expect(i == 16);

    // for loop
    const items = [_]i32{ 1, 2, 0, 4, 5, 6 };
    var sum: i32 = 0;
    for (items) |value| {
        if (value == 0) {
            continue;
        } else if (value == 5) {
            break;
        }
        sum += value;
    }
    print("{}\n", .{sum}); //1+2+4=7
    // accessing indices
    var sum2: i32 = 0;
    for (items, 0..) |_, j| {
        print("{}\n", .{j});
        sum2 += @as(i32, @intCast(j));
    }
    print("{}\n", .{sum2}); //0+1+2+3+4+5=15

    // multi-object for (zip)
    const items2 = [_]i32{ 6, 5, 4, 0, 2, 6 };
    for (items, items2) |value1, value2| { //need to be same length
        if (value1 == value2) {
            print("Found a match! Value1: {}, Value2: {}\n", .{ value1, value2 });
        }
    }

    // for by reference
    var items3 = [_]i32{ 2, 3, 1 };
    for (&items3) |*value| {
        value.* += 2;
    }

    try expect(items3[0] == 4);
    try expect(items3[1] == 5);
    try expect(items3[2] == 3);

    // labels
    var count: usize = 0;
    outer: for (1..6) |_| { //label the loop
        for (1..6) |_| {
            count += 1;
            break :outer; //can break the top loop - amazing!
        }
    }
    try expect(count == 1);
}
