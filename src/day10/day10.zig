const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Point = struct {
    x: u32,
    y: u32,
};

const Adjacent = struct {
    a: Point,
    b: Point,
};

pub fn part1() !u32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var visits = try allocator.alloc([]u32, 140);
    var i: u32 = 0;
    while (i < 140) : (i += 1) {
        visits[i] = try allocator.alloc(u32, 140);
        for (visits[i], 0..) |_, j| {
            visits[i][j] = 0;
        }
    }

    var l = Point{ .x = 53, .y = 75 };
    const input = try aoc_util.AocFile.readInput(allocator, 10);

    visits[l.y][l.x] = 1;
    l.x += 1;

    var steps: u32 = 2;
    while (true) {
        const adj = try getAdjacent(l, input);
        if (visits[adj.a.y][adj.a.x] == 1 and visits[adj.b.y][adj.b.x] == 1) break;
        if (visits[adj.a.y][adj.a.x] == 0) {
            visits[adj.a.y][adj.a.x] = 1;
            l = adj.a;
        } else {
            visits[adj.b.y][adj.b.x] = 1;
            l = adj.b;
        }
        steps += 1;
    }

    //std.debug.print("{d}\n", .{steps});
    return steps / 2;
}

pub fn part2() !u32 {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var visits = try allocator.alloc([]u32, 140);
    var i: u32 = 0;
    while (i < 140) : (i += 1) {
        visits[i] = try allocator.alloc(u32, 140);
        for (visits[i], 0..) |_, j| {
            visits[i][j] = 0;
        }
    }

    var l = Point{ .x = 53, .y = 75 };
    const input = try aoc_util.AocFile.readInput(allocator, 10);
    input.lines[l.y][l.x] = '-';

    visits[l.y][l.x] = 1;
    l.x += 1;

    var steps: u32 = 2;
    while (true) {
        const adj = try getAdjacent(l, input);
        if (visits[adj.a.y][adj.a.x] == 1 and visits[adj.b.y][adj.b.x] == 1) break;
        if (visits[adj.a.y][adj.a.x] == 0) {
            visits[adj.a.y][adj.a.x] = 1;
            l = adj.a;
        } else {
            visits[adj.b.y][adj.b.x] = 1;
            l = adj.b;
        }
        steps += 1;
    }

    //std.debug.print("{d}\n", .{steps});
    return steps / 2;
}

fn getAdjacent(p: Point, file: aoc_util.AocFile) !Adjacent {
    const current_char: u8 = file.lines[p.y][p.x];
    //std.debug.print("{any}:{c}\n", .{ p, current_char });
    return switch (current_char) {
        '|' => Adjacent{
            .a = Point{ .x = p.x, .y = p.y - 1 },
            .b = Point{ .x = p.x, .y = p.y + 1 },
        },
        '-' => Adjacent{
            .a = Point{ .x = p.x + 1, .y = p.y },
            .b = Point{ .x = p.x - 1, .y = p.y },
        },
        'L' => Adjacent{
            .a = Point{ .x = p.x, .y = p.y - 1 },
            .b = Point{ .x = p.x + 1, .y = p.y },
        },
        'J' => Adjacent{
            .a = Point{ .x = p.x, .y = p.y - 1 },
            .b = Point{ .x = p.x - 1, .y = p.y },
        },
        '7' => Adjacent{
            .a = Point{ .x = p.x, .y = p.y + 1 },
            .b = Point{ .x = p.x - 1, .y = p.y },
        },
        'F' => Adjacent{
            .a = Point{ .x = p.x, .y = p.y + 1 },
            .b = Point{ .x = p.x + 1, .y = p.y },
        },
        else => return error.InvalidChar,
    };
}
