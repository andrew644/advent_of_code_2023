const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Point = struct {
    x: i64,
    y: i64,
};
pub fn part1() !i64 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = try aoc_util.AocFile.readInput(allocator, 11);

    var h_gaps = std.AutoHashMap(usize, void).init(allocator);
    var v_gaps = std.AutoHashMap(usize, void).init(allocator);

    hori: for (input.lines, 0..) |line, line_num| {
        for (line) |c| {
            if (c == '#') continue :hori;
        }
        try h_gaps.put(line_num, {});
    }
    var column: usize = 0;
    virt: while (column < input.lines[0].len) : (column += 1) {
        for (input.lines) |line| {
            if (line[column] == '#') continue :virt;
        }
        try v_gaps.put(column, {});
    }

    var galaxies = std.ArrayList(Point).init(allocator);
    var line_num: usize = 0;
    var column_num: usize = 0;
    var line_offset: usize = 0;
    var column_offset: usize = 0;
    while (line_num < input.lines.len) : (line_num += 1) {
        if (h_gaps.contains(line_num)) {
            line_offset += 1;
        }
        column_num = 0;
        while (column_num < input.lines[0].len) : (column_num += 1) {
            if (v_gaps.contains(column_num)) {
                column_offset += 1;
            }
            if (input.lines[line_num][column_num] == '#') {
                try galaxies.append(Point{
                    .x = @as(i64, @intCast(column_num + column_offset)),
                    .y = @as(i64, @intCast(line_num + line_offset)),
                });
            }
        }
    }

    var sum: i64 = 0;
    for (galaxies.items, 0..) |g1, i| {
        for (galaxies.items, 0..) |g2, j| {
            if (i == j) continue;
            sum += abs(g1.x - g2.x) + abs(g1.y - g2.y);
        }
    }
    return @divTrunc(sum, 2);
}

fn abs(x: i64) i64 {
    const mask = x >> 63;
    return (x + mask) ^ mask;
}
