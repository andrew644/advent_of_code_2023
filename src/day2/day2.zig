const std = @import("std");
const aoc_util = @import("../util/io.zig");

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 2);
    defer input.deinit();

    var sum: u32 = 0;
    var line_num: u32 = 0;
    while (line_num < input.lines.len) {
        var iter = std.mem.splitSequence(u8, input.lines[line_num], ": ");
        _ = iter.next();
        if (iter.next()) |post_colon| {
            var possible = true;
            var iter_colors = std.mem.splitSequence(u8, post_colon, "; ");
            while (iter_colors.next()) |colors| {
                if (isGamePossible(colors) == false) {
                    possible = false;
                }
                //std.debug.print("{s}\n", .{colors});
            }

            if (possible) {
                sum += line_num + 1;
            }
        }
        line_num += 1;
    }
    //std.debug.print("{d}\n", .{sum});
    return sum;
}

pub fn isGamePossible(colors: []const u8) bool {
    var iter = std.mem.splitSequence(u8, colors, ", ");
    while (iter.next()) |color| {
        var quantity: u32 = 0;
        var iter2 = std.mem.splitSequence(u8, color, " ");
        if (iter2.next()) |num| {
            quantity = std.fmt.parseInt(u32, num, 10) catch 0;
        }
        if (iter2.next()) |color_name| {
            if (color_name[0] == 'b' and quantity > 14) {
                return false;
            }
            if (color_name[0] == 'g' and quantity > 13) {
                return false;
            }
            if (color_name[0] == 'r' and quantity > 12) {
                return false;
            }
        }
    }
    return true;
}

pub fn part2() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 2);
    defer input.deinit();

    var sum: u32 = 0;
    var line_num: u32 = 0;
    while (line_num < input.lines.len) {
        var iter = std.mem.splitSequence(u8, input.lines[line_num], ": ");
        _ = iter.next();
        if (iter.next()) |post_colon| {
            const power = getGamePower(post_colon);
            sum += power;
        }
        line_num += 1;
    }
    //std.debug.print("{d}\n", .{sum});
    return sum;
}

pub fn getGamePower(colors: []const u8) u32 {
    //std.debug.print("{s}\n", .{colors});
    var iter_colors = std.mem.splitSequence(u8, colors, "; ");
    var maxRed: u32 = 0;
    var maxBlue: u32 = 0;
    var maxGreen: u32 = 0;
    while (iter_colors.next()) |subgame| {
        var iter = std.mem.splitSequence(u8, subgame, ", ");
        while (iter.next()) |color| {
            var quantity: u32 = 0;
            var iter2 = std.mem.splitSequence(u8, color, " ");
            if (iter2.next()) |num| {
                quantity = std.fmt.parseInt(u32, num, 10) catch 0;
            }
            if (iter2.next()) |color_name| {
                if (color_name[0] == 'b' and quantity > maxBlue) {
                    maxBlue = quantity;
                }
                if (color_name[0] == 'g' and quantity > maxGreen) {
                    maxGreen = quantity;
                }
                if (color_name[0] == 'r' and quantity > maxRed) {
                    maxRed = quantity;
                }
            }
        }
    }
    //std.debug.print("{d}\n", .{maxGreen * maxBlue * maxRed});
    return maxGreen * maxBlue * maxRed;
}
