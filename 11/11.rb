
class PasswordGenerator
  attr_reader :current

  ALPHABET = 'a'..'z'

  SEQUENCES = /(#{Regexp.union(ALPHABET.each_cons(3).map(&:join))})/
  PAIRS = /(#{Regexp.union(ALPHABET.map{|l| l + l })})/
  FORBIDDEN = /([iol])/

  RULES = [
      ->(str) { ! str.match(FORBIDDEN) },
      ->(str) { str.match(SEQUENCES) },
      ->(str) { str.scan(PAIRS).uniq.size > 1 }
  ]

  def initialize(password)
    @current = password
  end

  def next
    password = self.current

    loop do
      password = password.succ
      return password if RULES.all? { |r| r.(password) }
    end
  end

  def each
    password = self.current
    Enumerator.new do |yielder|
      loop do
        password = PasswordGenerator.new(password).next
        yielder << password
      end
    end
  end
end

ARGF.each_line do |line|
  password = line.strip
  puts PasswordGenerator.new(password).each.take(2)
end
