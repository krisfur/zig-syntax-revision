const std = @import("std"); // import as expected
const print = std.debug.print; // you can also do aliasing here, a bit pythonic

//import external functions from a library
extern fn importedAddInt(a: i128, b: i128) i128; // very C/C++ like, basically a header to the function we import

pub fn main() !void {
    // There are no multiline comments in zig, git gud or use your IDEs ctrl+/
    // using /// makes doc comments that get joined together into one multiline bit of documentation

    // Print to stderr:
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    // without macros to print to stdout or stderr:
    try std.io.getStdOut().writer().writeAll("Hello, World!\n"); //note that the official docs for 0.15.2 are wrong on this

    // VALUES

    const integer: i32 = 1 + 3; //const cannot be changed
    var floaty: f64 = 32.0; //var can be changed, and MUST be initialised to a value or undefined
    floaty += 37.0;
    print("We have {} of type {} and {} of type {}.", .{ integer, @TypeOf(integer), floaty, @TypeOf(floaty) });
    //print(integer + floaty); would fail
    print("\n{}+{}={}\n", .{ integer, floaty, integer + floaty }); //adding int and float gives float, no type error
    const myString: []const u8 = "hewwo"; //strings are arrays of u8, so UTF-8 supported
    print("{s}\n", .{myString}); //fmt needs to know that this is meant as a string literal
    const externallyAdded = importedAddInt(6, 7);
    print("{}\n", .{externallyAdded});

    // optional values also exist
    var optional_thing: ?[]const u8 = null; //we can have a nullable thing! this will be string or null
    print("optional_thing; type: {} value: {?s}\n", .{
        @TypeOf(optional_thing), optional_thing,
    });
    optional_thing = "I'm a real string now!";
    print("optional_thing; type: {} value: {?s}\n", .{
        @TypeOf(optional_thing), optional_thing,
    }); //the type retains the "?" - it can turn null again if needed

    const myBool: bool = true; //bools behave as expected, lowercase true/false
    print("This is true: {}\n", .{myBool});

    // the language has built in asserts as well std.debug.assert(bool)
    std.debug.assert(myBool == true);
    //std.debug.assert(myBool == false); //this will panic to hell

    // you can also infer types for obvious things
    const bytes = "hello";
    print("bytes value: {s}\ntype of bytes: {}\n", .{ bytes, @TypeOf(bytes) }); //inferred a null terminated string literal: *const [5:0]u8
    // if you use {s} you get the string interpretation of the string array, if you use any you get the specific values for each letter:
    // hello vs { 104, 101, 108, 108, 111 }

    // multiline string literals
    const SQL: []const u8 =
        \\SELECT * FROM table
        \\where project = 'hey'
    ;
    print("\n{s}\n", .{SQL});

    // TUPLES, ARRAYS, SLICES, VECTORS, DESTRUCTURING
    var x: u32 = undefined;
    var y: u32 = undefined;
    var z: u32 = undefined;

    const myTuple = .{ 2, 3 };
    x, y = myTuple; //we destruct the tuple and grab the values

    const myArray = [_]u32{ 3, 4, 5 }; //arrays need a defined type
    x, y, z = myArray; //same thing

    // [TO DO]: talk about slices in more detail, slices vs arrays, etc.

    const myVector: @Vector(3, u32) = .{ 6, 7, 8 }; //vectors need a defined length using a comptime int, and defined type
    x, y, z = myVector; //same thing
    print("\nx:{},y:{},z:{}\n", .{ x, y, z }); //what we've been using for this have just been tuples!
    print("x:{},y:{}\n", myTuple); //same thing!

    // BRANCHES, LOOPS

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
    try std.testing.expect(i == 10); //testing expect panics if wrong, does nothing if right

    // break
    while (isItDone) {
        if (i > 15) {
            break;
        }
        i += 1;
    }
    try std.testing.expect(i == 16);

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

    try std.testing.expect(items3[0] == 4);
    try std.testing.expect(items3[1] == 5);
    try std.testing.expect(items3[2] == 3);

    // labels
    var count: usize = 0;
    outer: for (1..6) |_| { //label the loop
        for (1..6) |_| {
            count += 1;
            break :outer; //can break the top loop - amazing!
        }
    }
    try std.testing.expect(count == 1);
}

test "simple test" { //tests run with "zig test ./src/main.zig"
    const gpa = std.testing.allocator;
    var list = std.ArrayList(i32).init(gpa);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
