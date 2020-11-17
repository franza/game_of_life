require "./game_of_life/*"

module GameOfLife
  VERSION = "0.1.0"

  extend self

  @@height = 50
  @@width  = 50

  def random_cell : Cell
    case Random.rand(0..1)
    when 0
      Cell::Dead
    else
      Cell::Alive
    end
  end

  def random_universe : Universe
    Universe.new(@@height, @@width) { random_cell }
  end
end


v = GameOfLife::View.new(STDIN)
uni = GameOfLife.random_universe

loop do
  v.render uni
  uni = uni.next_gen
  sleep Time::Span.new(nanoseconds: 400_000_000)
end
