# Zig syntax revision notes

Basic notes on Zig syntax and setting up a project.

## Project setup

1. Create a directory and navigate to it
2. Initialise with

```bash
zig init
```

3. Inspect the `src` directory, it created a library in `root.zig` that is linked to in the program file `main.zig`
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