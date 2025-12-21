// myModule.zig

// let's make a function that will be imported by other files - no export keyword needed!
pub fn importedAddInt(a: i128, b: i128) i128 {
    return a + b;
}
