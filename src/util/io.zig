const std = @import("std");
const Allocator = std.mem.Allocator;

pub const AocFile = struct {
    lines: [][]const u8,
    allocator: Allocator,

    pub fn readInput(allocator: Allocator) !AocFile {
        const args = try std.process.argsAlloc(allocator);
        defer std.process.argsFree(allocator, args);
        const file = try std.fs.cwd().openFile(
            args[1],
            .{},
        );
        defer file.close();

        // Read the contents
        const file_metadata = try file.metadata();
        const file_size = file_metadata.size();
        const buffer_size = file_size;
        const file_buffer = try file.readToEndAlloc(allocator, buffer_size);
        defer allocator.free(file_buffer);

        // Split by "\n" and iterate through the resulting slices of "const []u8"
        var iter = std.mem.splitSequence(u8, file_buffer, "\n");
        var file_lines: u32 = 0;
        while (iter.next()) |_| {
            file_lines += 1;
        }
        iter.reset();

        var result = try allocator.alloc([]const u8, file_lines);
        var current_line: u32 = 0;
        while (iter.next()) |line| {
            const heap_line = try allocator.alloc(u8, line.len);
            @memcpy(heap_line, line);
            result[current_line] = heap_line;
            current_line += 1;
        }

        return AocFile{ .lines = result, .allocator = allocator };
    }

    pub fn deinit(self: AocFile) void {
        for (self.lines) |line| {
            self.allocator.free(line);
        }
        self.allocator.free(self.lines);
    }
};
