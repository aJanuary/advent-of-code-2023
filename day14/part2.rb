#!/usr/bin/env ruby

require 'set'

TARGET_CYCLES = 1_000_000_000

def roll_north(map)
  (1...map.size).each do |y|
    (0...map[y].size).each do |x|
      if map[y][x] == 'O'
        new_y = y
        while new_y > 0 && map[new_y - 1][x] == '.'
          new_y -= 1
        end
        map[y][x] = '.'
        map[new_y][x] = 'O'
      end
    end
  end  
end

def roll_east(map)
  (0...map.size).each do |y|
    (map[y].size - 2).downto(0).each do |x|
      if map[y][x] == 'O'
        new_x = x
        while new_x < map[y].size - 1 && map[y][new_x + 1] == '.'
          new_x += 1
        end
        map[y][x] = '.'
        map[y][new_x] = 'O'
      end
    end
  end  
end

def roll_south(map)
  (map.size - 2).downto(0).each do |y|
    (0...map[y].size).each do |x|
      if map[y][x] == 'O'
        new_y = y
        while new_y < map.size - 1 && map[new_y + 1][x] == '.'
          new_y += 1
        end
        map[y][x] = '.'
        map[new_y][x] = 'O'
      end
    end
  end  
end

def roll_west(map)
  (0...map.size).each do |y|
    (1...map[y].size).each do |x|
      if map[y][x] == 'O'
        new_x = x
        while new_x > 0 && map[y][new_x - 1] == '.'
          new_x -= 1
        end
        map[y][x] = '.'
        map[y][new_x] = 'O'
      end
    end
  end  
end

def cycle(map)
  map = map.map(&:dup)
  roll_north(map)
  roll_west(map)
  roll_south(map)
  roll_east(map)
  map
end

map = $stdin.each_line.map(&:chomp).map(&:chars)

seen_tally = Hash.new {|h, k| h[k] = []}

(0...Float::INFINITY).each do |i|
  map = cycle(map)
  seen_tally[map] << i
  break if seen_tally[map].size == 2
end

loop_start, loop_end = seen_tally[map]
loop_length = loop_end - loop_start

after_target_cycles = ((TARGET_CYCLES - loop_start - 1) % loop_length) + loop_start
final_map = seen_tally.find {|k, v| v.include?(after_target_cycles)}[0]

load = final_map.each_with_index.map do |row, y|
  row.map {|cell| cell == 'O' ? final_map.size - y : 0}.sum
end.sum

puts load