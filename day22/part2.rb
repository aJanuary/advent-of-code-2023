#!/usr/bin/env ruby

Coord = Struct.new(:x, :y, :z) do
  def inspect
    "(#{x}, #{y}, #{z})"
  end
  alias_method :to_s, :inspect
end

Block = Struct.new(:id, :a, :b) do
  def inspect
    "#{id} :: #{a}~#{b}"
  end
  alias_method :to_s, :inspect

  def bottom
    [a.z, b.z].min
  end

  def top
    [a.z, b.z].max
  end

  def overlaps?(other)
    [a.x, other.a.x].max <= [b.x, other.b.x].min &&
      [a.y, other.a.y].max <= [b.y, other.b.y].min
  end
end

def count_drops(supported_by, id)
  supported_by.map do |k, v|
    if v.delete(id) && v.empty?
      1 + count_drops(supported_by, k)
    else
      0
    end
  end.sum
end

blocks = $stdin.each_line.each_with_index.map do |line, idx|
  Block.new(*[idx] + line.split('~').map {|coord_src| Coord.new(*coord_src.split(',').map(&:to_i))})
end.sort_by {|block| block.bottom}

(0...blocks.size).each do |block_idx|
  block = blocks[block_idx]
  if block.bottom > 1
    new_bottom = (blocks[0...block_idx].filter {|other| block.overlaps?(other)}.map(&:top).max || 0) + 1
    blocks[block_idx] = Block.new(block.id, Coord.new(block.a.x, block.a.y, new_bottom), Coord.new(block.b.x, block.b.y, new_bottom + (block.top - block.bottom)))
  end
end

supported_by = Hash[blocks.each_with_index.map do |block, block_idx|
  supported_by = blocks[0...block_idx].filter {|other| block.bottom == other.top + 1 && block.overlaps?(other)}.map(&:id)
  [block.id, supported_by]
end]

num_drops = blocks.map do |block|
  count_drops(Hash[supported_by.map {|k, v| [k, v.dup]}], block.id)
end

puts num_drops.sum