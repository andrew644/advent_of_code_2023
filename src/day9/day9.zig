const std = @import("std");
const aoc_util = @import("../util/io.zig");

pub fn part1() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try aoc_util.AocFile.readInput(allocator, 9);

    var sum: i32 = 0;

    for (input.lines) |stability_str| {
        var values = std.ArrayList([]i32).init(allocator);
        var first_line = std.ArrayList(i32).init(allocator);
        var iter = std.mem.splitSequence(u8, stability_str, " ");
        while (iter.next()) |stability_num| {
            const stability = try std.fmt.parseInt(i32, stability_num, 10);
            // std.debug.print("{d} ", .{stability});
            try first_line.append(stability);
        }
        try values.append(try first_line.toOwnedSlice());
        // std.debug.print("\n", .{});

        var level: u32 = 0;
        while (true) : (level += 1) {
            const max_index = values.items[level].len - 1;
            var line: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
            var i: u32 = 0;
            while (i < max_index) : (i += 1) {
                const arr = values.items[level];
                const left = arr[i];
                const right = arr[i + 1];
                var diff: i32 = 0;
                diff = right - left;
                // std.debug.print("{d} ", .{diff});
                try line.append(diff);
            }
            // std.debug.print("\n", .{});
            var all_zero = true;
            for (line.items) |n| {
                if (n != 0) all_zero = false;
            }
            try values.append(try line.toOwnedSlice());
            if (all_zero) {
                // std.debug.print("\nall zero\n", .{});
                break;
            }
        }

        var i = values.items.len - 1;
        var new_v: i32 = 0;
        while (i >= 0) : (i -= 1) {
            const arr = values.items[i];
            if (arr.len == 0) continue;
            new_v = new_v + arr[arr.len - 1];
            // std.debug.print("{d} ", .{new_v});
            if (i == 0) break;
        }
        // std.debug.print("\n\n", .{});
        sum += new_v;
    }

    return sum;
}

pub fn part2() !i32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try aoc_util.AocFile.readInput(allocator, 9);

    var sum: i32 = 0;

    for (input.lines) |stability_str| {
        var values = std.ArrayList([]i32).init(allocator);
        var first_line = std.ArrayList(i32).init(allocator);
        var iter = std.mem.splitSequence(u8, stability_str, " ");
        while (iter.next()) |stability_num| {
            const stability = try std.fmt.parseInt(i32, stability_num, 10);
            // std.debug.print("{d} ", .{stability});
            try first_line.append(stability);
        }
        try values.append(try first_line.toOwnedSlice());
        // std.debug.print("\n", .{});

        var level: u32 = 0;
        while (true) : (level += 1) {
            const max_index = values.items[level].len - 1;
            var line: std.ArrayList(i32) = std.ArrayList(i32).init(allocator);
            var i: u32 = 0;
            while (i < max_index) : (i += 1) {
                const arr = values.items[level];
                const left = arr[i];
                const right = arr[i + 1];
                var diff: i32 = 0;
                diff = right - left;
                // std.debug.print("{d} ", .{diff});
                try line.append(diff);
            }
            // std.debug.print("\n", .{});
            var all_zero = true;
            for (line.items) |n| {
                if (n != 0) all_zero = false;
            }
            try values.append(try line.toOwnedSlice());
            if (all_zero) {
                // std.debug.print("\nall zero\n", .{});
                break;
            }
        }

        var i = values.items.len - 1;
        var new_v: i32 = 0;
        while (i >= 0) : (i -= 1) {
            const arr = values.items[i];
            if (arr.len == 0) continue;
            new_v = arr[0] - new_v;
            // std.debug.print("{d} ", .{new_v});
            if (i == 0) break;
        }
        // std.debug.print("\n\n", .{});
        sum += new_v;
    }

    return sum;
}
