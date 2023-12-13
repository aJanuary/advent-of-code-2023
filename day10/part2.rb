#!/usr/bin/env ruby

require 'set'

class Coord
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other)
    Coord.new(@x + other.x, @y + other.y)
  end

  def -@
    Coord.new(-@x, -@y)
  end

  def inspect
    "(#{@x}, #{@y})"
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def hash
    [@x, @y].hash
  end

  alias eql? ==
  alias to_s inspect
end

def get_path(map, start, heading)
  path = []
  cur = start
  loop do
    path << { coord: cur, heading: heading }
    cur = cur + heading
    return nil if map[cur].nil?
    if cur == start
      return path
    end
    headings = map[cur].select {|h| h != -heading}
    return nil unless headings.size == 1
    heading = headings[0]
  end
end

def flood_fill(map, loop_path, starts)
  to_visit = starts.to_a
  visited = Set.new(loop_path.map {|n| n[:coord]})
  filled = Set.new
  loop do
    cur = to_visit.shift
    return filled if cur.nil?
    visited << cur
    filled << cur
    to_visit += [NORTH, EAST, SOUTH, WEST].map {|h| cur + h}.select {|c| !map[c].nil? && !visited.include?(c)}
  end
end

NORTH = Coord.new(0, -1)
SOUTH = Coord.new(0, 1)
EAST = Coord.new(1, 0)
WEST = Coord.new(-1, 0)

map = {}
start = nil

$stdin.each_line.each_with_index.map do |line, y|
  line.chomp.chars.each_with_index.map do |char, x|
    map[Coord.new(x, y)] = {
      '|' => Set[NORTH, SOUTH],
      '-' => Set[EAST, WEST],
      'L' => Set[NORTH, EAST],
      'J' => Set[NORTH, WEST],
      '7' => Set[SOUTH, WEST],
      'F' => Set[EAST, SOUTH],
      '.' => Set[],
      'S' => Set[NORTH, EAST, SOUTH, WEST]
    }[char]
    if char == 'S'
      start = Coord.new(x, y)
    end
  end
end

loop_path = [NORTH, EAST, SOUTH, WEST].lazy.map do |heading|
  get_path(map, start, heading)
end.select {|path| !path.nil?}.first

# We know that the top left must be a corner, and to the right and down from it must be inside the loop.
min_y = loop_path.map {|n| n[:coord].y}.min
top_left = loop_path.select {|n| n[:coord].y == min_y}.min_by {|n| n[:coord].x}
top_left_idx = loop_path.index(top_left)

# We may have found the loop going clockwise or anticlockwise. Figure out which direction we are going in, and which direction the inside edge is.
# edge_offset represents the offset from the current cell to the inside edge.
if loop_path[top_left_idx][:heading] == EAST
  edge_offset = {
    NORTH => EAST,
    EAST => SOUTH,
    SOUTH => WEST,
    WEST => NORTH
  }
else
  edge_offset = {
    NORTH => WEST,
    EAST => NORTH,
    SOUTH => EAST,
    WEST => SOUTH
  }
end

inside_edge = Set.new

(0...loop_path.size).each do |i|
  cur_idx = (top_left_idx + i) % loop_path.size
  # Look up the inside edge for the direction we entered and exited the cell
  inside_edge += [edge_offset[loop_path[cur_idx][:heading]], edge_offset[loop_path[(cur_idx - 1) % loop_path.size][:heading]]].map {|o| loop_path[cur_idx][:coord] + o}
end

inside_edge -= Set.new(loop_path.map {|n| n[:coord]})
inside_loop = flood_fill(map, loop_path, inside_edge)

puts inside_loop.size
