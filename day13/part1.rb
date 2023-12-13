#!/usr/bin/env ruby

def get_reflection_point(map)
  (0...map.length - 1).each do |p|
    max_offset = [p, map.length - p - 2].min
    return (p + 1) if (0..max_offset).all? do |offset|
      map[p - offset] == map[p + offset + 1]
    end
  end
  nil
end

maps = $stdin.read.split("\n\n").map do |map_src|
  rows = map_src.split("\n")
  cols = rows.map {|row| row.split('')}.transpose.map {|col| col.join('')}
  { rows: rows, cols: cols }
end

summaries = maps.map do |map|
  get_reflection_point(map[:cols]) || (100 * get_reflection_point(map[:rows]))
end

puts summaries.sum