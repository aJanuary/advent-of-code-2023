#!/usr/bin/env ruby

def hash(v)
  v.chars.reduce(0) do |hash, char|
    ((hash + char.ord) * 17) % 256
  end
end

init_sequences = $stdin.read.chomp.split(',').map do |src|
  if src.end_with?('-')
    {
      label: src[0..-2],
      type: :remove
    }
  else
    label, focal_length = src.split('=')
    {
      label: label,
      type: :add,
      focal_length: focal_length.to_i
    }
  end
end

boxes = 256.times.map { [] }

init_sequences.each do |init_sequence|
  box = boxes[hash(init_sequence[:label])]
  if init_sequence[:type] == :add
    idx = box.index {|box| box[:label] == init_sequence[:label]}
    if idx.nil?
      box.push({ focal_length: init_sequence[:focal_length], label: init_sequence[:label] })
    else
      box[idx][:focal_length] = init_sequence[:focal_length]
    end
  else
    box.delete_if {|box| box[:label] == init_sequence[:label]}
  end
end

focussing_powers = boxes.each_with_index.flat_map do |box,  box_idx|
  box.each_with_index.map do |lense, lense_idx|
    (1 + box_idx) * (1 + lense_idx) * lense[:focal_length]
  end
end

puts focussing_powers.sum