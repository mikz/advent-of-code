class Reindeer
  def initialize(name, speed, duration, rest)
    @name = name
    @speed = speed
    @duration = duration
    @rest = rest
  end

  def to_s
    @name
  end

  def *(time)
    iteration = @duration + @rest
    iterations = time / iteration

    rest = time - iterations * iteration

    iterations * @speed * @duration + @speed * [rest, @duration].min
  end
end



reindeer = ARGF.each_line.map do |line|
  _, name, speed, duration, rest = line.match(%r{^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}).to_a


  Reindeer.new(name, speed.to_i, duration.to_i, rest.to_i)
end


p reindeer.map{|r| r * 2503 }.max

class Race
  attr_reader :scores

  def initialize(reindeer)
    @reindeer = reindeer
    @scores = Hash.new(0)
  end

  def *(time)
    @reindeer.map do |r|
      [r.to_s, r * time]
    end.to_h
  end

  def increment(*reindeer)
    reindeer.flatten.each do |r|
      @scores[r] += 1
    end
  end
end

race = Race.new(reindeer)

1.upto(2503).each do |i|
  result = race * i
  max = result.values.max

  race.increment result.select { |r, v| v == max }.keys
end

p race.scores
