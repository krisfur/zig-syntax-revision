const std = @import("std"); // import as expected
const print = std.debug.print; // you can also do aliasing here, a bit pythonic

pub fn main() !void {
    // There are no multiline comments in zig, git gud or use your IDEs ctrl+/
    // using /// makes doc comments that get joined together into one multiline bit of documentation

    // Print to stderr:
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    // without macros to print to stdout or stderr:
    try std.io.getStdOut().writer().writeAll("Hello, World!\n"); //note that the official docs for 0.15.2 are wrong on this

    // VALUES

    const integer: i32 = 1 + 3; //const cannot be changed
    var floaty: f64 = 32.0; //var can be changed
    floaty += 37.0;
    print("We have {} of type {} and {} of type {}.", .{ integer, @TypeOf(integer), floaty, @TypeOf(floaty) });
    //print(integer + floaty); would fail
    print("\n{}+{}={}\n", .{ integer, floaty, integer + floaty }); //adding int and float gives float, no type error
    const myString: []const u8 = "hewwo"; //strings are arrays of u8, so UTF-8 supported
    print("{s}\n", .{myString}); //fmt needs to know that this is meant as a string literal
}

test "simple test" { //tests run with "zig test ./src/main.zig"
    const gpa = std.testing.allocator;
    var list = std.ArrayList(i32).init(gpa);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
