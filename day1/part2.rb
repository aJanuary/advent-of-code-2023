#!/usr/bin/env ruby

digit_words = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
  "1" => 1,
  "2" => 2,
  "3" => 3,
  "4" => 4,
  "5" => 5,
  "6" => 6,
  "7" => 7,
  "8" => 8,
  "9" => 9
}

calibration_values = $stdin.each_line.map do |line|
  first = digit_words[digit_words.keys.min_by {|k| line.index(k) || Float::INFINITY}]
  last = digit_words[digit_words.keys.max_by {|k| line.rindex(k) || -Float::INFINITY}]
  (first * 10) + last
end
puts calibration_values.sum