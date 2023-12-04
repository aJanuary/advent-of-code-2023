#!/usr/bin/env ruby

PartNo = Struct.new(:x_start, :x_end, :y, :value)

numbers = []
symbols = Hash.new {|h, k| h[k] = {}}

$stdin.each_line.each_with_index do |line, y|
  line.chomp.scan(/((\d+)|([^\.]))/) do |match|
    x = $~.offset(0)[0]
    if match[1].nil?
      symbols[x][y] = match[2]
    else
      numbers << PartNo.new(x, x + match[1].length - 1, y, match[1].to_i)
    end
  end
end

included_numbers = numbers.filter do |number|
  ((number.x_start - 1)..(number.x_end + 1)).any? {|x| symbols[x][number.y - 1] || symbols[x][number.y + 1]} ||
    symbols[number.x_start - 1][number.y] || symbols[number.x_end + 1][number.y]
end

puts included_numbers.map(&:value).sum