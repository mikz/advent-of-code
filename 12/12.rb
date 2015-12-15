require 'json/stream'
require 'json'

def ARGF.close; end
def ARGF.force_encoding(*); end
def ARGF.valid_encoding?(*); true; end

class Builder < JSON::Stream::Builder
  attr_reader :total

  def initialize(*)
    super
    @numbers = []
    @total = []
    @ignore = nil
    @objects = []
  end

  def start_object
    @numbers.push([])
    @objects.push(true)
    super
  end

  def end_object
    return if @stack.size == 1

    @total.push @numbers.pop

    if !(ignore = @objects.pop)
      puts "IGNORING #{@stack.pop}"
    else
      super
    end
  end

  def value(val)
    case val
      when 'red'
        if @stack[-1].is_a?(Hash)
          @objects[-1] = false
        end
      when Numeric
        @numbers[-1] << val
    end

    super
  end
end

parser = JSON::Stream::Parser.new

builder = Builder.new(parser)

parser << ARGF

p builder.result

puts JSON.pretty_generate(builder.result)
p builder.total.flatten.reduce(:+)

