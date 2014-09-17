require 'game_ai'

describe GameAI do
  let(:test) {described_class.new(6, 4)}

  it "generates the proper number of combinations" do
    possible_combinations = test.generate_all_combinations
    expect(possible_combinations.length).to eq(1296)
  end

	it "generates the right combinations" do
		possible_combinations = test.generate_all_combinations
		expect(possible_combinations).to include([1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 4], [3, 4, 5, 6], [6, 6, 6, 6])
  end

  it "converts integers to arrays" do
    expect(test.convert_colors_number_to_colors_array).to eq([1, 2, 3, 4, 5, 6])
  end

	it "generates a guess" do
    my_guess = test.generate_guess
    expect(my_guess.length).to eq(4)
	end

	it "compares two guesses" do
    my_first_guess = test.generate_guess
		my_second_guess = test.generate_guess
		my_comparison = test.compare_guesses(my_first_guess, my_second_guess)
		expect(my_comparison.length).to eq(2)
	end

end
