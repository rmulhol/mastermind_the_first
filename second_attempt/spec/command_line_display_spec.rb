require 'command_line_display'

describe CommandLineDisplay do

  let(:test) { described_class.new }

  describe "#welcome_user" do
    it "welcomes the user" do
      expect { test.welcome_user }.to output("Welcome to Mastermind\n").to_stdout
    end
  end

  describe "#explain_rules" do
    it "explains the game rules" do
      expect { test.explain_rules }.to output("In this game, you will think up a secret code, and I will try to figure it out within ten turns. Your code should be four colors long, with repeats allowed, and the colors you can choose from are: red, blue, green, yellow, purple, and orange.\n").to_stdout
    end
  end

  describe "#offer_to_begin_game" do
    it "tells the user to begin the game by hitting enter" do
      expect { test.offer_to_begin_game }.to output("Hit enter when you've come up with a secret code and are ready to begin!\n").to_stdout
    end
  end

  describe "#get_input" do
    before do
      $stdin = StringIO.new("Hello")
    end

    after do
      $stdin = STDIN
    end

    it "takes input" do
      expect(test.get_input).to eq("Hello")
    end
  end

  describe "#display_first_guess" do
    it "offers first guess" do
      expect { test.display_first_guess(["red", "red", "red", "red"]) }.to output("My first guess is [\"red\", \"red\", \"red\", \"red\"]\n").to_stdout
    end
  end

  describe "#display_next_guess" do
    it "offers another guess" do
      expect { test.display_next_guess(["red", "red", "red", "red"]) }.to output("My next guess is [\"red\", \"red\", \"red\", \"red\"]\n").to_stdout
    end
  end

  describe "#solicit_feedback_on_black_pegs" do
    it "asks the user for the number of black pegs" do
      expect { test.solicit_feedback_on_black_pegs }.to output("How many of my picks are the correct color and in the correct position?\n").to_stdout
    end
  end

  describe "#solicit_feedback_on_white_pegs" do
    it "asks the user for the number of white pegs" do
      expect { test.solicit_feedback_on_white_pegs }.to output("How many of my picks are the correct color but not in the correct position?\n").to_stdout
    end
  end

  describe "#convert_numbers_to_colors" do
    it "converts an array of [1, 1, 1, 1] to [\"red\", \"red\", \"red\", \"red\"]" do
      expect(test.convert_numbers_to_colors([1, 1, 1, 1])).to eq(["red", "red", "red", "red"])
    end

    it "converts an array of [2, 2, 2, 2] to [\"blue\", \"blue\", \"blue\", \"blue\"]" do
      expect(test.convert_numbers_to_colors([2, 2, 2, 2])).to eq(["blue", "blue", "blue", "blue"])
    end
  end

  it "converts an array of [1, 2, 3, 4] to [\"red\", \"blue\", \"green\", \"yellow\"]" do
    expect(test.convert_numbers_to_colors([1, 2, 3, 4])).to eq(["red", "blue", "green", "yellow"])
  end

  describe "#error_message" do
    it "notifies the user of invalid input and solicits another try" do
      expect { test.error_message }.to output("Invalid response. Please try again.\n").to_stdout
    end
  end

  describe "#codebreaker win" do
    it "announces the codebreaker has won with turns" do
      expect { test.codebreaker_win(5) }.to output("I figured out your code in 5 turns!\n").to_stdout
    end
  end
end
