#!/usr/bin/env ruby

init_sequences = $stdin.read.chomp.split(',')
hashes = init_sequences.map do |init_sequence|
  init_sequence.chars.reduce(0) do |hash, char|
    ((hash + char.ord) * 17) % 256
  end
end

puts hashes.sum