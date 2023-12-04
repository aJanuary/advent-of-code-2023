#!/usr/bin/env ruby

PartNo = Struct.new(:x_start, :x_end, :y, :value)

numbers = []
gears = []

$stdin.each_line.each_with_index do |line, y|
  line.chomp.scan(/((\d+)|(\*))/) do |match|
    x = $~.offset(0)[0]
    if match[1].nil?
      gears << [x, y]
    else
      numbers << PartNo.new(x, x + match[1].length - 1, y, match[1].to_i)
    end
  end
end

ratios = gears.flat_map do |gear_x, gear_y|
  adj_nums = numbers.select do |number|
    (gear_x >= number.x_start - 1 && gear_x <= number.x_end + 1 && (gear_y == number.y - 1 || gear_y == number.y + 1)) ||
      (gear_y == number.y && (gear_x == number.x_start - 1 || gear_x == number.x_end + 1))
  end
  if adj_nums.length == 2
    [adj_nums.map(&:value).inject(&:*)]
  else
    []
  end
end

puts ratios.sum