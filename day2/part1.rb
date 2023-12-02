#!/usr/bin/env ruby

games = $stdin.each_line.map do |line|
  id_part, *matches = line.split(/[:;]/)
  id = id_part.scan(/\d+/).first.to_i
  sets = matches.map do |match|
    Hash[match.scan(/(\d+) (red|blue|green|)/).map do |set|
      [set[1].to_sym, set[0].to_i]
    end]
  end
  {
    id: id,
    sets: sets
  }
end

max = {
  red: 12,
  green: 13,
  blue: 14
}

valid_games = games.filter do |game|
  game[:sets].all? do |set|
    (set[:red] || 0) <= max[:red] &&
    (set[:green] || 0) <= max[:green] &&
    (set[:blue] || 0) <= max[:blue]
  end
end

puts valid_games.map {|game| game[:id]}.sum