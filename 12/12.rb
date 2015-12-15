require 'json'

document = JSON.parse(ARGF.read)

numbers = []
recursion = ->(object) do
  r = recursion.method(:call)
  case object
    when Hash
      values = object.values
      values.flat_map(&r) unless values.include?('red'.freeze)
    when Array
      object.flat_map(&r)
    when Numeric
      numbers << object
      object
    else
      nil
  end
end

p document.flat_map(&recursion).compact.reduce(:+)
