#!/usr/bin/env ruby

rules_src, parts_src = $stdin.read.split("\n\n")

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

parts = parts_src.split("\n").map do |part_src|
  x, m, a, s = part_src.scan(/\d+/).map(&:to_i)
  { x: x, m: m, a: a, s: s }
end

accepted = parts.select do |part|
  cur_rule = 'in'
  until ['A', 'R'].include?(cur_rule)
    conditions = rules[cur_rule]
    cur_rule = conditions.find do |condition|
      case condition[:op]
      when :<
        part[condition[:attribute]] < condition[:value]
      when :>
        part[condition[:attribute]] > condition[:value]
      when :fallback
        true
      end
    end[:target]
  end
  cur_rule == 'A'
end

puts accepted.map {|part| part.values.sum }.sum