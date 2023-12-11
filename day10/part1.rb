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

  def to_s
    "(#{@x}, #{@y})"
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def hash
    [@x, @y].hash
  end

  alias eql? ==
end

def opposite(heading)
  {
    :north => :south,
    :south => :north,
    :east => :west,
    :west => :east
  }[heading]
end

def get_path_length(map, start, cur, heading)
  length = 0
  loop do
    cur = cur + heading
    return nil if map[cur].nil?
    heading = map[cur].find {|h| h != -heading}
    return nil if heading.nil?
    if cur == start
      return length
    end
    length += 1
  end
  length
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

length = [NORTH, EAST, SOUTH, WEST].map do |heading|
  get_path_length(map, start, start, heading)
end.compact[0]

puts (length + 1) / 2