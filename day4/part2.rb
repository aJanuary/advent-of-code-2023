#!/usr/bin/env ruby

require 'set'

total = 0
extra_copies = Hash.new {|h, k| h[k] = 0}
# Keeps track of the sum of values in extra_copies for all keys > index
extra_copies_sum = 0

$stdin.each_line.each_with_index do |line, index|
  _, expected, actual = line.split(/[:|]/)
  matches = Set.new(expected.scan(/\d+/)).intersection(Set.new(actual.scan(/\d+/))).length
  num_cards = 1 + extra_copies_sum
  total += num_cards
  extra_copies[index + matches] += num_cards
  extra_copies_sum += num_cards - (extra_copies[index] || 0)
end

puts total
