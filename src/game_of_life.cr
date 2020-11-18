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

quit_ch = Channel(Nil).new
controls_ch = Channel(Char).new

control_loop = spawn do
  loop do
    ch = STDIN.read_char
    controls_ch.send ch.not_nil!
  end
end

main_loop = spawn do
  v = GameOfLife::View.new(STDIN)
  uni = GameOfLife.random_universe
  sleep_time = 30

  re_render = ->() {
    v.render uni
    uni = uni.next_gen
  }

  re_render.call

  loop do
    select
    when key = controls_ch.receive
      if key == 'q'
        quit_ch.send nil
        break
      elsif key == 'i'
        sleep_time += 100
      elsif key == 'd'
        sleep_time -= 100 if sleep_time > 100
      elsif key == '\n'
        re_render.call
      end
    when timeout(sleep_time.milliseconds)
      re_render.call
    end
  end    
end

quit_ch.receive