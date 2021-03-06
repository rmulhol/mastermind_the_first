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
    @gameplay_selection = ""
    @turns = 0
  end

  def play_game
    game_selection
    start_game
  end

  private

  def game_selection
    @display.welcome_user
    @gameplay_selection = @display.get_input
    until game_selection_is_valid?
      @display.announce_error_for_incorrect_gameplay_selection
      @gameplay_selection = @display.get_input
    end
  end

  def game_selection_is_valid?
    @gameplay_selection == "codemaker" || @gameplay_selection == "codebreaker"
  end

  def start_game
    if @gameplay_selection == "codemaker"
      play_game_with_user_as_codemaker
    elsif @gameplay_selection == "codebreaker"
      play_game_with_user_as_codebreaker
    end
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

  def confirmed?(matter_to_confirm)
    matter_to_confirm[0] == "y" || matter_to_confirm[0] == "Y"
  end

# code for user as codemaker

  def play_game_with_user_as_codemaker
    @display.welcome_message_for_user_as_codemaker
    solve_the_secret_combination
  end

  def solve_the_secret_combination
    provide_first_guess_to_the_user
    until user_as_codemaker_game_over?
      get_feedback_on_guess_from_user
      use_feedback_to_output_another_guess
    end
  end

  def provide_first_guess_to_the_user
    create_guess_for_the_user
    @display.offer_first_guess(@guess)
    @turns += 1
  end

  def user_as_codemaker_game_over?
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
        restart_game_with_user_as_codemaker
      end
      @display.announce_exit_from_game unless confirmed?(response)
    end
  end

  def restart_game_with_user_as_codemaker
    @display.announce_game_restart
    @possible_combinations = @logic.find_all_possible_combinations_of_colors(@number_of_colors, @rows)
    @turns = 0
    solve_the_secret_combination
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

  def get_feedback_from_user_on_correct_color_and_correct_placement
    @display.get_feedback_on_correct_color_and_correct_placement
    @correct_color_and_correct_placement = @display.get_input
    if !user_feedback_valid?(@correct_color_and_correct_placement)
      @display.announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
      get_feedback_from_user_on_correct_color_and_correct_placement
    end
    @display.announce_computer_wins_the_game(@turns) if user_as_codemaker_game_over?
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

# code for user as codebreaker

  def play_game_with_user_as_codebreaker
    @display.welcome_message_for_user_as_codebreaker
    generate_secret_code
    collect_first_guess_and_provide_feedback
    let_the_user_provide_successive_guesses_and_provide_feedback
  end

  def generate_secret_code
    @secret_code = @logic.generate_guess(@possible_combinations)
  end

  def collect_first_guess_and_provide_feedback
    @display.get_first_guess
    @user_guess = ""
    get_guess_from_the_user
    @turns += 1
    provide_feedback_on_user_guess
  end

  def let_the_user_provide_successive_guesses_and_provide_feedback
    until user_as_codebreaker_game_over?
      @user_guess = ""
      @display.get_non_first_guess
      get_guess_from_the_user
      @turns += 1
      provide_feedback_on_user_guess
    end
    @display.announce_user_loses_the_game if @turns > 10
    @display.announce_user_wins_the_game(@turns) <= 10
  end

  def provide_feedback_on_user_guess
    compare_user_guess_to_secret_code
    @display.announce_user_wins_the_game(@turns) if user_as_codebreaker_game_over?
    @display.provide_feedback_to_the_user(@result_of_comparsion[0], @result_of_comparsion[1])
  end

  def get_guess_from_the_user
    until @user_guess.length == 4
        @user_guess = @display.get_input
        if @user_guess.split.length != 4
          @display.tell_user_feedback_is_not_four_elements
	  get_guess_from_the_user
	end
        if @user_guess.include? ","
          @user_guess = @user_guess.split(/,/).collect {|guess_item| guess_item.strip.downcase}
        else
          @user_guess = @user_guess.split.collect {|guess_item| guess_item.downcase}
        end
    end
  end

  def user_as_codebreaker_game_over?
    @user_guess == @secret_code || @turns >= 11
  end

  def compare_user_guess_to_secret_code
    @result_of_comparsion = @logic.compare_guess_to_remaining_options(convert_color_array_to_number_array(@user_guess), @secret_code)
  end

end

