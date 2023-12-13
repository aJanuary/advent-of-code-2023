#!/usr/bin/env ruby

NUM_REPEATS = 5

def count_permutations(map, counts, map_idx = 0, counts_idx = 0, memo={})
  memo_key = [map_idx, counts_idx]
  return memo[memo_key] if memo.key?(memo_key)

  map_idx = map.index(/[?#]/, map_idx)

  if map_idx.nil?
    # If we've reached the end of the map, we should have also reached the end of the counts
    return memo[memo_key] = counts_idx == counts.length ? 1 : 0
  end

  if counts_idx == counts.length
    # If we've reached the end of the counts, we should have also reached the end of the map
    return memo[memo_key] = map.index('#', map_idx).nil? ? 1 : 0
  end

  count_if_operational = 0
  if map[map_idx] == '?'
    # If we're at a ?, we can either replace it with a # or a .
    # Compute how many extra if it is operational, then add that to the total we calculate for a #
    count_if_operational = count_permutations(map, counts, map_idx + 1, counts_idx, memo)
  end

  if map.length - map_idx < counts[counts_idx]
    # If there aren't enough characters left in the map to satisfy the next count, this is a dead end
    return memo[memo_key] = count_if_operational
  end
  if [*map_idx...(map_idx + counts[counts_idx])].any? {|i| map[i] == '.'}
    # If there is a . in the range of the next count, the run is too short. This is a dead end.
    return memo[memo_key] = count_if_operational
  end
  if map[map_idx + counts[counts_idx]] == '#'
    # If there is a # immediately after the next count, it means the run is too long. This is a dead end.
    return memo[memo_key] = count_if_operational
  end

  # Move on to the next spring
  memo[memo_key] = count_permutations(map, counts, map_idx + counts[counts_idx] + 1, counts_idx + 1, memo) + count_if_operational
end

springs = $stdin.each_line.map do |line|
  map_src, counts_src = line.split(' ')
  map = ([map_src] * NUM_REPEATS).join('?')
  counts = counts_src.split(',').map(&:to_i)
  { map: map, counts: counts * NUM_REPEATS }
end

counts = springs.map {|spring| count_permutations(spring[:map], spring[:counts]) }
puts counts.sum