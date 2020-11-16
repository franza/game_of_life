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

  def dim : Tuple(Int32, Int32)
    {@height, @width}
  end

  def surroundings(i : Int, j : Int) : Array(State)
    sur = [] of State

    (-1..1).each do |delta_i|
      (-1..1).each do |delta_j|
        sur_i = i + delta_i
        sur_j = j + delta_j

        next if sur_i < 0 || sur_j < 0 || sur_i >= self.size || sur_j >= self[sur_i].size

        sur << self[sur_i][sur_j]
      end
    end

    sur
  end
end