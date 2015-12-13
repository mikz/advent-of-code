floor = 0
position = 0
while c = ARGF.getc
	position += 1 if position 
	floor += case c
	when '(' then +1
	when ')' then -1
	else 0
	end
	if floor < 0 && position
		p position
		position = nil
	end
end

puts floor
