const std = @import("std");
const aoc_util = @import("../util/io.zig");

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 4);
    defer input.deinit();

    var tickets = std.ArrayList([10]u8).init(allocator);
    defer tickets.deinit();
    var numbers: [100]bool = undefined;
    for (numbers, 0..) |_, i| {
        numbers[i] = false;
    }

    var sum: u32 = 0;
    for (input.lines, 0..) |line, line_num| {
        _ = line_num;
        var iter = std.mem.splitSequence(u8, line, ":");
        _ = iter.next();
        if (iter.next()) |post_colon| {
            var ticket: [10]u8 = undefined;
            var i: usize = 0;
            while (i < 30) : (i += 3) {
                var number_size: usize = 2;
                var extra_space: usize = 1;
                if (post_colon[i + extra_space] == ' ') {
                    extra_space += 1;
                    number_size -= 1;
                }
                const parsed_num = try std.fmt.parseInt(u8, post_colon[i + extra_space .. i + extra_space + number_size], 10);
                ticket[i / 3] = parsed_num;
                //std.debug.print("{d} ", .{parsed_num});
            }
            try tickets.append(ticket);
            //std.debug.print("\n", .{});

            var iter_numbers = std.mem.splitSequence(u8, post_colon, "|");
            _ = iter_numbers.next();
            if (iter_numbers.next()) |post_bar| {
                var j: usize = 0;
                while (j < 75) : (j += 3) {
                    var number_size: usize = 2;
                    var extra_space: usize = 1;
                    if (post_bar[j + extra_space] == ' ') {
                        extra_space += 1;
                        number_size -= 1;
                    }
                    const parsed_num = try std.fmt.parseInt(u8, post_bar[j + extra_space .. j + extra_space + number_size], 10);
                    numbers[parsed_num] = true;
                    //std.debug.print("{d} ", .{parsed_num});
                }
                //std.debug.print("\n", .{});
            }
        }

        var wins: u5 = 0;
        for (tickets.getLast()) |win| {
            //std.debug.print("checking winer{d} {any}\n", .{ win, numbers[win] });
            if (numbers[win]) {
                wins += 1;
            }
        }
        if (wins > 0) {
            const one: u32 = 1;
            sum += one << wins - 1;
            std.debug.print("wins: {d} -> {d}\n", .{ wins, one << wins - 1 });
        } else {
            std.debug.print("no wins: {d} -> {d}\n", .{ wins, 0 });
        }

        for (numbers, 0..) |_, i| {
            numbers[i] = false;
        }
    }

    std.debug.print("sum:{d}\n", .{sum});
    return sum;
}

pub fn part2() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 4);
    defer input.deinit();

    var tickets = std.ArrayList([10]u8).init(allocator);
    defer tickets.deinit();
    var num_wins = std.ArrayList(u32).init(allocator);
    defer num_wins.deinit();
    var numbers: [100]bool = undefined;
    for (numbers, 0..) |_, i| {
        numbers[i] = false;
    }

    var sum: u32 = 0;
    for (input.lines, 0..) |line, line_num| {
        _ = line_num;
        var iter = std.mem.splitSequence(u8, line, ":");
        _ = iter.next();
        if (iter.next()) |post_colon| {
            var ticket: [10]u8 = undefined;
            var i: usize = 0;
            while (i < 30) : (i += 3) {
                var number_size: usize = 2;
                var extra_space: usize = 1;
                if (post_colon[i + extra_space] == ' ') {
                    extra_space += 1;
                    number_size -= 1;
                }
                const parsed_num = try std.fmt.parseInt(u8, post_colon[i + extra_space .. i + extra_space + number_size], 10);
                ticket[i / 3] = parsed_num;
                //std.debug.print("{d} ", .{parsed_num});
            }
            try tickets.append(ticket);
            //std.debug.print("\n", .{});

            var iter_numbers = std.mem.splitSequence(u8, post_colon, "|");
            _ = iter_numbers.next();
            if (iter_numbers.next()) |post_bar| {
                var j: usize = 0;
                while (j < 75) : (j += 3) {
                    var number_size: usize = 2;
                    var extra_space: usize = 1;
                    if (post_bar[j + extra_space] == ' ') {
                        extra_space += 1;
                        number_size -= 1;
                    }
                    const parsed_num = try std.fmt.parseInt(u8, post_bar[j + extra_space .. j + extra_space + number_size], 10);
                    numbers[parsed_num] = true;
                    //std.debug.print("{d} ", .{parsed_num});
                }
                //std.debug.print("\n", .{});
            }
        }

        var wins: u5 = 0;
        for (tickets.getLast()) |win| {
            //std.debug.print("checking winer{d} {any}\n", .{ win, numbers[win] });
            if (numbers[win]) {
                wins += 1;
            }
        }
        if (wins > 0) {
            const one: u32 = 1;
            sum += one << wins - 1;
            std.debug.print("wins: {d} -> {d}\n", .{ wins, one << wins - 1 });
        } else {
            std.debug.print("no wins: {d} -> {d}\n", .{ wins, 0 });
        }
        try num_wins.append(wins);

        for (numbers, 0..) |_, i| {
            numbers[i] = false;
        }
    }

    var copies = try allocator.alloc(u32, input.lines.len);
    defer allocator.free(copies);
    for (copies, 0..) |_, i| {
        copies[i] = 1;
    }

    for (num_wins.items, 0..) |wins, i| {
        std.debug.print("i:{d} copies:{d}\n", .{ i, copies[i] });
        var below: u32 = 0;
        while (below < wins) : (below += 1) {
            copies[i + below + 1] += copies[i];
        }
    }

    var part2_sum: u32 = 0;
    for (copies) |i| {
        part2_sum += i;
    }

    std.debug.print("sum:{d}\n", .{part2_sum});
    return part2_sum;
}
