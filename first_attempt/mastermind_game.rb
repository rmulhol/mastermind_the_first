class CommandLineDisplay

  def welcome_user
    puts "Hello, welcome to Mastermind."
    puts "In order to play, you need to think up a secret code with 4 spots."
    puts "The colors you can choose from are: red, blue, green, yellow, purple, and orange."
    puts "Hit enter when you're ready for my first guess!"
    get_input
  end

  def get_input
    gets.chomp
  end

  def offer_first_guess(guess)
    puts "My first guess is #{guess}"
  end 

  def offer_non_first_guess(guess)
    puts "My next guess is #{guess}"
  end

  def get_feedback_on_correct_color_and_incorrect_placement
    puts "How many of my picks are the correct color but in the incorrect placement? (0-4)"
  end

  def get_feedback_on_correct_color_and_correct_placement
    puts "How many of my picks are in the correct color and in the correct position? (0-4)"
  end

  def confirm_feedback(correct_color_and_correct_placement, correct_color_and_incorrect_placement)
    puts "OK, so I have #{correct_color_and_correct_placement} picks with the correct color in the correct position, and #{correct_color_and_incorrect_placement} picks with the correct color in the incorrect position? (y/n)"
  end	

  def announce_out_of_guesses
    puts "Hmm. Seems like I've run out of possible guesses. Would you like to restart my guessing sequence with the same guess? (y/n)"
  end

  def announce_restart_following_empty_guess_pool
    puts "OK! Restarting from the beginning!"
  end

  def announce_exit_from_game_following_empty_guess_pool
    abort("Sorry it didn't work out this time. Hope to play again soon.")
  end

  def announce_computer_wins_the_game(turns)
    if turns == 1
      abort("I figured out your code in #{turns} turn!")
    else
      abort("I figured out your code in #{turns} turns!")
    end
  end

  def announce_error_for_mathematically_impossible_feedback
  	puts "Oops! That feedback is mathematically impossible - let's try again!"
  end

  def announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
  	puts "I don't understand! Please enter a number between 0 and 4."
  end

end

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
    if user_feedback_is_not_valid?(@correct_color_and_correct_placement)
      @display.announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
      get_feedback_from_user_on_correct_color_and_correct_placement
    end
    @display.announce_computer_wins_the_game(@turns) unless @correct_color_and_correct_placement.to_i != @rows
  end

  def get_feedback_from_user_on_correct_color_and_incorrect_placement
    @display.get_feedback_on_correct_color_and_incorrect_placement
    @correct_color_and_incorrect_placement = @display.get_input
    if user_feedback_is_not_valid?(@correct_color_and_incorrect_placement)
      @display.announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
      get_feedback_from_user_on_correct_color_and_incorrect_placement
    end
  end

  def get_new_feedback_if_the_user_feedback_is_mathematically_impossible
    if mathematically_impossible?
      @display.announce_error_for_mathematically_impossible_feedback
      get_feedback_on_guess_from_user
    end
  end

  def mathematically_impossible?
    (@correct_color_and_correct_placement.to_i == (@rows - 1) && @correct_color_and_incorrect_placement.to_i == 1) || (@correct_color_and_correct_placement.to_i + @correct_color_and_incorrect_placement.to_i) > @rows
  end

  def user_feedback_is_not_valid?(feedback)
    feedback.strip != "0" && feedback.strip != "1" && feedback.strip != "2" && feedback.strip != "3" && feedback.strip != "4"
  end

end

my_game = MastermindGame.new(CommandLineDisplay.new, GameAI.new)

my_game.play_game



