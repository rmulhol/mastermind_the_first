require 'spec_helper'
require 'mastermind_game'

describe MastermindGame do

  it "offers a guess" do
    test = MastermindGame.new
		test_first_guess = test.offer_first_guess
		proper_length = test.number_of_rows
		expect(test_first_guess.length).to eq(proper_length)
	end

  it "collects feedback" do
    test = MastermindGame.new
		test_getting_feedback = test.get_feedback
  end

end
