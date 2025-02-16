const std = @import("std");

const line_delimiter = '\n';
const number_delimiter = "   ";
const expected_lines = 1000;

pub fn solvePartOne(allocator: std.mem.Allocator, input: []const u8) !u32 {
    var left_list = try std.ArrayList(i32).initCapacity(allocator, expected_lines);
    defer left_list.deinit();
    var right_list = try std.ArrayList(i32).initCapacity(allocator, expected_lines);
    defer right_list.deinit();

    var current_value = @as(i32, 0);

    var index = @as(usize, 0);
    while (index < input.len) {
        const char = input[index];
        if (std.ascii.isDigit(char)) {
            current_value *= 10;
            current_value += @as(i32, try std.fmt.charToDigit(char, 10));
        } else if (char == line_delimiter) {
            try right_list.append(current_value);
            current_value = 0;
        } else if (std.mem.startsWith(u8, input[index..], number_delimiter)) {
            try left_list.append(current_value);
            current_value = 0;
            index += number_delimiter.len;
            continue;
        }
        index += 1;
    }

    std.sort.heap(i32, left_list.items, {}, comptime std.sort.asc(i32));
    std.sort.heap(i32, right_list.items, {}, comptime std.sort.asc(i32));

    var sum = @as(u32, 0);

    for (left_list.items, right_list.items) |left, right| {
        sum += @abs(left - right);
    }

    return sum;
}
