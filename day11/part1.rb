#!/usr/bin/env ruby

Coord = Struct.new(:x, :y) do
  def inspect
    "(#{x}, #{y})"
  end
end

galaxies = []
$stdin.each_line.each_with_index do |line, y|
  line.chomp.chars.each_with_index do |char, x|
    galaxies << Coord.new(x, y) if char == '#'
  end
end

max_x = galaxies.map(&:x).max
max_y = galaxies.map(&:y).max

empty_cols = (0..max_x).filter {|x| galaxies.none? {|coord| coord.x == x}}
empty_rows = (0..max_y).filter {|y| galaxies.none? {|coord| coord.y == y}}

expanded = galaxies.map do |coord|
  Coord.new(coord.x + empty_cols.count {|x| x < coord.x},
            coord.y + empty_rows.count {|y| y < coord.y})
end

distances = expanded.combination(2).map do |a, b|
  dx = (a.x - b.x).abs
  dy = (a.y - b.y).abs
  dx + dy
end

puts distances.sum