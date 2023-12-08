#!/usr/bin/env ruby

require 'set'

directions_src, nodes_src = $stdin.read.split("\n\n")
directions = directions_src.chars.map {|c| { 'L' => 0, 'R' => 1}[c]}

nodes = Hash[nodes_src.split("\n").map do |node_src|
  node, left, right = node_src.scan(/(...) = \((...), (...)\)/)[0]
  [node, [left, right]]
end]

start = nodes.keys.select {|n| n[-1] == 'A'}

z_indices = start.map do |cur|
  steps = 0
  until cur[-1] == 'Z'
    cur = nodes[cur][directions[steps % directions.size]]
    steps += 1
  end
  steps
end

puts z_indices.inject(1, :lcm)