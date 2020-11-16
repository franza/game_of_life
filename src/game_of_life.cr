require "./game_of_life/*"

module GameOfLife
  VERSION = "0.1.0"

  extend self

  @@height = 50
  @@width  = 50

  def random_state : State
    case Random.rand(0..1)
    when 0
      State::Dead
    else
      State::Alive
    end
  end

  def gen_random_field : Field
    f = Field.new(@@height, @@width)
    @@height.times do |i|
      @@width.times do |j|
        f[i][j] = random_state
      end
    end
    f
  end
end


v = GameOfLife::View.new(STDIN)
f = GameOfLife.gen_random_field
c = GameOfLife::Continuum.new(f)

v.render f

c.each do |f|
  v.render f
  sleep Time::Span.new(nanoseconds: 400_000_000)
end
