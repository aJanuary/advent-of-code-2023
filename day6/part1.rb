#!/usr/bin/env ruby

Race = Struct.new(:time, :distance)

numbers = $stdin.each_line.map {|l| l.scan(/\d+/).map(&:to_i)}
races = numbers[0].zip(numbers[1]).map {|time, distance| Race.new(time, distance)}

ways_to_win = races.map do |race|
  range_start = (0.5 * (race.time - Math.sqrt(race.time ** 2 - (4 * (race.distance + 1))))).ceil
  range_end = (0.5 * (race.time + Math.sqrt(race.time ** 2 - (4 * (race.distance + 1))))).floor
  range_end - range_start + 1
end

puts ways_to_win.inject(&:*)