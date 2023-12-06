const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Point = struct {
    line: usize,
    character: usize,
    valid: bool,
};

const GearSum = struct {
    sum: u32,
    num_adj: u32,
};

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 3);
    defer input.deinit();

    var sum: u32 = 0;
    for (input.lines, 0..) |line, line_num| {
        //std.debug.print("{s}\n", .{line});

        var inNum: bool = false;
        var numStart: usize = 0;
        var adjacent: bool = false;
        for (line, 0..) |character, character_index| {
            if (isNum(character)) {
                if (inNum == false) {
                    inNum = true;
                    numStart = character_index;
                }
                if (isSymbolAdjacent(line_num, character_index, input)) {
                    adjacent = true;
                }
                if (character_index == line.len - 1) {
                    const parsed_num = try std.fmt.parseInt(u32, line[numStart .. character_index + 1], 10);
                    if (adjacent) {
                        //std.debug.print("parsed:{d} Adjacent at end\n", .{parsed_num});
                        sum += parsed_num;
                    } else {
                        //std.debug.print("parsed:{d} at end\n", .{parsed_num});
                    }
                    inNum = false;
                    adjacent = false;
                }
            } else {
                if (inNum) {
                    const parsed_num = try std.fmt.parseInt(u32, line[numStart..character_index], 10);
                    if (adjacent) {
                        //std.debug.print("parsed:{d} Adjacent\n", .{parsed_num});
                        sum += parsed_num;
                    } else {
                        //std.debug.print("parsed:{d}\n", .{parsed_num});
                    }
                    inNum = false;
                    adjacent = false;
                }
            }
        }
    }

    //std.debug.print("\n{d}\n", .{sum});
    return sum;
}

fn isNum(c: u8) bool {
    return switch (c) {
        '0'...'9' => true,
        else => false,
    };
}

fn isSymbolAdjacent(line: usize, character: usize, file: aoc_util.AocFile) bool {
    const width = file.lines[0].len;
    const height = file.lines.len;

    // check above
    if (line >= 1) {
        if (isSymbol(file.lines[line - 1][character])) return true;
        if (character >= 1 and isSymbol(file.lines[line - 1][character - 1])) return true;
        if (character < width - 1 and isSymbol(file.lines[line - 1][character + 1])) return true;
    }

    // check same line
    if (character >= 1 and isSymbol(file.lines[line][character - 1])) return true;
    if (character < width - 1 and isSymbol(file.lines[line][character + 1])) return true;

    //check below
    if (line < height - 1) {
        if (isSymbol(file.lines[line + 1][character])) return true;
        if (character >= 1 and isSymbol(file.lines[line + 1][character - 1])) return true;
        if (character < width - 1 and isSymbol(file.lines[line + 1][character + 1])) return true;
    }

    return false;
}

fn isStarAdjacent(line: usize, character: usize, file: aoc_util.AocFile) Point {
    const width = file.lines[0].len;
    const height = file.lines.len;

    // check above
    if (line >= 1) {
        if (file.lines[line - 1][character] == '*') return Point{ .line = line - 1, .character = character, .valid = true };
        if (character >= 1 and file.lines[line - 1][character - 1] == '*') return Point{ .line = line - 1, .character = character - 1, .valid = true };
        if (character < width - 1 and file.lines[line - 1][character + 1] == '*') return Point{ .line = line - 1, .character = character + 1, .valid = true };
    }

    // check same line
    if (character >= 1 and file.lines[line][character - 1] == '*') return Point{ .line = line, .character = character - 1, .valid = true };
    if (character < width - 1 and file.lines[line][character + 1] == '*') return Point{ .line = line, .character = character + 1, .valid = true };

    //check below
    if (line < height - 1) {
        if (file.lines[line + 1][character] == '*') return Point{ .line = line + 1, .character = character, .valid = true };
        if (character >= 1 and file.lines[line + 1][character - 1] == '*') return Point{ .line = line + 1, .character = character - 1, .valid = true };
        if (character < width - 1 and file.lines[line + 1][character + 1] == '*') return Point{ .line = line + 1, .character = character + 1, .valid = true };
    }

    return Point{
        .line = 0,
        .character = 0,
        .valid = false,
    };
}

fn isSymbol(c: u8) bool {
    return switch (c) {
        '0'...'9' => false,
        '.' => false,
        else => true,
    };
}

pub fn part2old() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 3);
    defer input.deinit();

    var sum: u32 = 0;
    for (input.lines, 0..) |line, line_num| {
        //std.debug.print("{s}\n", .{line});

        for (line, 0..) |character, character_index| {
            if (character == '*') {
                const ratio = gearAdjacent(line_num, character_index, input);
                if (ratio > 0) {
                    sum += ratio;
                }
            }
        }
    }
    //std.debug.print("\n{d}\n", .{sum});
    return sum;
}

fn gearAdjacent(line: usize, character: usize, file: aoc_util.AocFile) u32 {
    const width = file.lines[0].len;
    _ = width;
    const height = file.lines.len;

    var number: u32 = 0;
    var adjacent: u32 = 0;
    var nums: [8]u32 = undefined;

    // check above
    if (line >= 1) {
        number = parseNumber(line - 1, character, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
        number = parseNumber(line - 1, character - 1, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
        number = parseNumber(line - 1, character + 1, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
    }

    // check same line
    number = parseNumber(line, character - 1, file);
    if (number > 0) {
        nums[adjacent] = number;
        adjacent += 1;
    }
    number = parseNumber(line, character + 1, file);
    if (number > 0) {
        nums[adjacent] = number;
        adjacent += 1;
    }

    //check below
    if (line < height - 1) {
        number = parseNumber(line + 1, character, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
        number = parseNumber(line + 1, character - 1, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
        number = parseNumber(line + 1, character + 1, file);
        if (number > 0) {
            nums[adjacent] = number;
            adjacent += 1;
        }
    }

    if (adjacent == 2) {
        //std.debug.print("two adj at {d}:{d}\n", .{ character, nums[0] * nums[1] });
        return nums[0] * nums[1];
    }
    return 0;
}

fn parseNumber(line: usize, character: usize, file: aoc_util.AocFile) u32 {
    if (!isNum(file.lines[line][character])) return 0;
    const width = file.lines[0].len;
    var c_index: usize = character;

    while (c_index > 0) {
        const isNumber = isNum(file.lines[line][c_index]);
        if (isNumber) {
            c_index -= 1;
        } else {
            c_index += 1;
            break;
        }
    }

    var endIndex: usize = c_index + 1;
    while (endIndex < width) {
        if (isNum(file.lines[line][endIndex])) {
            endIndex += 1;
        } else {
            break;
        }
    }
    endIndex -= 1;

    const number = std.fmt.parseInt(u32, file.lines[line][c_index .. endIndex + 1], 10) catch 0;

    while (c_index <= endIndex) {
        file.lines[line][c_index] = 'x';
        c_index += 1;
    }

    //std.debug.print("got num:{d}\n", .{number});
    return number;
}

pub fn part2() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 3);
    defer input.deinit();

    var gearMap = std.AutoArrayHashMap(usize, GearSum).init(allocator);
    defer gearMap.deinit();

    var sum: u32 = 0;
    for (input.lines, 0..) |line, line_num| {
        //std.debug.print("{s}\n", .{line});

        var inNum: bool = false;
        var numStart: usize = 0;
        var point: Point = Point{ .valid = false, .line = undefined, .character = undefined };
        for (line, 0..) |character, character_index| {
            if (isNum(character)) {
                if (inNum == false) {
                    inNum = true;
                    numStart = character_index;
                }
                if (point.valid == false) {
                    point = isStarAdjacent(line_num, character_index, input);
                }
                //std.debug.print("{d}.{d} * -> {d}.{d} {any}\n", .{ line_num, character_index, point.line, point.character, point.valid });
                if (character_index == line.len - 1) {
                    const parsed_num = try std.fmt.parseInt(u32, line[numStart .. character_index + 1], 10);
                    if (point.valid) {
                        //std.debug.print("parsed:{d} Adjacent at end\n", .{parsed_num});
                        const key = point.line * 100000 + point.character;
                        //std.debug.print("key:{d}\n", .{key});
                        const value: ?GearSum = gearMap.get(key);
                        if (value) |v| {
                            //std.debug.print("got existing:sum{d} adj:{d}\n", .{ v.sum, v.num_adj });
                            try gearMap.put(key, GearSum{ .sum = parsed_num * v.sum, .num_adj = v.num_adj + 1 });
                        } else {
                            //std.debug.print("got new:sum{d} adj:{d}\n", .{ parsed_num, 1 });
                            try gearMap.put(key, GearSum{ .sum = parsed_num, .num_adj = 1 });
                        }
                    } else {
                        //std.debug.print("parsed:{d} at end\n", .{parsed_num});
                    }
                    inNum = false;
                    point.valid = false;
                }
            } else {
                if (inNum) {
                    const parsed_num = try std.fmt.parseInt(u32, line[numStart..character_index], 10);
                    if (point.valid) {
                        //std.debug.print("parsed:{d} Adjacent\n", .{parsed_num});
                        const key = point.line * 100000 + point.character;
                        //std.debug.print("key:{d}\n", .{key});
                        const value: ?GearSum = gearMap.get(key);
                        if (value) |v| {
                            //std.debug.print("got existing:sum{d} adj:{d}\n", .{ v.sum, v.num_adj });
                            try gearMap.put(key, GearSum{ .sum = parsed_num * v.sum, .num_adj = v.num_adj + 1 });
                        } else {
                            //std.debug.print("got new:sum{d} adj:{d}\n", .{ parsed_num, 1 });
                            try gearMap.put(key, GearSum{ .sum = parsed_num, .num_adj = 1 });
                        }
                    } else {
                        //std.debug.print("parsed:{d}\n", .{parsed_num});
                    }
                    inNum = false;
                    point.valid = false;
                }
            }
        }
    }

    for (gearMap.keys()) |key| {
        const geary = gearMap.get(key);
        if (geary) |gear| {
            //std.debug.print("{d} - adj:{d} {d}\n", .{ key, gear.num_adj, gear.sum });
            if (gear.num_adj == 2) {
                sum += gear.sum;
            }
        } else {
            //std.debug.print("ERROR!!!!!!!!!!!!!!!!!!!!!!!!!! {d}\n", .{key});
        }
    }

    //std.debug.print("\n{d}\n", .{sum});
    return sum;
}
