// library.zig

// let's make a function that will be imported by other files using the export keyword
export fn importedAddInt(a: i128, b: i128) i128 {
    return a + b;
}
