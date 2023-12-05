#!/usr/bin/env ruby

lines = $stdin.read.split("\n\n")

seeds = lines[0].scan(/\d+/).map(&:to_i)

mappings = lines[1..-1].map do |mapping_src|
  mapping_lines = mapping_src.split("\n")
  mapping_lines[1..-1].map do |mapping_line|
    dest_start, source_start, length = mapping_line.scan(/\d+/).map(&:to_i)
    { source: source_start...(source_start + length), dest: dest_start...(dest_start + length) }
  end
end

locs = seeds.map do |seed|
  mappings.reduce(seed) do |cur, mapping|
    m = mapping.find {|m| m[:source].include?(cur) }
    if m.nil?
      cur
    else
      m[:dest].begin + (cur - m[:source].begin)
    end
  end
end

puts locs.min