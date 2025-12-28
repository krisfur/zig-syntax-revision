// TUPLES, ARRAYS, SLICES, VECTORS, DESTRUCTURING
const std = @import("std");
const print = std.debug.print;

pub fn executeLists() !void { // !void returns void or error
    var x: u32 = undefined;
    var y: u32 = undefined;
    var z: u32 = undefined;

    const myTuple = .{ 2, 3 };
    x, y = myTuple; //we destruct the tuple and grab the values

    const myArray = [_]u32{ 3, 4, 5 }; //arrays need a defined type
    x, y, z = myArray; //same thing

    // [TO DO]
    // slices - pointer and a length
    // slice length is known only at runtime, unlike arrays which are known at compile time

    const myVector: @Vector(3, u32) = .{ 6, 7, 8 }; //vectors need a defined length using a comptime int, and defined type
    x, y, z = myVector; //same thing
    print("\nx:{},y:{},z:{}\n", .{ x, y, z }); //what we've been using for this have just been tuples!
    print("x:{},y:{}\n", myTuple); //same thing!

    // [TO DO]
    // adding, popping, revesing, etc. etc. - usual operations
}
