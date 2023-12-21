#!/usr/bin/env ruby

class BroadcastModule
  attr_reader :targets

  def initialize(targets)
    @targets = targets
  end

  def process(input, signal)
    @targets.map {|t| { name: t, value: signal }}
  end
end

class FlipFlopModule
  attr_reader :targets

  def initialize(targets)
    @targets = targets
    @state = false
  end

  def process(input, signal)
    return [] if signal
    @state = !@state
    @targets.map {|t| { name: t, value: @state }}
  end
end

class ConjunctionModule
  attr_reader :targets

  def initialize(targets)
    @targets = targets
  end

  def inputs=(inputs)
    @states = Hash[inputs.map {|i| [i, false] }]
  end

  def process(input, signal)
    @states[input] = signal
    @targets.map {|t| { name: t, value: !@states.values.all?(true) }}
  end
end

modules = Hash[$stdin.each_line.map do |line|
  type_sym, name, targets = line.scan(/([%&]?)([^ ]+) -> (.*)/)[0]
  type = {
    '' => BroadcastModule,
    '%' => FlipFlopModule,
    '&' => ConjunctionModule,
  }[type_sym]
  [name, type.new(targets.split(", "))]
end]

modules.select {|k, v| v.is_a?(ConjunctionModule)}.each do |name, conj_module|
  conj_module.inputs = modules.select {|k, v| v.targets.include?(name)}.keys
end

counts = Hash.new(0)
1000.times do
  queue = [{ input: 'button', name: 'broadcaster', value: false}]
  until (cur = queue.shift).nil?
    counts[cur[:value]] += 1
    cur_module = modules[cur[:name]]
    unless cur_module.nil?
      cur_module.process(cur[:input], cur[:value]).each do |output|
        queue.push(output.merge({ input: cur[:name] }))
      end
    end
  end
end

puts counts.values.inject(:*)