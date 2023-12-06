const std = @import("std");

pub fn part1() !u32 {
    //Time:        35     69     68     87
    //Distance:   213   1168   1086   1248
    var distances: [4]u32 = undefined;
    distances[0] = 213;
    distances[1] = 1168;
    distances[2] = 1086;
    distances[3] = 1248;
    var times: [4]u32 = undefined;
    times[0] = 35;
    times[1] = 69;
    times[2] = 68;
    times[3] = 87;

    var result: u32 = 1;
    var race: u32 = 0;
    while (race < 4) : (race += 1) {
        const time = times[race];
        const distance = distances[race];

        var i: u32 = 1;
        var ways_to_win: u32 = 0;
        while (i < time) : (i += 1) {
            const my_distance = i * (time - i);
            if (my_distance > distance) ways_to_win += 1;
        }
        result *= ways_to_win;
    }

    //std.debug.print("{d}\n", .{result});
    return result;
}

pub fn part2() !u32 {
    const time = 35696887;
    const distance = 213116810861248;

    var i: u64 = 1;
    var ways_to_win: u32 = 0;
    while (i < time) : (i += 1) {
        const my_distance = i * (time - i);
        if (my_distance > distance) ways_to_win += 1;
    }
    //std.debug.print("{d}\n", .{ways_to_win});
    return ways_to_win;
}
