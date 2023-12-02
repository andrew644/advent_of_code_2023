const std = @import("std");
const aoc_util = @import("../util/io.zig");

pub fn part1() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator);
    defer input.deinit();

    var sum: u32 = 0;
    var line_num: u32 = 0;
    while (line_num < input.lines.len) {
        var first: u32 = 0;
        var last: u32 = 0;
        for (input.lines[line_num]) |c| {
            const n: u32 = switch (c) {
                49 => 1,
                50 => 2,
                51 => 3,
                52 => 4,
                53 => 5,
                54 => 6,
                55 => 7,
                56 => 8,
                57 => 9,
                else => 0,
            };
            if (n == 0) {
                continue;
            }
            if (first == 0) {
                first = n;
            }
            if (last == 0) {
                last = n;
            } else {
                last = n;
            }
        }
        sum += 10 * first + last;
        line_num += 1;
    }

    std.debug.print(".{d}.\n", .{sum});
}

pub fn part2() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator);
    defer input.deinit();

    var sum: u32 = 0;
    var line_num: u32 = 0;
    while (line_num < input.lines.len) {
        var s_tmp: [1024]u8 = undefined;
        @memcpy(s_tmp[0..input.lines[line_num].len], input.lines[line_num]);
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "one")) |pos| {
            s_tmp[pos + 1] = '1';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "two")) |pos| {
            s_tmp[pos + 1] = '2';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "three")) |pos| {
            s_tmp[pos + 1] = '3';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "four")) |pos| {
            s_tmp[pos] = '4';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "five")) |pos| {
            s_tmp[pos] = '5';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "six")) |pos| {
            s_tmp[pos] = '6';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "seven")) |pos| {
            s_tmp[pos] = '7';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "eight")) |pos| {
            s_tmp[pos + 1] = '8';
        }
        while (std.ascii.indexOfIgnoreCase(s_tmp[0..], "nine")) |pos| {
            s_tmp[pos + 1] = '9';
        }
        var first: u32 = 0;
        var last: u32 = 0;
        for (s_tmp) |c| {
            const n: u32 = switch (c) {
                '1' => 1,
                '2' => 2,
                '3' => 3,
                '4' => 4,
                '5' => 5,
                '6' => 6,
                '7' => 7,
                '8' => 8,
                '9' => 9,
                else => 0,
            };
            if (n == 0) {
                continue;
            }
            if (first == 0) {
                first = n;
            }
            if (last == 0) {
                last = n;
            } else {
                last = n;
            }
        }
        sum += 10 * first + last;
        std.debug.print(".{s} -> {s}. answer:{d}.sum:{d}\n", .{ input.lines[line_num], s_tmp, 10 * first + last, sum });
        line_num += 1;
    }

    std.debug.print(".{d}.\n", .{sum});
}
