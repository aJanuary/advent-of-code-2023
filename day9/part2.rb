#!/usr/bin/env ruby

def get_prev(seq)
  diffs = seq.each_cons(2).map { |a, b| b - a }
  if diffs.all?(0)
    seq[0]
  else
    res = seq[0] - get_prev(diffs)
    res
  end
end

prevs = $stdin.each_line.map do |line|
  get_prev(line.scan(/-?\d+/).map(&:to_i))
end

puts prevs.sum