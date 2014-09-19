class MastermindGame
  attr_reader :logic, :display, :possible_combinations

  def initialize(args)
    @logic = args.fetch(:logic)
    @display = args.fetch(:display)
    @possible_combinations = generate_all_combinations
  end

  def begin_game
    welcome_user
    explain_rules
    offer_to_begin_game
    get_input
  end

  def welcome_user
    display.welcome_user
  end

  def explain_rules
    display.explain_rules
  end

  def offer_to_begin_game
    display.offer_to_begin_game
  end

  def get_input
    display.get_input
  end

  def generate_all_combinations
    logic.generate_all_combinations
  end

  def output_first_guess
    guess = logic.generate_guess(possible_combinations)
    guess_in_colors = display.convert_numbers_to_colors(guess)
    display.display_first_guess(guess_in_colors)
  end

  def solicit_feedback_on_black_pegs
    display.solicit_feedback_on_black_pegs
  end

  def solicit_feedback_on_white_pegs
    display.solicit_feedback_on_white_pegs
  end
end
