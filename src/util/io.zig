const std = @import("std");
const Allocator = std.mem.Allocator;

pub const AocFile = struct {
    lines: [][]u8,
    allocator: Allocator,

    pub fn readInput(allocator: Allocator, day: u32) !AocFile {
        var file_path_buf: [256]u8 = undefined;
        const file_path = try std.fmt.bufPrint(&file_path_buf, "input/input_day{d}.txt", .{day});
        const file = try std.fs.cwd().openFile(
            file_path,
            .{},
        );
        defer file.close();

        // Read the contents
        const file_metadata = try file.metadata();
        const file_size = file_metadata.size();
        const buffer_size = file_size;
        const file_buffer = try file.readToEndAlloc(allocator, buffer_size);
        defer allocator.free(file_buffer);

        var iter = std.mem.splitSequence(u8, file_buffer, "\n");
        var file_lines: u32 = 0;
        var last_line_empty = false;
        while (iter.next()) |line| {
            last_line_empty = line.len == 0;
            file_lines += 1;
        }
        if (last_line_empty) {
            file_lines -= 1;
        }
        iter.reset();

        var result = try allocator.alloc([]u8, file_lines);
        var current_line: u32 = 0;
        while (iter.next()) |line| {
            if (current_line >= file_lines) break;
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
