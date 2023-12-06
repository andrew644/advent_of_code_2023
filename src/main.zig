const std = @import("std");
const day1 = @import("day1/day1.zig");
const day2 = @import("day2/day2.zig");
const day3 = @import("day3/day3.zig");
const day4 = @import("day4/day4.zig");
const day5 = @import("day5/day5.zig");

pub fn main() !void {
    //try day1.part1();
    //try day1.part2();
    //try day2.part1();
    //try day2.part2();
    //try day3.part1();
    //try day3.part2();
    //_ = try day4.part1();
    //_ = try day4.part2();
    _ = try day5.part1();
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
