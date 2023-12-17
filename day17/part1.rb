#!/usr/bin/env ruby
require 'set'

Coord = Struct.new(:x, :y) do
  def inspect
    "(#{x},#{y})"
  end

  alias_method :to_s, :inspect
end

Heading = Struct.new(:dx, :dy) do
  def inspect
    {
      NORTH => 'N',
      EAST => 'E',
      SOUTH => 'S',
      WEST => 'W'
    }[self]
  end

  alias_method :to_s, :inspect
end

P = Struct.new(:coord, :heading) do
  def inspect
    "[#{coord} #{heading}]"
  end

  alias_method :to_s, :inspect
end

NORTH = Heading.new(0, -1)
EAST = Heading.new(1, 0)
SOUTH = Heading.new(0, 1)
WEST = Heading.new(-1, 0)

map = $stdin.each_line.map(&:chomp).map {|l| l.chars.map(&:to_i)}
graph = Hash.new {|h, k| h[k] = {}}

(0...map.length).each do |y|
  (0...map[y].length).each do |x|
    start = Coord.new(x, y)

    (1..3).each do |offset|
      new_coord = Coord.new(x, y - offset)
      if new_coord.y >= 0
        distance = (1..offset).map {|i| map[y - i][x]}.reduce(:+)
        [EAST, WEST].each do |heading|
          graph[P.new(start, NORTH)][P.new(new_coord, heading)] = distance
        end
      end

      new_coord = Coord.new(x, y + offset)
      if new_coord.y < map.length
        distance = (1..offset).map {|i| map[y + i][x]}.reduce(:+)
        [EAST, WEST].each do |heading|
          graph[P.new(start, SOUTH)][P.new(new_coord, heading)] = distance
        end
      end

      new_coord = Coord.new(x - offset, y)
      if new_coord.x >= 0
        distance = (1..offset).map {|i| map[y][x - i]}.reduce(:+)
        [NORTH, SOUTH].each do |heading|
          graph[P.new(start, WEST)][P.new(new_coord, heading)] = distance
        end
      end

      new_coord = Coord.new(x + offset, y)
      if new_coord.x < map[y].length
        distance = (1..offset).map {|i| map[y][x + i]}.reduce(:+)
        [NORTH, SOUTH].each do |heading|
          graph[P.new(start, EAST)][P.new(new_coord, heading)] = distance
        end
      end
    end
  end
end

starts = [
  P.new(Coord.new(0, 0), EAST),
  P.new(Coord.new(0, 0), SOUTH)
]
goal = Coord.new(map[0].length - 1, map.length - 1)
shortest_distances = Hash.new(Float::INFINITY)
starts.each {|s| shortest_distances[s] = 0}

queue = Set.new(starts)

until queue.empty?
  current = queue.min_by {|p| shortest_distances[p]}
  queue.delete(current)

  break if current.coord == goal

  graph[current].each do |neighbor, distance|
    alt = shortest_distances[current] + distance
    if alt < shortest_distances[neighbor]
      shortest_distances[neighbor] = alt
      queue.add(neighbor)
    end
  end
end

puts shortest_distances[current]