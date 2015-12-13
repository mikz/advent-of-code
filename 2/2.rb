
class Box
	def initialize(l,w,h)
		@length = l.to_i
		@width = w.to_i
	       @height = h.to_i
	end

	def areas
		[ @length * @width, @length * @height, @height * @width] * 2
	end

	def sides
		[ @length, @height, @width ].sort
	end

	def inspect
		"#<Box:#{object_id} sides:#{sides.inspect}>"
	end

end
boxes = ARGF.map { |l| Box.new(*l.split('x')) }

puts "Paper: #{boxes.map { |box| box.areas.reduce(:+) + box.areas.min }.reduce(:+)}"

puts "Rubbon: #{boxes.map { |box| box.sides.take(2).reduce(:+) * 2 + box.sides.reduce(:*) }.reduce(:+)}"

