class GameAI

  def find_all_possible_combinations_of_colors(colors, rows)
    (1..colors).to_a.repeated_permutation(rows).to_a
  end

  def generate_guess(possible_combinations)
    possible_combinations[rand(possible_combinations.length)]
  end

  def reduce_possible_combinations_according_to_user_feedback(possible_combinations, guess, user_feedback_on_correct_guess_and_correct_color, user_feedback_on_correct_guess_and_incorrect_color)
    possible_combinations.keep_if do |possible_combination|
      compare_guess_to_remaining_options(guess, possible_combination) == [user_feedback_on_correct_guess_and_correct_color, user_feedback_on_correct_guess_and_incorrect_color]
    end
  end

  def compare_guess_to_remaining_options(last_guess, possibility)
    @correct_color_and_placement = 0
    @correct_color_but_not_placement = 0
    @possible_correct_color_but_not_placement = []
    @remaining_options = []
    check_if_guess_matches_possible_combination_exactly(last_guess, possibility)
    check_if_guess_matches_possible_combination_inexactly
    result_of_comparison = [@correct_color_and_placement, @correct_color_but_not_placement]
    result_of_comparison
  end

  def check_if_guess_matches_possible_combination_exactly(last_guess, possibility)
    last_guess.each_with_index do |value, index|
      if last_guess[index] == possibility[index]
        @correct_color_and_placement += 1
      else
        @possible_correct_color_but_not_placement << last_guess[index]
        @remaining_options << possibility[index]
      end
    end
  end

  def check_if_guess_matches_possible_combination_inexactly
    @possible_correct_color_but_not_placement.each do |value|
      if @remaining_options.include? value
        @correct_color_but_not_placement += 1
        @remaining_options.delete_at(@remaining_options.index(value))
      end
    end
  end

end