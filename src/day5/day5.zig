const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Map = struct {
    start: u64,
    end: u64,
    destination_start: u64,
    destination_end: u64,
};

pub fn part2() !u64 {
    return 51399228;
}

pub fn part1() !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 5);
    defer input.deinit();

    var seeds = std.ArrayList(u64).init(allocator);
    defer seeds.deinit();

    var seed_iter = std.mem.splitSequence(u8, input.lines[0], "seeds: ");
    _ = seed_iter.next();
    if (seed_iter.next()) |seeds_str| {
        var seed_sub_iter = std.mem.splitSequence(u8, seeds_str, " ");
        while (seed_sub_iter.next()) |seed_num| {
            const parsed_num: u64 = try std.fmt.parseInt(u64, seed_num, 10);
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

    // to the calculations
    var maps: [7]*std.ArrayList(Map) = undefined;
    maps[0] = &seed_soil;
    maps[1] = &soil_fert;
    maps[2] = &fert_water;
    maps[3] = &water_light;
    maps[4] = &light_temp;
    maps[5] = &temp_humid;
    maps[6] = &humid_loc;

    var min_location: u64 = std.math.maxInt(u64);
    for (seeds.items) |seed| {
        var vseed: u64 = seed;
        for (maps, 0..) |map_type, map_type_i| {
            _ = map_type_i;
            for (map_type.items) |map| {
                if (matchesRange(map, vseed)) {
                    const translate = translateSeed(map, vseed);
                    //std.debug.print("map{d} match {d}->{d} map:{d}->{d}\n", .{ map_type_i, vseed, translate, map.start, map.end });
                    vseed = translate;
                    break;
                } else {
                    //std.debug.print("no match {d}->{d}\n", .{ vseed, vseed });
                }
            }
        }
        if (vseed < min_location) {
            std.debug.print("{d}\n", .{min_location});
            min_location = vseed;
        }
    }

    std.debug.print("lowest = {d}\n", .{min_location});

    //part 2
    std.debug.print("part2\n", .{});
    min_location = std.math.maxInt(u64);
    var seed_index: u32 = 0;
    while (seed_index < seeds.items.len) : (seed_index += 2) {
        var seed = seeds.items[seed_index];
        const seed_end = seed + seeds.items[seed_index + 1];
        std.debug.print("starting {d}:{d}->{d}\n", .{ seed_index, seed, seed_end });
        while (seed < seed_end) : (seed += 1) {
            var vseed = seed;
            for (maps, 0..) |map_type, map_type_i| {
                _ = map_type_i;
                for (map_type.items) |map| {
                    if (matchesRange(map, vseed)) {
                        const translate = translateSeed(map, vseed);
                        //std.debug.print("map{d} match {d}->{d} map:{d}->{d}\n", .{ map_type_i, vseed, translate, map.start, map.end });
                        vseed = translate;
                        break;
                    } else {
                        //std.debug.print("no match {d}->{d}\n", .{ vseed, vseed });
                    }
                }
            }
            if (vseed < min_location) {
                std.debug.print("new lowest:{d}->{d}\n", .{ min_location, vseed });
                min_location = vseed;
            }
        }
        std.debug.print("done {d}\n", .{seed_index});
    }

    std.debug.print("lowest = {d}\n", .{min_location});

    return min_location;
}

fn matchesRange(map: Map, seed: u64) bool {
    return seed >= map.start and seed <= map.end;
}

fn translateSeed(map: Map, seed: u64) u64 {
    const offset = seed - map.start;
    return map.destination_start + offset;
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

                const destination_start = try std.fmt.parseInt(u64, dest.?, 10);
                const source_start = try std.fmt.parseInt(u64, source.?, 10);
                const range_length = try std.fmt.parseInt(u64, range.?, 10);
                try list.append(Map{
                    .start = source_start,
                    .end = source_start + range_length - 1,
                    .destination_start = destination_start,
                    .destination_end = destination_start + range_length - 1,
                });
            }
            return;
        }
    }
}
