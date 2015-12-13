wires = Hash.new

class Wire
  def initialize(name, wires)
    @name = name
    @wire = -> { wires[name] }
    @store = ->(value) { wires[name] = Value(value) }
  end

  def value
    ret = @wire.call.value
    @store.call(ret)
    ret
  end

  def call(other)
    other.call(Value(value))
  end

  def to_s
    @name
  end

  def tree
    [ self, value ]
  end
end

def Value(obj)
  obj.is_a?(Value) ? obj : Value.new(obj.respond_to?(:value) ? Value(obj.value) : obj)
end

class Op
  def initialize
    @args = []
  end

  def call(other)
    raise "#{self} call #{other}"
    #p "#{self} : #{other}"
    other
  end
end

class And < Op
  def call(other)
    -> (arg) { Value(other.value & Value(arg).value) }
  end

  def to_s
    'AND'
  end
end

class Not < Op

  def call(other)
    Value(~Value(other).value)
  end

  def to_s
    'NOT'
  end

end

class Rshift < Op
  def call(other)
    ->(arg) { Value(other.value >> Value(arg).value) }
  end

  def to_s
    'RSHIFT'
  end
end

class Lshift < Rshift
  def initialize(*args)
    @args = args
  end

  def to_s
    'LSHIFT'
  end

  def call(other)
    ->(arg) { Value(other.value << Value(arg).value) }
  end
end

class Or < Op
  def call(other)
    -> (arg) { Value(other.value | Value(arg).value) }
  end

  def to_s
    'OR'
  end
end

class Value
  def initialize(number)
    @number = number
  end

  def value
    number = @number

    while number.respond_to?(:value)
      number = number.value
    end
    number
  end

  def call(op)
    op.call(self)
  end

  def to_i
    @number
  end

  def to_s
    @number.to_s
  end
end


class Source
  attr_reader :name

  def initialize(name, sources, wires)
    @name = name
    @sources = sources.split(/\s/).map do |s|
      case s
        when 'NOT' then Not.new
        when 'AND' then And.new
        when /([a-z]+)/ then Wire.new($1, wires)
        when 'RSHIFT' then Rshift.new
        when 'LSHIFT' then Lshift.new
        when /(\d+)/ then Value.new($1.to_i)
        when 'OR' then Or.new
        else raise "unknown #{s}"
      end
    end
  end

  def value
    Value(@sources.reduce do |memo, obj|
      puts "#{name} :: (#{memo}).call(#{obj})"
      memo.call(obj) # obj.call(memo)
    end).value
  end

  def call(what)
    Value(what.value)
  end

  def to_s
    "#{@sources.map(&:to_s).join(' ')} -> #{@name}"
  end

  def tree
    @sources.map(&:tree)
  end
end

ARGF.each_line do |line|

  source, wire = line.strip.split(' -> ')
  if wires[wire]
    raise "#{wire} already exists"
  end

  wires[wire] = Source.new(wire, source, wires)
end


original = wires.dup

a = wires['a'].value

p a

wires.replace(original)
wires['b'] = Value(a)

p wires['a'].value
