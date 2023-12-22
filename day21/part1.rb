#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def inspect
    "(#{x}, #{y})"
  end
  alias_method :to_s, :inspect
end

lines = $stdin.readlines
height = lines.size
width = lines[0].chomp.length
walls = Set.new
start = nil

lines.each_with_index do |line, y|
  line.each_char.each_with_index do |char, x|
    walls << Coord.new(x, y) if char == '#'
    start = Coord.new(x, y) if char == 'S'
  end
end

tips = Set.new([start])
64.times do
  tips = Set.new(tips.flat_map do |tip|
    [
      Coord.new(tip.x + 1, tip.y),
      Coord.new(tip.x - 1, tip.y),
      Coord.new(tip.x, tip.y + 1),
      Coord.new(tip.x, tip.y - 1),
    ].filter do |neighbor|
      neighbor.x >= 0 && neighbor.x < width &&
        neighbor.y >= 0 && neighbor.y < height &&
        !walls.include?(neighbor)
    end
  end)
end

puts tips.size