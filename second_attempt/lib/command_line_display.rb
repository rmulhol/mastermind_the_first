class CommandLineDisplay

  def welcome_user
    puts "Welcome to Mastermind"
  end

  def explain_rules
    puts "In this game, you will think up a secret code, and I will try to figure it out within ten turns. Your code should be four colors long, with repeats allowed, and the colors you can choose from are: red, blue, green, yellow, purple, and orange."
  end

  def offer_to_begin_game
    puts "Hit enter when you've come up with a secret code and are ready to begin!"
  end

  def get_input
    $stdin.gets.chomp
  end

  def display_first_guess(guess)
    puts "My first guess is " + guess.inspect
  end

  def display_next_guess(guess)
    puts "My next guess is " + guess.inspect
  end

  def solicit_feedback_on_black_pegs
    puts "How many of my picks are the correct color and in the correct position?"
  end

  def solicit_feedback_on_white_pegs
    puts "How many of my picks are the correct color but not in the correct position?"
  end

  def convert_numbers_to_colors(array_of_numbers)
    possible_colors = { 1 => "red", 2 => "blue", 3 => "green", 4 => "yellow", 5 => "purple", 6 => "orange" }
    array_of_colors = array_of_numbers.map do |number|
      possible_colors[number]
    end
    array_of_colors
  end

  def error_message
    puts "Invalid response. Please try again."
  end

  def codebreaker_win(turns)
    puts "I figured out your code in #{turns} turns!"
  end
end
