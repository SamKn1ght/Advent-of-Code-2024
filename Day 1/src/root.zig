const std = @import("std");

const line_delimiter = '\n';
const number_delimiter = "   ";
const expected_lines = 1000;

const Columns = struct {
    left: std.ArrayList(i32),
    right: std.ArrayList(i32),

    pub fn deinit(self: Columns) void {
        self.left.deinit();
        self.right.deinit();
    }
};

pub fn processColumns(allocator: std.mem.Allocator, input: []const u8) !Columns {
    var left_list = try std.ArrayList(i32).initCapacity(allocator, expected_lines);
    var right_list = try std.ArrayList(i32).initCapacity(allocator, expected_lines);

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

    return Columns{
        .left = left_list,
        .right = right_list
    };
}

pub fn solvePartOne(lists: Columns) u32 {
    std.sort.heap(i32, lists.left.items, {}, comptime std.sort.asc(i32));
    std.sort.heap(i32, lists.right.items, {}, comptime std.sort.asc(i32));

    var sum = @as(u32, 0);

    for (lists.left.items, lists.right.items) |left, right| {
        sum += @abs(left - right);
    }

    return sum;
}

pub fn solvePartTwo(allocator: std.mem.Allocator, lists: Columns) !i32 { 
    var counter = std.ArrayHashMap(i32, i32, std.array_hash_map.AutoContext(i32), false).init(allocator);
    defer counter.deinit();

    for (lists.right.items) |num| {
        const existing_count = counter.get(num) orelse 0;
        try counter.put(num, existing_count + 1);
    }

    var sum_similarity = @as(i32, 0);

    for (lists.left.items) |num| {
        const count = counter.get(num) orelse 0;
        sum_similarity += num * count;
    }

    return sum_similarity;
}
