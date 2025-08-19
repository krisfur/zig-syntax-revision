# Zig syntax revision notes

Basic notes on Zig syntax and setting up a project.

> On Windows you need to add the location of your zig.exe to exclusions in Microsoft Defender to not experience horrible pauses when compiling. Even if you install with `winget`! To find your install location run `zig env`.

## Project setup

1. Create a directory and navigate to it
2. Initialise with

```bash
zig init
```

3. Inspect the `src` directory, it created a library in `root.zig` that is linked to in the program file `main.zig`

<details>
<summary>main.zig</summary>

```zig
//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "use other module" {
    try std.testing.expectEqual(@as(i32, 150), lib.add(100, 50));
}

test "fuzz example" {
    const Context = struct {
        fn testOne(context: @This(), input: []const u8) anyerror!void {
            _ = context;
            // Try passing `--fuzz` to `zig build test` and see if it manages to fail this test case!
            try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input));
        }
    };
    try std.testing.fuzz(Context{}, Context.testOne, .{});
}

const std = @import("std");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
const lib = @import("zig_syntax_revision_lib");
```
</details>

<details>
<summary>root.zig</summary>

```zig
//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
```
</details>

4. To quickly build and run your program use:

```bash
zig build run
```

and to also run tests:

```bash
zig build test
```

## Build flags

Default build is the debug mode

### Release builds

- `--release-safe` -> heavy optimisation and all safety checks
- `--release-fast` -> best optimisation with no safety checks
- `--release-small` -> optimises for smallest binary size

### Cross-platform compilation

You use the Dtarget flag:

```bash
zig build -Dtarget=x86_64-windows-gnu
```

run `zig targets` to find a full list

### Custom options

The zig build chain lets you define custom flags for your program, for example versioning:

```zig
// In build.zig
const version = b.option(
    []const u8, // The data type (a string)
    "version",  // The name of the option
    "Set the application version", // A description
) orelse "0.0.0-dev"; // Default value if not provided
```

```bash
zig build -Dversion=1.2.3
```

## Linking libraries

Linking is majorly done throug the zig build system in ways analogous to CMake in C(++)

### System libraries:

```zig
// In build.zig
const exe = b.addExecutable(.{
    .name = "my-app",
    .root_source_file = .{ .path = "src/main.zig" },
    .target = target,
    .optimize = optimize,
});

// 👇 Link system libraries here
exe.linkSystemLibrary("c");
exe.linkSystemLibrary("raylib");

b.installArtifact(exe);
```

### Dependencies

Point to the library source code location:

```zig
// In build.zig
const my_math_lib = b.addStaticLibrary(.{
    .name = "my_math",
    .root_source_file = .{ .path = "libs/my_math/src/root.zig" }, // Path to the library's source
    .target = target,
    .optimize = optimize,
});
```

link it:

```zig
// In build.zig, after defining the library
const exe = b.addExecutable(.{
    .name = "my-app",
    .root_source_file = .{ .path = "src/main.zig" },
    .target = target,
    .optimize = optimize,
});

// 👇 Link the library from source
exe.linkLibrary(my_math_lib);

b.installArtifact(exe);
```