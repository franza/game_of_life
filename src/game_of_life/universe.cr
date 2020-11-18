module GameOfLife
  enum Cell
    Alive
    Dead
  end

  class Universe

    alias Row = Array(Cell)

    include Indexable(Row)
  
    def initialize(@height : Int32, @width : Int32)
      @arr = Array(Row).new(height) do |i|
        Row.new(@width) do |j|
          yield i, j
        end
      end
    end

    def initialize(@height : Int32, @width : Int32)
      @arr = Array(Row).new(@height) { Row.new(@width, Cell::Dead) }
    end

    delegate each,         to: @arr
    delegate size,         to: @arr
    delegate unsafe_fetch, to: @arr
  
    @[AlwaysInline]
    def dim : Tuple(Int32, Int32)
      {@height, @width}
    end
  
    def flat_each_index
      h, w = dim
      h.times { |i| w.times { |j| yield i, j } }
    end
  
    def surroundings(i : Int, j : Int) : Array(Cell)
      sur = [] of Cell
      h, w = dim
  
      (-1..1).each do |delta_i|
        (-1..1).each do |delta_j|
          next if delta_i == 0 && delta_j == 0
  
          sur_i = i + delta_i
          sur_j = j + delta_j
  
          sur << self[sur_i][sur_j] if (0...h).includes?(sur_i) && (0...w).includes?(sur_j)
        end
      end
  
      sur
    end
  
    def next_gen() : Universe
      h, w = dim
      next_gen_uni = Universe.new(h, w)
  
      flat_each_index { |i, j| 
        next_gen_uni[i][j] = evolve(i, j) }
      next_gen_uni
    end
  
    protected def evolve(i, j : Int) : Cell
      alive_count = surroundings(i, j).count { |s| s == Cell::Alive }  
  
      if self[i][j] == Cell::Alive
        if alive_count == 2 || alive_count == 3
          return Cell::Alive
        else
          return Cell::Dead
        end
      else
        if alive_count == 3
          return Cell::Alive
        else
          return Cell::Dead
        end
      end
    end
  end
end
