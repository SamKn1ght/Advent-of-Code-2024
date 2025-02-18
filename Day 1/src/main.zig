const std = @import("std");
const lib = @import("root.zig");

const file_path = "resources/input.txt";

var GenAlloc = std.heap.GeneralPurposeAllocator(.{}){};

pub fn main() !void {
    const allocator = GenAlloc.allocator();
    defer {
        _ = GenAlloc.deinit();
    }

    const stdout = std.io.getStdOut().writer();

    const file_stats = try std.fs.cwd().statFile(file_path);
    const file_size = file_stats.size;

    const input = try std.fs.cwd().readFileAlloc(allocator, file_path, file_size);
    defer allocator.free(input);

    const lists = try lib.processColumns(allocator, input);
    defer lists.deinit();

    const solution_one = lib.solvePartOne(lists);

    try stdout.print("Solution to part one: {}\n", .{solution_one});

    const solution_two = try lib.solvePartTwo(allocator, lists);

    try stdout.print("Solution to part two: {}\n", .{solution_two});
}
