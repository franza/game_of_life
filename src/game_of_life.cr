require "./game_of_life/*"

module GameOfLife
  VERSION = "0.1.0"

  extend self

  @@height = 50
  @@width  = 100

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

uni = GameOfLife.random_universe
v = GameOfLife::View.new(STDOUT)

control = GameOfLife::Control.new(30.milliseconds) do
  v.render uni
  uni = uni.next_gen
end

control.start
