const std = @import("std");
const aoc_util = @import("../util/io.zig");

pub fn part1() !i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try aoc_util.AocFile.readInput(allocator, 12);

    for (input.lines) |line| {
        var damaged_list = std.ArrayList(u32).init(allocator);
        var iter = std.mem.splitSequence(u8, line, " ");
        const gear_str = iter.next() orelse return error.InputParseError;
        const damaged_str = iter.next() orelse return error.InputParseError;
        var iter_damaged = std.mem.splitSequence(u8, damaged_str, ",");
        while (iter_damaged.next()) |n| {
            const damaged = try std.fmt.parseInt(u32, n, 10);
            try damaged_list.append(damaged);
        }
        std.debug.print("{s} ", .{gear_str});
        for (damaged_list.items) |n| {
            std.debug.print("{d} ", .{n});
        }
        std.debug.print("\n", .{});
    }

    return 0;
}
