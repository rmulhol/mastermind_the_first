require 'mastermind_game'
require 'game_ai'
require 'command_line_display'

describe MastermindGame do
  let(:new_game) { described_class.new(logic: GameAI.new, display: CommandLineDisplay.new) }
  
  describe "#welcome_user" do
    it "welcomes the user" do
      expect { new_game.welcome_user }.to output("Welcome to Mastermind\n").to_stdout
    end
  end

  describe "#explain_rules" do
    it "explains the game to the user" do
      expect { new_game.explain_rules }.to output("In this game, you will think up a secret code, and I will try to figure it out within ten turns. Your code should be four colors long, with repeats allowed, and the colors you can choose from are: red, blue, green, yellow, purple, and orange.\n").to_stdout
    end
  end

  describe "#offer_to_begin_game" do
    it "prompts the user to begin the game" do
      expect { new_game.offer_to_begin_game }.to output("Hit enter when you've come up with a secret code and are ready to begin!\n").to_stdout
    end
  end

  describe "#get_input" do
    before do
      $stdin = StringIO.new("This is a test")
    end

    after do
      $stdin = STDIN
    end

    it "takes input" do
      expect(new_game.get_input).to eq("This is a test")
    end
  end

  describe "#generate_all_combinations" do
    it "creates 1296 possible combinations" do
      expect(new_game.generate_all_combinations.length).to eq(1296)
    end

    it "creates the right combinations" do
      expect(new_game.generate_all_combinations).to include([1, 1, 1, 1], [1, 2, 3, 4], [3, 4, 5, 6], [6, 6, 6, 6])
    end
  end
end

