#!/usr/bin/env ruby

require 'stringio'
require 'parsby'

include Parsby::Combinators

pull = group(
  decimal < lit(' '), lit('red') | lit('green') | lit('blue')
).fmap do |count, color|
  [color.to_sym, count]
end

set = sep_by(lit(', '), pull).fmap do |sets|
  Hash[sets]
end

parser = group(
  lit 'Game ' > decimal < lit ': ',
  sep_by(lit('; '), set)
).fmap do |id, sets|
  {
    id: id,
    sets: sets
  }
end

games = $stdin.each_line.map {|line| parser.parse(line)}
puts games.inspect
