require "./state"

class GameOfLife::Field

  class Row
    include Indexable(State)

    def initialize(length : Int, val : State)
      @arr = Array(State).new(length, val)
    end

    delegate :[]=,         to: @arr
    delegate each,         to: @arr
    delegate size,         to: @arr
    delegate unsafe_fetch, to: @arr
  end

  include Indexable(Row)

  def initialize(@height : Int32, @width : Int32)
    @arr = Array(Row).new(height) { |i| Row.new(width, State::Dead) }
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

  def surroundings(i : Int, j : Int) : Array(State)
    sur = [] of State
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

  def next_gen() : Field
    h, w = dim
    next_gen_field = Field.new(h, w)

    flat_each_index { |i, j| next_gen_field[i][j] = evolve(i, j) }
    next_gen_field
  end

  protected def evolve(i, j : Int) : State
    alive_count = surroundings(i, j).count { |s| s == State::Alive }  

    if self[i][j] == State::Alive
      if alive_count == 2 || alive_count == 3
        return State::Alive
      else
        return State::Dead
      end
    else
      if alive_count == 3
        return State::Alive
      else
        return State::Dead
      end
    end
  end
end