// pointers
const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

pub fn executePointers() !void {
    var someValue: i32 = 67;
    const someValuePointer = &someValue;
    print("{}\n", .{someValuePointer}); //prints the type@address
    print("{}\n", .{someValuePointer.*}); //dereference to get the value
    someValuePointer.* += 2; //dereference to mutate the value
    print("{}\n", .{someValuePointer.*}); //nice

    // pointers for arrays
    var array = [_]i32{ 1, 2, 3, 4 };
    const ptr = &array[2]; //get a pointer to 3rd item in the array
    print("{}\n", .{ptr.*}); //dereference to get the value
    try expect(@TypeOf(ptr) == *i32); //the type of a pointer is *type
    // pointer arithmetic is supported
    var ptrArray: [*]const i32 = &array; //the pointer will now be var to be mutable, the type is hard to infer so be explicit
    try expect(ptrArray[0] == 1);
    ptrArray += 1;
    try expect(ptrArray[0] == 2);
    // this is a bit unsafe, better to use slices which are bound checking
    var array2 = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    var start: usize = 2; // var to make it runtime-known
    _ = &start; // suppress 'var is never mutated' error
    const slice = array2[start..4];
    try expect(slice.len == 2);
    try expect(array2[3] == 4);
    slice[1] += 1;
    try expect(array2[3] == 5);
    // you can use pointers at comptime as well, zig is zig, just can't preserve memory addresses if you dereference pointers
}
