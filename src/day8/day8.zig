const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Node = struct {
    left: *Node,
    right: *Node,
    name: [3]u8,
    left_name: [3]u8,
    right_name: [3]u8,

    fn init() Node {
        return Node{
            .left = undefined,
            .right = undefined,
            .name = undefined,
            .left_name = undefined,
            .right_name = undefined,
        };
    }
};

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 8);
    defer input.deinit();

    var directions = std.ArrayList(u8).init(allocator);
    defer directions.deinit();

    for (input.lines[0]) |direction| {
        try directions.append(direction);
    }

    var nodes = std.StringHashMap(Node).init(allocator);
    defer nodes.deinit();

    for (input.lines[2..], 2..) |line, line_num| {
        _ = line_num;
        const start = line[0..3];
        const left = line[7..10];
        const right = line[12..15];
        //std.debug.print("{s} {s} {s}\n", .{ start, left, right });
        var n = Node.init();
        @memcpy(&n.name, start);
        @memcpy(&n.left_name, left);
        @memcpy(&n.right_name, right);
        try nodes.put(start, n);
    }

    var current_node = [_]u8{ 'A', 'A', 'A' };
    var step: u32 = 0;
    while (true) {
        for (directions.items) |direction| {
            if (nodes.get(&current_node)) |v| {
                if (direction == 'L') {
                    @memcpy(&current_node, &v.left_name);
                } else {
                    @memcpy(&current_node, &v.right_name);
                }
                step += 1;
                if (std.mem.eql(u8, &current_node, "ZZZ")) {
                    return step;
                }
            }
        }
    }

    current_node = "ZZZ";

    return 0;
}

pub fn part2() !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 8);
    defer input.deinit();

    var directions = std.ArrayList(u8).init(allocator);
    defer directions.deinit();

    for (input.lines[0]) |direction| {
        try directions.append(direction);
    }

    var nodes = std.StringHashMap(Node).init(allocator);
    defer nodes.deinit();

    for (input.lines[2..], 2..) |line, line_num| {
        _ = line_num;
        const start = line[0..3];
        const left = line[7..10];
        const right = line[12..15];
        //std.debug.print("{s} {s} {s}\n", .{ start, left, right });
        var n = Node.init();
        @memcpy(&n.name, start);
        @memcpy(&n.left_name, left);
        @memcpy(&n.right_name, right);
        try nodes.put(start, n);
    }

    var current_nodes = [6][3]u8{
        [_]u8{ 'A', 'A', 'A' },
        [_]u8{ 'B', 'F', 'A' },
        [_]u8{ 'D', 'F', 'A' },
        [_]u8{ 'X', 'F', 'A' },
        [_]u8{ 'Q', 'J', 'A' },
        [_]u8{ 'S', 'B', 'A' },
    };
    var step = [_]u64{0} ** 6;
    while (true) {
        for (directions.items) |direction| {
            var complete: u32 = 0;
            for (0..6) |current_node| {
                if (current_nodes[current_node][2] == 'Z') {
                    complete += 1;
                    continue;
                }

                if (nodes.get(&current_nodes[current_node])) |v| {
                    if (direction == 'L') {
                        @memcpy(&current_nodes[current_node], &v.left_name);
                    } else {
                        @memcpy(&current_nodes[current_node], &v.right_name);
                    }
                    step[current_node] += 1;
                }
            }
            if (complete == 6) {
                var result: u64 = step[0];
                for (step[1..]) |num| {
                    result = lcm(result, num);
                }
                return result;
            }
        }
    }

    return 0;
}

fn gcd(a: u64, b: u64) u64 {
    var i: u64 = 1;
    var result: u64 = 0;
    while (i <= a and i <= b) : (i += 1) {
        if (a % i == 0 and b % i == 0) {
            result = i;
        }
    }
    return result;
}

fn lcm(a: u64, b: u64) u64 {
    if (a == 0 or b == 0) {
        return 0;
    }
    return (a / gcd(a, b)) * b;
}
