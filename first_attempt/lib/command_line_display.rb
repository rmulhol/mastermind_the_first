class CommandLineDisplay

  def welcome_user
    puts "Hello, welcome to mastermind."
    puts "In this game, one player will think up a secret code, and the other will try to figure it out."
    puts "Which player do you want to be? (codemaker or codebreaker)"
  end

  def get_input
    gets.chomp
  end

  def announce_game_restart
    puts "OK! Restarting from the beginning!"
  end

  def announce_exit_from_game
    abort("Sorry it didn't work out this time. Hope to play again soon.")
  end

  def announce_error_for_incorrect_gameplay_selection
    puts "Oops! I need you to write codebreaker or codemaker to proceed."
  end

# code for user as codemaker

  def welcome_message_for_user_as_codemaker
    puts "OK, great! You're the codemaker."
    puts "In order to play, you need to think up a secret code with 4 spots."
    puts "The colors you can choose from are: red, blue, green, yellow, purple, and orange."
    puts "Hit enter when you're ready for my first guess!"
    get_input
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

  def announce_error_for_mathematically_impossible_feedback
    puts "Oops! That feedback is mathematically impossible - let's try again!"
  end

  def announce_error_for_feedback_that_is_not_a_number_between_zero_and_four
    puts "I don't understand! Please enter a number between 0 and 4."
  end

  def announce_computer_wins_the_game(turns)
    if turns == 1
      abort("I figured out your code in #{turns} turn!")
    else
      abort("I figured out your code in #{turns} turns!")
    end
  end

# code for user as codebreaker

  def welcome_message_for_user_as_codebreaker
    puts "OK, great! You're the codebreaker."
    puts "I'm going to think up a secret code with 4 spots."
    puts "The colors that I can choose from are: red, blue, green, yellow, purple, and orange."
    puts "Hit enter when you're ready to enter your first guess!"
    get_input
  end

  def get_first_guess
    puts "What's your first guess? (Please enter a sequence of 4 colors, separating each color with a space or comma)"
  end

  def get_non_first_guess
    puts "Ok, what's your next guess? (Please enter a sequence of 4 colors, separating each color with a space or comma)"
  end

  def tell_user_feedback_is_not_four_elements
    puts "You didn't enter a code with four spots! Try again."
  end

  def provide_feedback_to_the_user(correct_color_and_correct_placement, correct_color_and_incorrect_placement)
    puts "You have #{correct_color_and_correct_placement} in the correct color and correct position, and #{correct_color_and_incorrect_placement} in the correct color but the incorrect position!"
  end

  def announce_user_wins_the_game(turns)
    if turns == 1
      abort("That's my code! You figured it out in #{turns} turn!")
    else
      abort("That's my code! You figured it out in #{turns} turns!")
    end
  end

  def announce_user_loses_the_game
    abort("You lost! You took more than 10 guesses.")
  end

end

