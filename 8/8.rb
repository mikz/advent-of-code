strings = ARGF.each_line.map do |line|
  l = line.strip
  s = eval(l)

  # l.bytesize - s.bytesize

  l.inspect.bytesize - l.bytesize
end

puts strings.reduce(:+)
