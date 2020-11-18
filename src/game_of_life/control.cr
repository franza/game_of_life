class GameOfLife::Control
  def initialize(@render_speed : Time::Span, &block)
    @render = block
  end

  def start
    quit_ch = Channel(Nil).new
    controls_ch = Channel(String).new

    control_loop = spawn do
      loop do
        str = STDIN.read_line
        controls_ch.send str.not_nil!.strip
      end
    end

    main_loop = spawn do
      @render.call

      loop do
        select
        when key = controls_ch.receive
          if key == "q"
            quit_ch.send nil
            break
          elsif key == "i"
            @render_speed -= 100.milliseconds if @render_speed > 100.milliseconds
          elsif key == "d"
            @render_speed += 100.milliseconds
          elsif key == ""
            @render.call
          end
        when timeout(@render_speed)
          @render.call
        end
      end    
    end

    quit_ch.receive
  end
end