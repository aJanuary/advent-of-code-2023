#!/usr/bin/env ruby

rules_src = $stdin.read.split("\n\n")[0]

rules = Hash[rules_src.split("\n").map do |rule_src|
  name, conditions_src = rule_src.scan(/([^{]+)\{([^}]+)\}/)[0]
  conditions = conditions_src.split(',').map do |condition_src|
    if condition_src.include?(':')
      attribute, op, value, target = condition_src.scan(/([xmas])(.)(\d+):(.+)/)[0]
      { type: :condition, attribute: attribute.to_sym, op: op.to_sym, value: value.to_i, target: target }
    else
      { op: :fallback, target: condition_src }
    end
  end
  [name, conditions]
end]

queue = [{ ranges: { x: (1..4000), m: (1..4000), a: (1..4000), s: (1..4000) }, cur_rule: 'in', cond_index: 0 }]
final_states = []

until (state = queue.shift).nil?
  cur_rule = state[:cur_rule]

  if ['A', 'R'].include?(cur_rule)  
    final_states << state
  else
    ranges = state[:ranges]
    cond_index = state[:cond_index]
    condition = rules[cur_rule][cond_index]

    case condition[:op]
    when :<
      if_lt = (ranges[condition[:attribute]].begin..(condition[:value] - 1))
      if if_lt.size > 0
        queue << { ranges: ranges.merge(condition[:attribute] => if_lt), cur_rule: condition[:target], cond_index: 0 }
      end

      if_gt_or_eql = (condition[:value]..ranges[condition[:attribute]].end)
      if if_gt_or_eql.size > 0
        queue << { ranges: ranges.merge(condition[:attribute] => if_gt_or_eql), cur_rule: cur_rule, cond_index: cond_index + 1 }
      end
    when :>
      new_ranges = ranges.dup
      if_gt = ((condition[:value] + 1)..ranges[condition[:attribute]].end)
      if if_gt.size > 0
        queue << { ranges: ranges.merge(condition[:attribute] => if_gt), cur_rule: condition[:target], cond_index: 0 }
      end

      if_lt_or_eql = (ranges[condition[:attribute]].begin..condition[:value])
      if if_lt_or_eql.size > 0
        queue << { ranges: ranges.merge(condition[:attribute] => if_lt_or_eql), cur_rule: cur_rule, cond_index: cond_index + 1 }
      end
    when :fallback
      queue << { ranges: ranges, cur_rule: condition[:target], cond_index: 0 }
    end
  end
end

accepted_states = final_states.select {|state| state[:cur_rule] == 'A'}
puts accepted_states.map {|state| state[:ranges].values.map(&:size).inject(&:*) }.sum