class GameAI

  attr_accessor :number_of_colors, :number_of_rows

  def initialize
    @number_of_colors = 6
    @number_of_rows = 4
  end

  def generate_all_combinations	
    (1..number_of_colors).to_a.repeated_permutation(number_of_rows).to_a
  end

end
