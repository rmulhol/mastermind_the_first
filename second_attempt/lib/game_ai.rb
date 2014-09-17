class GameAI

  attr_accessor :number_of_colors, :number_of_rows, :possible_combinations

  def initialize(number_of_colors, number_of_rows)
    self.number_of_colors = number_of_colors 
    self.number_of_rows = number_of_rows
    self.possible_combinations = generate_all_combinations
  end

  def generate_all_combinations	
    colors_array = convert_colors_number_to_colors_array  
		all_possible_combinations = colors_array.repeated_permutation(number_of_rows)
		all_possible_combinations.to_a
  end

  def convert_colors_number_to_colors_array
    (1..number_of_colors).to_a
  end

  def generate_guess
    possible_combinations[rand(generate_all_combinations.length)]
  end

end
