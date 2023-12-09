#!/usr/bin/env ruby

def get_next(seq)
  diffs = seq.each_cons(2).map { |a, b| b - a }
  if diffs.all?(0)
    seq[-1]
  else
    res = seq[-1] + get_next(diffs)
    res
  end
end

nexts = $stdin.each_line.map do |line|
  get_next(line.scan(/-?\d+/).map(&:to_i))
end

puts nexts.sum