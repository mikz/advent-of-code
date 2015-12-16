# children: 3
# cats: 7
# samoyeds: 2
# pomeranians: 3
# akitas: 0
# vizslas: 0
# goldfish: 5
# trees: 3
# cars: 2
# perfumes: 1


class Aunt
  ATTRIBUTES = %I[children cats samoyeds pomeranians akitas vizslas goldfish trees cars perfumes]
  attr_reader *ATTRIBUTES

  ATTRIBUTE_COMPARISON = Hash.new(->(one,two) { one == two })
  ATTRIBUTE_COMPARISON[:cats] = ATTRIBUTE_COMPARISON[:trees] = ->(one,two) { one < two }
  ATTRIBUTE_COMPARISON[:pomeranians] = ATTRIBUTE_COMPARISON[:goldfish] = ->(one,two) { one > two }

  def initialize(name, **attributes)
    @name = name

    attributes.each do |attr, value|
      instance_variable_set("@#{attr}", value)
    end
  end

  def attributes
    ATTRIBUTES.map{ |attr| [ attr, public_send(attr) ] }.to_h
  end

  def match(other)
    existing_attributes = other.attributes.reject{ |k,v| !v }
    attrs = attributes

    existing_attributes.all? do |attr, value|
      attrs[attr] == value
    end
  end

  def real_match(other)
    existing_attributes = other.attributes.reject{ |k,v| !v }
    attrs = attributes

    existing_attributes.all? do |attr, value|
      comparison = ATTRIBUTE_COMPARISON[attr]

      comparison.call(attrs[attr], value)
    end
  end
end


aunts = ARGF.each_line.map do |line|
  # Sue 12: pomeranians: 4, akitas: 6, goldfish: 8

  name, properties = line.split(':', 2)

  attributes = properties.split(', ').map{ |prop| k, v = prop.split(': '); [k.strip.to_sym, v.to_i ] }.to_h

  Aunt.new(name, **attributes)
end

sue = Aunt.new('Sue',
               children: 3,
               cats: 7,
               samoyeds: 2,
               pomeranians: 3,
               akitas: 0,
               vizslas: 0,
               goldfish: 5,
               trees: 3,
               cars: 2,
               perfumes: 1)

# p aunts, sue


p sue

p aunts.find{ |aunt| sue.match(aunt) }


p aunts.find{ |aunt| sue.real_match(aunt) }
