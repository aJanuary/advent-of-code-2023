#!/usr/bin/env ruby

require 'set'

cards = $stdin.each_line.map do |line|
  index, expected, actual = line.split(/[:|]/)
  Set.new(expected.scan(/\d+/)).intersection(Set.new(actual.scan(/\d+/))).length
end

num_processed = 0
queue = (0...cards.length).to_a

until queue.empty?
  idx = queue.shift
  matches = cards[idx]
  (idx + 1..idx + matches).each {|i| queue << i}
  num_processed += 1

end

puts num_processed