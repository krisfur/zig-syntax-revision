const std = @import("std"); // import as expected
const print = std.debug.print; // you can also do aliasing here, a bit pythonic

//import external functions from a library - C style
extern fn importedAddInt(a: i128, b: i128) i128; // very C/C++ like, basically a header to the function we import

//import external modules - zig style
const myModule = @import("myModule");

// different notes chapters;
const valuesModule = @import("valuesModule");
const listsModule = @import("listsModule");
const branchesAndLoopsModule = @import("branchesAndLoopsModule");
const pointersModule = @import("pointersModule");

pub fn main() !void { // !void returns void or error
    // There are no multiline comments in zig, git gud or use your IDEs ctrl+/
    // using /// makes doc comments that get joined together into one multiline bit of documentation

    // Print to stderr:
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    // without macros to print to stdout or stderr:
    try std.io.getStdOut().writer().writeAll("Hello, World!\n"); //note that the official docs for 0.15.2 are wrong on this
    // try keyword is needed for functions that can panic/return error

    // using an imported function from a C style library
    const externallyAdded = importedAddInt(6, 7);
    print("{}\n", .{externallyAdded});

    // or with a full module
    const externallyAdded2 = myModule.importedAddInt(6, 7);
    print("{}\n", .{externallyAdded2});

    // See other files for different topics
    try valuesModule.executeValues(); // VALUES
    try listsModule.executeLists(); // TUPLES, ARRAYS, SLICES, VECTORS, DESTRUCTURING
    try branchesAndLoopsModule.executeBranchesAndLoops(); // BRANCHES, LOOPS
    try pointersModule.executePointers(); // POINTERS
}

test "simple test" { //tests run with "zig test ./src/main.zig"
    const gpa = std.testing.allocator;
    var list = std.ArrayList(i32).init(gpa);
    defer list.deinit();
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
