old_rules = [
    ->(str) { str.scan(/[aeiou]/).size >= 3 },
    ->(str) { str.each_char.each_cons(2).any? { |s| s.uniq.size == 1 } },
    ->(str) { !str.match(/ab|cd|pq|xy/) }
]

new_rules = [
  ->(str) { str.match(/([a-z]).(?=(\1))/) },
  ->(str) { str.match(/([a-z]{2})(?=.*\1)/) }
]

rules = new_rules

lines = ARGF.each_line.count do |line|
  rules.all? { |rule| rule.(line.strip) }
end

p lines
