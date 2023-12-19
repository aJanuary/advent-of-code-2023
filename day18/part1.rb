#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def inspect
    "(#{x}, #{y})"
  end
  alias_method :to_s, :inspect

  def +(heading)
    Coord.new(x + heading.dx, y + heading.dy)
  end
end

Heading = Struct.new(:dx, :dy) do
  def inspect
    "(#{dx}, #{dy})"
  end
  alias_method :to_s, :inspect
end

directions = $stdin.each_line.map do |line|
  dir_src, dist_src = line.split(' ')
  dir = {
    'R' => Heading.new(1, 0),
    'L' => Heading.new(-1, 0),
    'U' => Heading.new(0, -1),
    'D' => Heading.new(0, 1)
  }[dir_src[0]]
  { dir: dir, dist: dist_src.to_i }
end

edges = Set.new
interior = Set.new
cur = Coord.new(0, 0)
edges << cur

directions.each do |dir|
  dir[:dist].times do
    cur += dir[:dir]
    edges << cur
  end
end

min_x = edges.map(&:x).min
max_x = edges.map(&:x).max
min_y = edges.map(&:y).min
max_y = edges.map(&:y).max

(min_y..max_y).each do |y|
  in_lagoon = false
  (min_x-1..max_x+1).each do |x|
    if edges.include?(Coord.new(x, y)) && edges.include?(Coord.new(x, y-1))
      in_lagoon = !in_lagoon
    elsif in_lagoon
      interior.add(Coord.new(x, y))
    end
  end
end

puts (interior + edges).size