const std = @import("std");
const aoc_util = @import("../util/io.zig");

const Hand = struct {
    cards: [5]u8,
    bid: u32,
    matchiness: u32,
};

pub fn part1() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 7);
    defer input.deinit();

    var hands = std.ArrayList(Hand).init(allocator);
    defer hands.deinit();

    for (input.lines) |line| {
        var iter = std.mem.splitSequence(u8, line, " ");
        if (iter.next()) |hand| {
            if (iter.next()) |bid| {
                var h: Hand = undefined;
                for (hand, 0..) |_, i| {
                    h.cards[i] = cardToNum(hand[i]);
                }
                h.matchiness = getMatchiness(h);
                h.bid = try std.fmt.parseInt(u32, bid, 10);
                try hands.append(h);
            }
        }
    }

    std.mem.sort(Hand, hands.items, {}, cmpHands);

    var sum: u32 = 0;
    for (hands.items, 0..) |item, rank| {
        sum += item.bid * @as(u32, @intCast(rank + 1));
        //std.debug.print("{any}\n", .{item});
    }

    return sum;
}

pub fn part2() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var input = try aoc_util.AocFile.readInput(allocator, 7);
    defer input.deinit();

    var hands = std.ArrayList(Hand).init(allocator);
    defer hands.deinit();

    for (input.lines) |line| {
        var iter = std.mem.splitSequence(u8, line, " ");
        if (iter.next()) |hand| {
            if (iter.next()) |bid| {
                var h: Hand = undefined;
                for (hand, 0..) |_, i| {
                    h.cards[i] = cardToNum2(hand[i]);
                }
                h.matchiness = getMatchiness2(h);
                h.bid = try std.fmt.parseInt(u32, bid, 10);
                try hands.append(h);
            }
        }
    }

    std.mem.sort(Hand, hands.items, {}, cmpHands);

    var sum: u32 = 0;
    for (hands.items, 0..) |item, rank| {
        sum += item.bid * @as(u32, @intCast(rank + 1));
        //std.debug.print("{any}\n", .{item});
    }

    return sum;
}

fn cmpHands(context: void, a: Hand, b: Hand) bool {
    _ = context;
    if (a.matchiness < b.matchiness) return true;
    if (a.matchiness > b.matchiness) return false;

    var i: u32 = 0;
    while (i < 5) : (i += 1) {
        if (a.cards[i] < b.cards[i]) return true;
        if (a.cards[i] > b.cards[i]) return false;
    }
    return false;
}

fn getMatchiness(h: Hand) u32 {
    var freq = [_]u8{0} ** 15;
    var i: u32 = 0;
    while (i < 5) : (i += 1) {
        freq[h.cards[i]] += 1;
    }

    std.mem.sort(u8, &freq, {}, std.sort.desc(u8));

    if (freq[0] == 5) return 7;
    if (freq[0] == 4) return 6;
    if (freq[0] == 3 and freq[1] == 2) return 5;
    if (freq[0] == 3) return 4;
    if (freq[0] == 2 and freq[1] == 2) return 3;
    if (freq[0] == 2) return 2;
    return 1;
}

fn getMatchiness2(h: Hand) u32 {
    var freq = [_]u8{0} ** 15;
    var i: u32 = 0;
    var jokers: u8 = 0;
    while (i < 5) : (i += 1) {
        if (h.cards[i] == 1) {
            jokers += 1;
            continue;
        }
        freq[h.cards[i]] += 1;
    }

    std.mem.sort(u8, &freq, {}, std.sort.desc(u8));
    freq[0] += jokers;

    if (freq[0] == 5) return 7;
    if (freq[0] == 4) return 6;
    if (freq[0] == 3 and freq[1] == 2) return 5;
    if (freq[0] == 3) return 4;
    if (freq[0] == 2 and freq[1] == 2) return 3;
    if (freq[0] == 2) return 2;
    return 1;
}

fn cardToNum(card: u8) u8 {
    return switch (card) {
        'A' => 14,
        'K' => 13,
        'Q' => 12,
        'J' => 11,
        'T' => 10,
        '9' => 9,
        '8' => 8,
        '7' => 7,
        '6' => 6,
        '5' => 5,
        '4' => 4,
        '3' => 3,
        '2' => 2,
        else => 0,
    };
}

fn cardToNum2(card: u8) u8 {
    return switch (card) {
        'A' => 13,
        'K' => 12,
        'Q' => 11,
        'T' => 10,
        '9' => 9,
        '8' => 8,
        '7' => 7,
        '6' => 6,
        '5' => 5,
        '4' => 4,
        '3' => 3,
        '2' => 2,
        'J' => 1,
        else => 0,
    };
}
