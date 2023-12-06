#!/usr/bin/env ruby

lines = $stdin.each_line.to_a
time = lines[0].scan(/\d/).join('').to_i
distance = lines[1].scan(/\d/).join('').to_i

ways_to_win = (0..time).map do |time_charging|
  time_left_after_charging = time - time_charging
  distance_travelled = time_left_after_charging * time_charging
  distance_travelled > distance
end.count(true)

puts ways_to_win
