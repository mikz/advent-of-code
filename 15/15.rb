class Ingredient
  attr_reader :capacity, :durability, :flavor, :texture, :calories

  def initialize(name, capacity:, durability:, flavor:, texture:, calories: )
    @name = name
    @capacity = capacity
    @durability = durability
    @flavor = flavor
    @texture = texture
    @calories = calories
  end

  def mixture
    [ capacity, durability, flavor, texture ]
  end

  def *(amount)
    mixture.map{|m| m * amount}
  end

  def avg
    mixture.reduce(:+).to_f / mixture.size
  end
end


class Mixer
  def initialize(size)
    @size = size
    @range = (0..size).to_a
  end

  def each(groups)

    return to_enum(__method__, groups) unless block_given?

    @range.repeated_permutation(groups) do |combination|
      yield combination if combination.reduce(:+) == @size
    end
  end
end

ingredients = ARGF.each_line.map do |line|
  name, properties = line.split(':')
  properties = properties.split(', ').map{ |pair| k, v = pair.split(' '); [k.to_sym, v.to_i] }.to_h
  Ingredient.new(name, **properties)
end


class Cookie
  attr_reader :mixture
  def initialize(mixture)
    @mixture = mixture.select{ |_,v| v > 0 }
  end

  def rank
    @mixture.map do |ingredient, amount|
      ingredient * amount
    end.transpose.map do |properties|
      (val = properties.reduce(:+)) > 0 ? val : 0
    end.reduce(:*)
  end

  def calories
    @mixture.map do |ingredient, amount|
      ingredient.calories * amount
    end.reduce(:+)
  end
end

mixer = Mixer.new(100).each(ingredients.size).lazy.map do |combination|
  mix = ingredients.map.with_index do |ingredient, index|
    [ ingredient, combination[index] ]
  end.to_h

  Cookie.new(mix)
end

cookie = mixer.select{ |cookie| cookie.rank > 0 && cookie.calories == 500 }.sort_by(&:rank).last

p cookie.mixture
puts cookie.rank
