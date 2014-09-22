class MastermindGame
  attr_reader :logic, :display 
  attr_accessor :possible_combinations, :guess, :turns, :feedback

  def initialize(args)
    @logic = args.fetch(:logic)
    @display = args.fetch(:display)
    @possible_combinations = generate_all_combinations
    @guess = create_guess(possible_combinations)
    @turns = 0
  end

  def play_game
    begin_game
    carry_out_game
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

  def carry_out_game
    visible_guess = output_first_guess(guess)
    self.turns += 1
    self.feedback = solicit_feedback_on_previous_guess
    until self.possible_combinations.length <= 1
      self.possible_combinations = logic.reduce_remaining_combinations(self.guess, self.feedback, self.possible_combinations)
      self.guess = create_guess(self.possible_combinations)
      next_visible_guess = output_next_guess(self.guess)
      self.turns += 1
      self.feedback = solicit_feedback_on_previous_guess
    end
  end

  def generate_all_combinations
    logic.generate_all_combinations
  end

  def create_guess(remaining_combinations)
    logic.generate_guess(remaining_combinations)
  end

  def output_first_guess(guess)
    guess_in_colors = display.convert_numbers_to_colors(guess)
    display.display_first_guess(guess_in_colors)
  end

  def output_next_guess(guess)
    guess_in_colors = display.convert_numbers_to_colors(guess)
    display.display_next_guess(guess_in_colors)
  end

  def solicit_feedback_on_black_pegs
    display.solicit_feedback_on_black_pegs
  end

  def solicit_feedback_on_white_pegs
    display.solicit_feedback_on_white_pegs
  end

  def solicit_feedback_on_previous_guess
    solicit_feedback_on_black_pegs
    black_pegs = get_input
    if black_pegs.to_i == 4
      display.codebreaker_win(self.turns)
      exit
    end
    until individual_peg_feedback_is_valid?(black_pegs)
      display.error_message
      solicit_feedback_on_black_pegs
      black_pegs = get_input
    end
    solicit_feedback_on_white_pegs
    white_pegs = get_input
    until individual_peg_feedback_is_valid?(white_pegs)
      display.error_message
      solicit_feedback_on_white_pegs
      white_pegs = get_input
    end
    until aggregate_peg_feedback_is_valid?(black_pegs, white_pegs)
      display.error_message
      black_pegs, white_pegs = '', ''
      solicit_feedback_on_previous_guess
    end
    [black_pegs.to_i, white_pegs.to_i]
  end

  def individual_peg_feedback_is_valid?(feedback_on_individual_peg)
    if feedback_on_individual_peg.to_i == 0
      feedback_on_individual_peg.strip == "0"
    elsif feedback_on_individual_peg.to_i <= 4
      feedback_on_individual_peg.to_i > 0
    else
      false
    end
  end

  def aggregate_peg_feedback_is_valid?(black_pegs, white_pegs)
    if (black_pegs.to_i == 3 && white_pegs.to_i == 1)
      false
    else
      black_pegs.to_i + white_pegs.to_i <= 4
    end
  end
    
end
