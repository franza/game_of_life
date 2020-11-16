require "./field"

class GameOfLife::Continuum
  def initialize(@field : Field)
  end

  include Enumerable(Field)

  def each
    loop do
      h, w = @field.dim
      next_gen_field = Field.new(h, w)

      h.times { |i| w.times { |j| next_gen_field[i][j] = Continuum.evolve(@field, i, j) } }
      @field = next_gen_field

      yield @field
    end
  end

  protected def self.evolve(field : Field, i, j : Int) : State
    alive_count = field.surroundings(i, j).count { |s| s == State::Alive }  

    if field[i][j] == State::Alive
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
