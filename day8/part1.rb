#!/usr/bin/env ruby

directions_src, nodes_src = $stdin.read.split("\n\n")
directions = directions_src.chars.map {|c| { 'L' => 0, 'R' => 1}[c]}

nodes = Hash[nodes_src.split("\n").map do |node_src|
  node, left, right = node_src.scan(/(...) = \((...), (...)\)/)[0]
  [node, [left, right]]
end]

steps = 0
cur = 'AAA'
until cur == 'ZZZ'
  cur = nodes[cur][directions[steps % directions.size]]
  steps += 1
end

puts steps