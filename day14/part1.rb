#!/usr/bin/env ruby

map = $stdin.each_line.map(&:chomp).map(&:chars)

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

load = map.each_with_index.map do |row, y|
  row.map {|cell| cell == 'O' ? map.size - y : 0}.sum
end.sum

puts load