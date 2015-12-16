class Rule
  attr_reader :person, :happiness, :other

  def initialize(person, happiness, other)
    @person = person
    @happiness = happiness
    @other = other
  end
end

rules = ARGF.each_line.map do |line|
  # Alice would gain 54 happiness units by sitting next to Bob.
  match = line.match(/^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)./)
  _, person, diff, happiness, other = match.to_a

  diff = (diff == 'gain') ? +1 : -1
  Rule.new(person, diff * happiness.to_i, other)
end


people = rules.map(&:person).uniq

class Arrangement
  def initialize(order)
    @order = order
  end

  def siblings(person)
    i = @order.index(person)

    left = @order[i - 1]
    right = @order[i + 1] || @order[0]
    [left, right]
  end

  def happiness(rules)
    @order.flat_map do |person|
      r = rules.select { |rule| rule.person == person && siblings(person).include?(rule.other) }
      r.map(&:happiness)
    end.reduce(:+)
  end
end


p people
p rules


happiness = people.permutation.map do |order|
  Arrangement.new(order).happiness(rules)
end


p happiness.max


yourself = people.flat_map do |person|
  [ Rule.new('You', 0, person), Rule.new(person, 0, 'You') ]
end

rules.concat(yourself)

people << 'You'

happiness = people.permutation.map do |order|
  Arrangement.new(order).happiness(rules)
end

p happiness.max
