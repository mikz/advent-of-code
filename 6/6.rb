# toggle 936,774 through 937,775
# turn off 116,843 through 533,934
# turn on 950,906 through 986,993


class Light
  attr_reader :x, :y, :brightness

  def initialize(x, y)
    @x = x
    @y = y
    @brightness = 0
  end

  def toggle
    @brightness += 2
  end

  def turn_off
    @brightness -= 1
    @brightness = 0 if @brightness < 0
  end

  def turn_on
    @brightness += 1
  end

  def on?
    @brightness > 0
  end

  def to_s
    "#{x}x#{y} #{@brightness}"
  end
end

class Grid
  def initialize(size)
    @grid = size.times.map do |y|
      size.times.map { |x| Light.new(x, y) }
    end
  end

  def size
    @grid.map(&:size).reduce(:+)
  end

  def range(from, to)
    from_x, from_y = from
    to_x, to_y = to

    from_x.upto(to_x).flat_map do |x|
      from_y.upto(to_y).map do |y|
        @grid[y][x]
      end
    end
  end

  def each
    return enum_for unless block_given?

    @grid.each do |y|
      y.each do |l|
        yield l
      end
    end
  end
end

lights = Grid.new(1000)

instruction = /(toggle|turn off|turn on) (\d+),(\d+) through (\d+),(\d+)/

ARGF.each_line do |line|
  match = line.match(instruction)

  match or next

  _, cmd, from_x, from_y, to_x, to_y = match.to_a

  cmd = cmd.tr(' ', '_')

  from = [from_x, from_y].map(&:to_i)
  to = [to_x, to_y].map(&:to_i)

  lights.range(from, to).each{ |light| light.send(cmd) }
end

p lights.each.map(&:brightness).reduce(:+)
