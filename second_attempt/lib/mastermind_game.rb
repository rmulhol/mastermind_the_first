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
end