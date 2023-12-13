#!/usr/bin/env ruby

def get_reflection_point(map)
  (1...map.length).find do |p|
    max_offset = [p, map.length - p].min
    (0...max_offset).all? do |offset|
      map[p - offset - 1] == map[p + offset]
    end
  end
end

maps = $stdin.read.split("\n\n").map do |map_src|
  map_src.split("\n").map(&:chars)
end

summaries = maps.map do |map|
  get_reflection_point(map.transpose) || (100 * get_reflection_point(map))
end

puts summaries.sum