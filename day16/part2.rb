#!/usr/bin/env ruby

require 'set'

Coord = Struct.new(:x, :y) do
  def +(heading)
    Coord.new(x + heading.dx, y + heading.dy)
  end
end

Heading = Struct.new(:dx, :dy)

Beam = Struct.new(:coord, :heading)

map = $stdin.each_line.map(&:chomp).map(&:chars)

def count_energized(map, start_beam)
  visited = Set.new
  queue = [start_beam]


  until (beam = queue.shift).nil?
    coord = beam.coord + beam.heading
    next if coord.y < 0 || coord.y >= map.size || coord.x < 0 || coord.x >= map[coord.y].size
    case map[coord.y][coord.x]
    when '.'
      new_beam = Beam.new(coord, beam.heading)
      queue << new_beam if visited.add?(new_beam)
    when '\\'
      if beam.heading.dx == 1
        new_beam = Beam.new(coord, Heading.new(0, 1))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dx == -1
        new_beam = Beam.new(coord, Heading.new(0, -1))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dy == 1
        new_beam = Beam.new(coord, Heading.new(1, 0))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dy == -1
        new_beam = Beam.new(coord, Heading.new(-1, 0))
        queue << new_beam if visited.add?(new_beam)
      end
    when '/'
      if beam.heading.dx == 1
        new_beam = Beam.new(coord, Heading.new(0, -1))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dx == -1
        new_beam = Beam.new(coord, Heading.new(0, 1))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dy == 1
        new_beam = Beam.new(coord, Heading.new(-1, 0))
        queue << new_beam if visited.add?(new_beam)
      elsif beam.heading.dy == -1
        new_beam = Beam.new(coord, Heading.new(1, 0))
        queue << new_beam if visited.add?(new_beam)
      end
    when '|'
      if !beam.heading.dx.zero?
        new_beam = Beam.new(coord, Heading.new(0, 1))
        queue << new_beam if visited.add?(new_beam)
        new_beam = Beam.new(coord, Heading.new(0, -1))
        queue << new_beam if visited.add?(new_beam)
      else
        new_beam = Beam.new(coord, beam.heading)
        queue << new_beam if visited.add?(new_beam)
      end
    when '-'
      if !beam.heading.dy.zero?
        new_beam = Beam.new(coord, Heading.new(1, 0))
        queue << new_beam if visited.add?(new_beam)
        new_beam = Beam.new(coord, Heading.new(-1, 0))
        queue << new_beam if visited.add?(new_beam)
      else
        new_beam = Beam.new(coord, beam.heading)
        queue << new_beam if visited.add?(new_beam)
      end
    end
  end

  visited.map(&:coord).uniq.size
end

entry_points = (0...map.size).flat_map do |y|
  [
    Beam.new(Coord.new(-1, y), Heading.new(1, 0)),
    Beam.new(Coord.new(map[0].size, y), Heading.new(-1, 0))
  ]
end + (0...map[0].size).flat_map do |x|
  [
    Beam.new(Coord.new(x, -1), Heading.new(0, 1)),
    Beam.new(Coord.new(x, map.size), Heading.new(0, -1))
  ]
end

puts entry_points.map {|beam| count_energized(map, beam)}.max