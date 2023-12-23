#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def inspect
    "(#{x}, #{y})"
  end
  alias_method :to_s, :inspect

  def +(other)
    Coord.new(x + other.dx, y + other.dy)
  end
end

Heading = Struct.new(:dx, :dy) do
  def inspect
    "(#{dx}, #{dy})"
  end
  alias_method :to_s, :inspect
end

HEADINGS = [
  Heading.new(0, -1),
  Heading.new(1, 0),
  Heading.new(0, 1),
  Heading.new(-1, 0),
]

spaces = Hash[$stdin.each_line.each_with_index.flat_map do |line, y|
  line.chomp.each_char.each_with_index.filter_map do |char, x|
    [Coord.new(x, y), char] unless char == '#'
  end
end]

# Turn the map into a graph
start = spaces.keys.min_by(&:y)
target = spaces.keys.max_by(&:y)

nodes = Set.new([start, target] + spaces.keys.filter do |coord|
  HEADINGS.map {|h| coord + h}.count {|c| spaces.key?(c)} > 2
end)

graph = Hash.new {|h, k| h[k] = {}}

nodes.each do |node|
  queue = [[node]]
  until (cur = queue.shift).nil?
    neighbours = HEADINGS.filter_map do |heading|
      next_coord = cur[-1] + heading
      next if !spaces.key?(next_coord)
      next if cur.include?(next_coord)
      if spaces[next_coord] != '.'
        next unless {
          '^' => Heading.new(0, -1),
          '>' => Heading.new(1, 0),
          'v' => Heading.new(0, 1),
          '<' => Heading.new(-1, 0),
        }[spaces[next_coord]] == heading
      end
      next_coord
    end

    neighbours.each do |neighbour|
      if nodes.include?(neighbour)
        graph[node][neighbour] = cur.length
      else
        queue << cur + [neighbour]
      end
    end
  end
end

# Find longest path through the graph
queue = [[start]]
paths = []

until (cur = queue.shift).nil?
  neighbours = graph[cur[-1]].keys.filter {|n| !cur.include?(n)}
  neighbours.each do |neighbour|
    if neighbour == target
      paths << cur + [neighbour]
    else
      queue << cur + [neighbour]
    end
  end
end

distances = paths.map {|path| path.each_cons(2).map {|a, b| graph[a][b]}.sum}
puts distances.max