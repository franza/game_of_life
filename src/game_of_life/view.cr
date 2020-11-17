require "./universe"

class GameOfLife::View
  def initialize(@io : IO)
  end
  
  def render(cell : Cell)
    case cell
    when Cell::Alive
      "■"
    when Cell::Dead
      "□"
    end
  end


  private def cls
    print "\033[H\033[2J"
  end

  def render(uni : Universe)
    cls
    
    uni.each do |row|
      if row.empty?
        @io << "empty\n"
        next
      end

      @io << row.join(" ") { |cell| render cell }
      @io << "\n"
    end
  end
end