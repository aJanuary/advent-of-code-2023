#!/usr/bin/env ruby

require 'set'

cards = $stdin.each_line.map do |line|
  index, expected, actual = line.split(/[:|]/)
  {
    expected: Set.new(expected.scan(/\d+/).map(&:to_i)),
    actual: Set.new(actual.scan(/\d+/).map(&:to_i))
  }
end

scores = cards.map do |card|
  matches = card[:actual].intersection(card[:expected]).length
  matches == 0 ? 0 : 2 ** (matches - 1)
end

puts scores.inspect
puts scores.sum