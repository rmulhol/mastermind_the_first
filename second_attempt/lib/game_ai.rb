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

  def same_color_same_position(first_guess, second_guess)
    black_pegs = 0
    first_guess.each_with_index do |peg, position|
      black_pegs += 1 if peg == second_guess[position]
    end
    black_pegs
  end

  def same_color(first_guess, second_guess)
    same_color = 0
    guess_two = second_guess.clone
    first_guess.each_with_index do |peg, position|
      if guess_two.include? peg
        same_color += 1
        peg_to_remove = guess_two.index(peg)
        guess_two.delete_at(peg_to_remove)
      end
    end
    same_color
  end

  def get_feedback(first_guess, second_guess)
    black_pegs = same_color_same_position(first_guess, second_guess)
    total_same_color = same_color(first_guess, second_guess)
    white_pegs = total_same_color - black_pegs
    result_of_comparison = [black_pegs, white_pegs]
    result_of_comparison
  end

  def is_a_possible_combination?(previous_guess, feedback, remaining_option)
    feedback_on_remaining_option = get_feedback(previous_guess, remaining_option)
    feedback_on_remaining_option == feedback
  end

  def store_possible_combinations(previous_guess, feedback)
    remaining_options = self.possible_combinations
    remaining_options.keep_if do |possible_remaining_option|
      is_a_possible_combination?(previous_guess, feedback, possible_remaining_option)
    end
    remaining_options
  end
end
