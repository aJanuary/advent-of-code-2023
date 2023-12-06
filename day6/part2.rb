#!/usr/bin/env ruby

lines = $stdin.each_line.to_a
time = lines[0].scan(/\d/).join('').to_i
distance = lines[1].scan(/\d/).join('').to_i

range_start = (0.5 * (time - Math.sqrt(time ** 2 - (4 * (distance + 1))))).ceil
range_end = (0.5 * (time + Math.sqrt(time ** 2 - (4 * (distance + 1))))).floor
puts range_end - range_start + 1