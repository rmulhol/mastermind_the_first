class GameAI

  attr_accessor :number_of_colors, :number_of_rows

  def initialize(number_of_colors, number_of_rows)
    self.number_of_colors = number_of_colors 
    self.number_of_rows = number_of_rows
  end

  def generate_all_combinations	
    colors_array = convert_colors_number_to_colors_array(number_of_colors)  
		all_possible_combinations = colors_array.repeated_permutation(number_of_rows).to_a
		all_possible_combinations
  end

  def convert_colors_number_to_colors_array(number)
    array_of_colors = (1..number).to_a
  end

end
