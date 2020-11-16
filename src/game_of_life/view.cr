require "./field"
require "./state"

class GameOfLife::View
  def initialize(@io : IO)
  end
  
  private def state_to_s(s : State)
    case s
    when State::Alive
      "■"
    when State::Dead
      "□"
    end
  end


  private def cls
    print "\033[H\033[2J"  
  end

  def render(f : Field)
    cls
    
    f.each do |row|
      if row.empty?
        @io << "empty\n"
        next
      end

      @io << row.join(" ") { |state| state_to_s(state) }
      @io << "\n"
    end
  end
end