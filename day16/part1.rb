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

visited = Set.new
queue = [
  Beam.new(Coord.new(-1, 0), Heading.new(1, 0)),
]


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

puts visited.map(&:coord).uniq.size