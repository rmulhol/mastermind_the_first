require 'game_ai'

describe GameAI do
  let(:test) {described_class.new(6, 4)}

  describe '#generate_all_combinations' do
    it "generates the proper number of combinations" do
      possible_combinations = test.generate_all_combinations
      expect(possible_combinations.length).to eq(1296)
    end

    it "generates the right combinations" do
      possible_combinations = test.generate_all_combinations
      expect(possible_combinations).to include([1, 1, 1, 1], [1, 1, 2, 2], [1, 2, 3, 4], [3, 4, 5, 6], [6, 6, 6, 6])
    end
	end

	describe '#convert_colors_number_to_colors_array' do
    it "converts integers to arrays" do
      expect(test.convert_colors_number_to_colors_array).to eq([1, 2, 3, 4, 5, 6])
    end
	end

	describe '#generate_guess' do
	  it "generates a guess" do
      my_guess = test.generate_guess
      expect(my_guess.length).to eq(4)
  	end
	end

	describe '#same_color_same_position' do
  	it "correctly identifies 0 black pegs when all pegs are different" do
      expect(test.same_color_same_position([0, 0, 0, 0], [1, 1, 1, 1])).to eq(0)
		end	 

		it "correctly identifies 1 black peg when the first pegs are both 0" do
      expect(test.same_color_same_position([0, 0, 0, 0], [0, 1, 1, 1])).to eq(1)
		end
		
		it "correctly identifies 1 black peg when the second pegs are both 0" do
      expect(test.same_color_same_position([0, 0, 0, 0], [1, 0, 1, 1])).to eq(1)
		end
		
		it "correctly identifies 1 black peg when the second pegs are both 1" do
      expect(test.same_color_same_position([1, 0, 0, 0], [1, 1, 1, 1])).to eq(1)
		end

		it "correctly identifies 2 black pegs when the first and second pegs are both 1" do
      expect(test.same_color_same_position([1, 1, 0, 0], [1, 1, 1, 1])).to eq(2)
		end

		it "correctly identifies 4 black pegs when all pegs are 6" do
      expect(test.same_color_same_position([6, 6, 6, 6], [6, 6, 6, 6])).to eq(4)
		end
	end

  describe "#same_color" do
		it "correctly identifies 0 same-color pegs when all pegs are different" do
			expect(test.same_color([0, 0, 0, 0], [1, 1, 1, 1])).to eq(0)
		end

		it "correctly identifies 1 same-color peg" do
			expect(test.same_color([1, 0, 0, 0], [1, 1, 1, 1])).to eq(1)
		end

		it "correctly identifies 1 same-color peg" do
			expect(test.same_color([1, 1, 1, 0], [1, 2, 2, 2])).to eq(1)
		end
    
		it "correctly identifies 2 same-color pegs" do
			expect(test.same_color([1, 1, 1, 2], [1, 2, 2, 2])).to eq(2)
		end
		
		it "correctly identifies 2 same-color pegs" do
			expect(test.same_color([3, 3, 0, 0], [3, 3, 3, 3])).to eq(2)
		end

    it "correctly identifies 3 same-color pegs" do
			expect(test.same_color([1, 1, 1, 0], [1, 1, 1, 1])).to eq(3)
		end

    it "correctly identifies 3 same-color pegs" do
			expect(test.same_color([1, 1, 1, 2], [1, 2, 2, 1])).to eq(3)
		end
		
		it "correctly identifies 4 same-color pegs when all pegs are the same" do
			expect(test.same_color([1, 1, 1, 1], [1, 1, 1, 1])).to eq(4)
		end
	end

	describe "#get_feedback" do
		it "correctly identifies 0 black pegs and 0 same color pegs" do
			expect(test.get_feedback([0, 0, 0, 0], [1, 1, 1, 1])).to eq([0, 0])
		end

    it "correctly identifies 1 black peg and 0 same color pegs" do
			expect(test.get_feedback([0, 0, 0, 0], [0, 1, 1, 1])).to eq([1, 0])
		end

		it "correctly identifies 2 black pegs and 0 same color pegs" do
			expect(test.get_feedback([0, 0, 0, 0], [0, 0, 1, 1])).to eq([2, 0])
		end

		it "correctly identifies 0 black pegs and 1 same color peg" do
			expect(test.get_feedback([0, 0, 1, 0], [1, 2, 2, 2])).to eq([0, 1])
		end

		it "correctly identifies 0 black pegs and 2 same color pegs" do
			expect(test.get_feedback([0, 1, 1, 0], [1, 2, 2, 1])).to eq([0, 2])
		end

		it "correctly identifies 1 black peg and 1 white peg" do
			expect(test.get_feedback([1, 2, 3, 4], [1, 5, 6, 2])).to eq([1, 1])
		end

		it "correctly identifies 2 black pegs and 2 white pegs" do
			expect(test.get_feedback([1, 2, 3, 4], [2, 1, 3, 4])).to eq([2, 2])
		end
  end
end
