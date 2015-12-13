require 'equalizer'

class Position
	include Equalizer.new(:x, :y)
	attr_reader :x, :y

	def initialize(x: 0, y: 0)
		@x = x
		@y = y
	end

	def move(diff_x,diff_y)
		self.class.new(x: x + diff_x, y: y + diff_y)
	end
end

positions = [Position.new, Position.new]

houses = ARGF.each_char.map do |c|
	position = positions.shift
	inst = case c
	when '^' then [0, +1]
	when 'v' then [0, -1]
	when '>' then [+1, 0]
	when '<' then [-1, 0]
	else next Position.new
	end
	position = position.move(*inst)
	positions.push(position)
	position
end

p houses.uniq
p houses.size
p houses.uniq.size


