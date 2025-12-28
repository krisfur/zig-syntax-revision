const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // We create a root module here that is reused by both main exe and unit tests
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"), //path relative to build.zig
        .target = target,
        .optimize = optimize,
    });

    // We import libraries - C style!
    const myLibrary = b.addLibrary(.{
        .name = "myLibrary",
        .linkage = .static, //can do dynamic as well
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/myLibrary.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // We import modules - zig style!
    const myModule = b.addModule("myModule", .{
        .root_source_file = b.path("src/myModule.zig"),
    });

    // different chapters
    const valuesModule = b.addModule("valuesModule", .{
        .root_source_file = b.path("src/01values.zig"),
    });
    const listsModule = b.addModule("listsModule", .{
        .root_source_file = b.path("src/02lists.zig"),
    });
    const branchesAndLoopsModule = b.addModule("branchesAndLoopsModule", .{
        .root_source_file = b.path("src/03branchesAndLoops.zig"),
    });
    const pointersModule = b.addModule("pointersModule", .{
        .root_source_file = b.path("src/04pointers.zig"),
    });

    // This creates an executable artifact that will be built from the module.
    const exe = b.addExecutable(.{
        .name = "zig_syntax_revision",
        .root_module = exe_mod,
    });

    // Link the library/module once the executable is defined
    exe.linkLibrary(myLibrary);
    exe.root_module.addImport("myModule", myModule);
    exe.root_module.addImport("valuesModule", valuesModule);
    exe.root_module.addImport("listsModule", listsModule);
    exe.root_module.addImport("branchesAndLoopsModule", branchesAndLoopsModule);
    exe.root_module.addImport("pointersModule", pointersModule);

    // This declares intent for the executable to be installed into the standard location when the user invokes the "install" step
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another step is evaluated that depends on it.
    const run_cmd = b.addRunArtifact(exe);
    // By making the run step depend on the install step, it will be run from the installation directory rather than directly from within the cache directory.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // ================
    // UNIT TEST STUFF
    // ================
    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to the `zig build --help` menu, providing a way for the user to request running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
