input = ARGF.read.strip

def look_and_say(input)
  str = input.dup
  regexp = /(\d)(?=(\1*))/
  position = 0

  loop do
    match = str.match(regexp, position) or break
    _, n, r = match.to_a
    length = (n + r).length
    s = str[position, length] = "#{length}#{n}"
    position += s.length
  end

  str
end

p 50.times.reduce(input.to_i) { |m,_| m ** 1.303577269 }.to_s.length
p 50.times.reduce(input){ |m,i| puts "#{i+1} @ #{Time.now}"; look_and_say(m) }.length
