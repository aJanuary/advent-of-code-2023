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

spaces = Set.new($stdin.each_line.each_with_index.flat_map do |line, y|
  line.chomp.each_char.each_with_index.filter_map do |char, x|
    Coord.new(x, y) unless char == '#'
  end
end)

# Turn the map into a graph
start = spaces.min_by(&:y)
target = spaces.max_by(&:y)

nodes = Set.new([start, target] + spaces.filter do |coord|
  HEADINGS.map {|h| coord + h}.count {|c| spaces.include?(c)} > 2
end)

graph = Hash.new {|h, k| h[k] = {}}

nodes.each do |node|
  queue = [[node]]
  until (cur = queue.shift).nil?
    neighbours = HEADINGS.filter_map do |heading|
      next_coord = cur[-1] + heading
      next if !spaces.include?(next_coord)
      next if cur.include?(next_coord)
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

# Find the longest path in the graph
def dfs(graph, start, target, visited = {})
  return visited.values.sum if start == target

  graph[start]
    .filter {|n, d| !visited.key?(n)}
    .filter_map {|n, d| dfs(graph, n, target, visited.merge(start => d))}
    .max
end

puts dfs(graph, start, target)