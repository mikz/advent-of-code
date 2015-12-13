instruction = /(\w+) to (\w+) = (\d+)/

flights = []

class Flight
  attr_reader :location, :destination, :distance

  def initialize(location, destination, distance)
    @location = location
    @destination = destination
    @distance = distance
  end

  def cities
    [location, destination]
  end

  def match(from, to)
    cities.include?(from) && cities.include?(to)
  end
end

ARGF.each_line do |line|
  match = line.match(instruction) or next

  _, location, destination, distance = match.to_a
  flights << Flight.new(location, destination, distance.to_i)
end

flights.compact!

cities = flights.flat_map(&:cities).uniq

destinations = flights.map(&:destination)

origin_cities = (cities - destinations)

p origins = origin_cities.flat_map { |l| flights.select{|f| f.location == l } }

routes = cities.uniq.permutation.map do |group|
  route = group.each_cons(2).reduce([]) do |memo, (from, to)|
    memo << flights.find{ |f| f.match(from, to) }
  end
  route if route.compact.size >= group.size - 1
end


distance = ->(flights) do
  flights.map(&:distance).reduce(:+)
end


shortest = routes.compact.sort_by(&distance).reverse_each.first

p shortest
p distance.(shortest)
