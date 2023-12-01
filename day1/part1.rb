#!/usr/bin/env ruby

calibration_values = $stdin.each_line.map do |line|
  digits = line.scan(/\d/)
  "#{digits.first}#{digits.last}".to_i
end
puts calibration_values.sum