#!/usr/bin/env ruby

def compose_mapping(a, b)
  a = a.sort_by {|m| m[:dest].begin }
  b = b.sort_by {|m| m[:source].begin }

  # The "common" timeline is the image of a and the domain of b.

  a_idx = 0
  b_idx = 0
  cur_on_common = a[0][:dest].begin
  while b_idx < b.length && b[b_idx][:source].end <= cur_on_common
    b_idx += 1
  end

  result = []

  while a_idx < a.length and b_idx < b.length
    a_mapping = a[a_idx]
    b_mapping = b[b_idx]

    # Find what the next point on the common timeline is, and divide the ranges at that point.
    if a_mapping[:dest].end <= b_mapping[:source].end
      common = cur_on_common...a_mapping[:dest].end
      a_idx += 1
    else
      common = cur_on_common...b_mapping[:source].end
      b_idx += 1
    end
    if common.begin < common.end
      result << {
        source: (common.begin - a_mapping[:dest].begin + a_mapping[:source].begin)...(common.end - a_mapping[:dest].begin + a_mapping[:source].begin),
        dest: (common.begin - b_mapping[:source].begin + b_mapping[:dest].begin)...(common.end - b_mapping[:source].begin + b_mapping[:dest].begin)
      }
    end
    if a_idx > 0 && a_idx < a.length && a[a_idx - 1][:dest].end != a[a_idx][:dest].begin && a[a_idx][:dest].begin > common.end
      # If there is a gap between the previous and current mapping for a, then we need to skip ahead to the next mapping.
      # We assume that b won't have any gaps, so we don't need to check for that.
      cur_on_common = a[a_idx][:dest].begin
    else
      cur_on_common = common.end
    end
  end

  result
end

lines = $stdin.read.split("\n\n")

seeds = lines[0].scan(/\d+/).map(&:to_i).each_slice(2).map {|a, b| a...(a+b)}.map {|r| { source: r, dest: r }}

mappings = lines[1..-1].map do |mapping_src|
  mapping_lines = mapping_src.split("\n")
  mapping = mapping_lines[1..-1].map do |mapping_line|
    dest_start, source_start, length = mapping_line.scan(/\d+/).map(&:to_i)
    { source: source_start...(source_start + length), dest: dest_start...(dest_start + length) }
  end
  prev_end = 0
  # Fill in gaps with identity mappings
  mapping.sort_by {|m| m[:source].begin }.each do |m|
    if m[:source].begin > prev_end
      mapping << { source: prev_end...m[:source].begin, dest: prev_end...m[:source].begin }
    end
    prev_end = m[:source].end
  end
  mapping << { source: prev_end...Float::INFINITY, dest: prev_end...Float::INFINITY }
end

reduced_mapping = ([seeds] + mappings).reduce(&method(:compose_mapping))
puts reduced_mapping.inspect
puts reduced_mapping.map {|m| m[:dest].begin}.min