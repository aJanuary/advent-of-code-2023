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

game_powers = games.map do |game|
  [:red, :green, :blue]
    .map {|color| game[:sets].map {|set| set[color] || 0}.max}
    .reduce(:*)
end

puts game_powers.sum