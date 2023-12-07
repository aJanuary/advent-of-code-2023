#!/usr/bin/env ruby

Hand = Struct.new(:kind, :cards)
CARD_SORT = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A']
HAND_KIND_SORT = [:high_card, :one_pair, :two_pairs, :three_of_a_kind, :full_house, :four_of_a_kind, :five_of_a_kind]

def compare_hands(a, b)
  by_kind = HAND_KIND_SORT.index(a.kind) <=> HAND_KIND_SORT.index(b.kind)
  if by_kind == 0
    a.cards.map {|c| CARD_SORT.index(c)} <=> b.cards.map {|c| CARD_SORT.index(c)}
  else
    by_kind
  end
end

def parse_hand(hand)
  cards = hand.chars
  by_card = cards.group_by {|i| i}
  if by_card.size == 1
    Hand.new(:five_of_a_kind, cards)
  elsif by_card.size == 2
    if by_card.values.any? {|x| x.size == 4}
      Hand.new(:four_of_a_kind, cards)
    else
      Hand.new(:full_house, cards)
    end
  elsif by_card.size == 3
    if by_card.values.any? {|x| x.size == 3}
      Hand.new(:three_of_a_kind, cards)
    else
      Hand.new(:two_pairs, cards)
    end
  elsif by_card.size == 4
    Hand.new(:one_pair, cards)
  else
    Hand.new(:high_card, cards)
  end
end

plays = $stdin.each_line.map do |line|
  hand_src, bid_src = line.split(' ')
  { hand: parse_hand(hand_src), bid: bid_src.to_i }
end

sorted_plays = plays.sort do |play_a, play_b|
  compare_hands(play_a[:hand], play_b[:hand])
end

scores = sorted_plays.zip(1..sorted_plays.length).map do |play, rank|
  play[:bid] * rank
end

puts scores.sum