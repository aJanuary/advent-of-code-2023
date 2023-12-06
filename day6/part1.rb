#!/usr/bin/env ruby

Race = Struct.new(:time, :distance)

numbers = $stdin.each_line.map {|l| l.scan(/\d+/).map(&:to_i)}
races = numbers[0].zip(numbers[1]).map {|time, distance| Race.new(time, distance)}

ways_to_win = races.map do |race|
  (0..race.time).map do |time_charging|
    time_left_after_charging = race.time - time_charging
    distance_travelled = time_left_after_charging * time_charging
    distance_travelled > race.distance
  end.count(true)
end

puts ways_to_win.inject(&:*)