class MastermindGame

  def initialize(display, logic)
    @display = display
    @logic = logic
    @number_of_colors = 6
    @rows = 4
    @possible_colors = {red: 1, blue: 2, green: 3, yellow: 4, purple: 5, orange: 6}
    @possible_combinations = @logic.find_all_possible_combinations_of_colors(@number_of_colors, @rows)
    @correct_color_and_correct_placement = ""
    @correct_color_and_incorrect_placement = ""
    @turns = 0
  end

  def play_game
    @display.welcome_user
    solve_the_secret_combination
  end

  private

  def solve_the_secret_combination
    provide_first_guess_to_the_user
    until game_over?
      get_feedback_on_guess_from_user
      use_feedback_to_output_another_guess
    end
  end

  def provide_first_guess_to_the_user
    create_guess_for_the_user
    @display.offer_first_guess(@guess)
    @turns += 1
  end

  def game_over?
    @correct_color_and_correct_placement.to_i == @rows
  end

  def use_feedback_to_output_another_guess
    reduce_available_combinations
    allow_user_to_exit_or_restart_if_there_are_no_possible_combinations_remaining
    create_guess_for_the_user
    @display.offer_non_first_guess(@guess)
    @turns += 1
  end

  def create_guess_for_the_user
    @guess = @logic.generate_guess(@possible_combinations)
    convert_number_array_to_color_array(@guess)
  end

  def reduce_available_combinations
    convert_color_array_to_number_array(@guess)
    @logic.reduce_possible_combinations_according_to_user_feedback(@possible_combinations, @guess, @correct_color_and_correct_placement.to_i, @correct_color_and_incorrect_placement.to_i)
  end

  def allow_user_to_exit_or_restart_if_there_are_no_possible_combinations_remaining
    if @possible_combinations.empty?
      @display.announce_out_of_guesses
      response = @display.get_input
      if confirmed?(response)
        restart_game
      end
      @display.announce_exit_from_game_following_empty_guess_pool unless confirmed?(response)
    end
  end

  def restart_game
    @display.announce_restart_following_empty_guess_pool
    @possible_combinations = @logic.find_all_possible_combinations_of_colors(@number_of_colors, @rows)
    @turns = 0
    solve_the_secret_combination
  end

  def convert_number_array_to_color_array(guess)
    guess.each_with_index do |value, index|
      guess[index] = @possible_colors.key(value).to_s
    end
  end

  def convert_color_array_to_number_array(guess)
    guess.each_with_index do |value, index|
      guess[index] = @possible_colors[value.to_sym]
    end
  end


  def get_feedback_on_guess_from_user
    @double_check_feedback = ""
    until confirmed?(@double_check_feedback)
      get_feedback_from_user_on_correct_color_and_correct_placement
      get_feedback_from_user_on_correct_color_and_incorrect_placement
      get_new_feedback_if_the_user_feedback_is_mathematically_impossible
      @display.confirm_feedback(@correct_color_and_correct_placement, @correct_color_and_incorrect_placement)
      @double_check_feedback = @display.get_input
    end
  end

  def confirmed?(matter_to_confirm)
    matter_to_confirm[0] == "y" || matter_to_confirm[0] == "Y"
  end

  def get_feedback_from_user_on_correct_color_and_correct_placement
    @display.get_feedback_on_correct_color_and_correct_placement
    @correct_color_and_correct_placement = @display.get_input
    if !user_feedback_valid?(@correct_color_and_correct_placement)
      @display.announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
      get_feedback_from_user_on_correct_color_and_correct_placement
    end
    @display.announce_computer_wins_the_game(@turns) unless @correct_color_and_correct_placement.to_i != @rows
  end

  def get_feedback_from_user_on_correct_color_and_incorrect_placement
    @display.get_feedback_on_correct_color_and_incorrect_placement
    @correct_color_and_incorrect_placement = @display.get_input
    if !user_feedback_valid?(@correct_color_and_incorrect_placement)
      @display.announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
      get_feedback_from_user_on_correct_color_and_incorrect_placement
    end
  end

  def get_new_feedback_if_the_user_feedback_is_mathematically_impossible
    if mathematically_impossible?
      @display.announce_error_for_mathematically_impossible_feedback
      get_feedback_from_user_on_correct_color_and_correct_placement
      get_feedback_from_user_on_correct_color_and_incorrect_placement
    end
  end

  def mathematically_impossible?
    (@correct_color_and_correct_placement.to_i == (@rows - 1) && @correct_color_and_incorrect_placement.to_i == 1) || (@correct_color_and_correct_placement.to_i + @correct_color_and_incorrect_placement.to_i) > @rows
  end

  def user_feedback_valid?(feedback)
    feedback_to_check = feedback.strip
    valid = ["0","1","2","3","4"]
    valid.include?feedback_to_check
  end

end





