const std = @import("std");
const day1 = @import("day1/day1.zig");
const day2 = @import("day2/day2.zig");
const day3 = @import("day3/day3.zig");
const day4 = @import("day4/day4.zig");
const day5 = @import("day5/day5.zig");
const day6 = @import("day6/day6.zig");

pub fn main() !void {
    std.debug.print("{d}\n", .{try day1.part1()});
    std.debug.print("{d}\n", .{try day1.part2()});

    std.debug.print("{d}\n", .{try day2.part1()});
    std.debug.print("{d}\n", .{try day2.part2()});

    std.debug.print("{d}\n", .{try day3.part1()});
    std.debug.print("{d}\n", .{try day3.part2()});

    std.debug.print("{d}\n", .{try day4.part1()});
    std.debug.print("{d}\n", .{try day4.part2()});

    std.debug.print("{d}\n", .{try day5.part1()});
    std.debug.print("{d}\n", .{try day5.part2()});

    std.debug.print("{d}\n", .{try day6.part1()});
    std.debug.print("{d}\n", .{try day6.part2()});
}

test "day1p1" {
    const actual = try day1.part1();
    const expected: u32 = 53974;
    try std.testing.expectEqual(expected, actual);
}

test "day1p2" {
    const actual = try day1.part2();
    const expected: u32 = 52840;
    try std.testing.expectEqual(expected, actual);
}

test "day2p1" {
    const actual = try day2.part1();
    const expected: u32 = 2771;
    try std.testing.expectEqual(expected, actual);
}

test "day2p2" {
    const actual = try day2.part2();
    const expected: u32 = 70924;
    try std.testing.expectEqual(expected, actual);
}

test "day3p1" {
    const actual = try day3.part1();
    const expected: u32 = 551094;
    try std.testing.expectEqual(expected, actual);
}

test "day3p2" {
    const actual = try day3.part2();
    const expected: u32 = 80179647;
    try std.testing.expectEqual(expected, actual);
}

test "day4p1" {
    const actual = try day4.part1();
    const expected: u32 = 25004;
    try std.testing.expectEqual(expected, actual);
}

test "day4p2" {
    const actual = try day4.part2();
    const expected: u32 = 14427616;
    try std.testing.expectEqual(expected, actual);
}

test "day5p1" {
    const actual = try day5.part1();
    const expected: u64 = 535088217;
    try std.testing.expectEqual(expected, actual);
}

test "day5p2" {
    const actual = try day5.part2();
    const expected: u64 = 51399228;
    try std.testing.expectEqual(expected, actual);
}

test "day6p1" {
    const actual = try day6.part1();
    const expected: u32 = 170000;
    try std.testing.expectEqual(expected, actual);
}

test "day6p2" {
    const actual = try day6.part2();
    const expected: u32 = 20537782;
    try std.testing.expectEqual(expected, actual);
}
