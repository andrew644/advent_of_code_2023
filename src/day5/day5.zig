const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Map = struct {
    destination_start: u32,
    source_start: u32,
    range_length: u32,
};

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 5);
    defer input.deinit();

    var seeds = std.ArrayList(u32).init(allocator);
    defer seeds.deinit();

    var seed_iter = std.mem.splitSequence(u8, input.lines[0], "seeds: ");
    _ = seed_iter.next();
    if (seed_iter.next()) |seeds_str| {
        var seed_sub_iter = std.mem.splitSequence(u8, seeds_str, " ");
        while (seed_sub_iter.next()) |seed_num| {
            const parsed_num: u32 = try std.fmt.parseInt(u32, seed_num, 10);
            try seeds.append(parsed_num);
        }
    }

    var seed_soil = std.ArrayList(Map).init(allocator);
    defer seed_soil.deinit();
    try parseMap(&seed_soil, input, "seed-to-soil");
    std.debug.print("seed-soil\n", .{});
    for (seed_soil.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var soil_fert = std.ArrayList(Map).init(allocator);
    defer soil_fert.deinit();
    std.debug.print("soil-fert\n", .{});
    try parseMap(&soil_fert, input, "soil-to-fert");
    for (soil_fert.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var fert_water = std.ArrayList(Map).init(allocator);
    defer fert_water.deinit();
    std.debug.print("fert-water\n", .{});
    try parseMap(&fert_water, input, "fertilizer-to-water");
    for (fert_water.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var water_light = std.ArrayList(Map).init(allocator);
    defer water_light.deinit();
    std.debug.print("water-light\n", .{});
    try parseMap(&water_light, input, "water-to-light");
    for (water_light.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var light_temp = std.ArrayList(Map).init(allocator);
    defer light_temp.deinit();
    std.debug.print("light-temp\n", .{});
    try parseMap(&light_temp, input, "light-to-temp");
    for (light_temp.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var temp_humid = std.ArrayList(Map).init(allocator);
    defer temp_humid.deinit();
    std.debug.print("temp-humid\n", .{});
    try parseMap(&temp_humid, input, "temperature-to-humidity");
    for (temp_humid.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    var humid_loc = std.ArrayList(Map).init(allocator);
    defer humid_loc.deinit();
    std.debug.print("humid-location\n", .{});
    try parseMap(&humid_loc, input, "humidity-to-location");
    for (humid_loc.items) |m| {
        std.debug.print("{any}\n", .{m});
    }

    return 0;
}

fn parseMap(list: *std.ArrayList(Map), input: aoc_util.AocFile, name: []const u8) !void {
    var line_num: u32 = 0;
    while (line_num < input.lines.len) : (line_num += 1) {
        if (std.ascii.startsWithIgnoreCase(input.lines[line_num], name)) {
            line_num += 1;
            while (line_num < input.lines.len and input.lines[line_num].len > 0) : (line_num += 1) {
                var iter = std.mem.splitSequence(u8, input.lines[line_num], " ");
                const dest = iter.next();
                const source = iter.next();
                const range = iter.next();

                try list.append(Map{
                    .destination_start = try std.fmt.parseInt(u32, dest.?, 10),
                    .source_start = try std.fmt.parseInt(u32, source.?, 10),
                    .range_length = try std.fmt.parseInt(u32, range.?, 10),
                });
            }
            return;
        }
    }
}
