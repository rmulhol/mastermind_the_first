require 'game_ai'

describe GameAI do
  let(:test) {described_class.new }

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

  describe '#generate_guess' do
    it "generates a guess" do
      possible_combinations = test.generate_all_combinations
      my_guess = test.generate_guess(possible_combinations)
      expect(my_guess.length).to eq(4)
    end
  end

  describe '#same_color_same_position' do
    it "correctly identifies 0 black pegs when all pegs are different" do
      expect(test.same_color_same_position([1, 1, 1, 1], [2, 2, 2, 2])).to eq(0)
    end  

    it "correctly identifies 1 black peg when the first pegs are both 1" do
      expect(test.same_color_same_position([1, 1, 1, 1], [1, 2, 2, 2])).to eq(1)
    end
    
    it "correctly identifies 1 black peg when the second pegs are both 1" do
      expect(test.same_color_same_position([1, 1, 1, 1], [2, 1, 2, 2])).to eq(1)
    end
    
    it "correctly identifies 2 black pegs when the first and second pegs are both 1" do
      expect(test.same_color_same_position([1, 1, 2, 2], [1, 1, 1, 1])).to eq(2)
    end

    it "correctly identifies 4 black pegs when all pegs are 6" do
      expect(test.same_color_same_position([6, 6, 6, 6], [6, 6, 6, 6])).to eq(4)
    end
  end

  describe "#same_color" do
    it "correctly identifies 0 same-color pegs when all pegs are different" do
      expect(test.same_color([1, 1, 1, 1], [2, 2, 2, 2])).to eq(0)
    end

    it "correctly identifies 1 same-color peg" do
      expect(test.same_color([1, 2, 2, 2], [1, 1, 1, 1])).to eq(1)
    end

    it "correctly identifies 1 same-color peg when the first array contains three of an element and the second array contains one" do
      expect(test.same_color([1, 1, 1, 3], [1, 2, 2, 2])).to eq(1)
    end
    
    it "correctly identifies 2 same-color pegs" do
      expect(test.same_color([3, 3, 1, 1], [3, 3, 3, 3])).to eq(2)
    end

    it "correctly identifies 2 same-color pegs when the first array contains one of an element and the second array contains three" do
      expect(test.same_color([1, 1, 1, 2], [1, 2, 2, 2])).to eq(2)
    end

    it "correctly identifies 3 same-color pegs" do
      expect(test.same_color([1, 1, 1, 2], [1, 1, 1, 1])).to eq(3)
    end

    it "correctly identifies 3 same-color pegs when the first array contains one of an element and the second array contains two" do
      expect(test.same_color([1, 1, 1, 2], [1, 2, 2, 1])).to eq(3)
    end
    
    it "correctly identifies 4 same-color pegs when all pegs are the same" do
      expect(test.same_color([1, 1, 1, 1], [1, 1, 1, 1])).to eq(4)
    end
  end

  describe "#get_feedback" do
    it "correctly identifies 0 black pegs and 0 same color pegs" do
      expect(test.get_feedback([1, 1, 1, 1], [2, 2, 2, 2])).to eq([0, 0])
    end

    it "correctly identifies 1 black peg and 0 same color pegs" do
      expect(test.get_feedback([1, 1, 1, 1], [1, 2, 2, 2])).to eq([1, 0])
    end

    it "correctly identifies 2 black pegs and 0 same color pegs" do
      expect(test.get_feedback([1, 1, 1, 1], [1, 1, 2, 2])).to eq([2, 0])
    end

    it "correctly identifies 0 black pegs and 1 same color peg" do
      expect(test.get_feedback([2, 2, 1, 2], [1, 3, 3, 3])).to eq([0, 1])
    end

    it "correctly identifies 0 black pegs and 2 same color pegs" do
      expect(test.get_feedback([2, 1, 1, 2], [3, 2, 2, 3])).to eq([0, 2])
    end

    it "correctly identifies 1 black peg and 1 white peg" do
      expect(test.get_feedback([1, 2, 3, 4], [1, 5, 6, 2])).to eq([1, 1])
    end

    it "correctly identifies 2 black pegs and 2 white pegs" do
      expect(test.get_feedback([1, 2, 3, 4], [2, 1, 3, 4])).to eq([2, 2])
    end
  end

  describe "#is_a_possible_combination" do
    it "keeps possible combination with four black pegs and four of the same pegs" do
      expect(test.is_a_possible_combination?([1, 1, 1, 1], [4, 0], [1, 1, 1, 1])).to be_truthy
    end

    it "rejects possible combination with four black pegs and four different pegs" do
      expect(test.is_a_possible_combination?([1, 1, 1, 1], [4, 0], [2, 2, 2, 2])).to be_falsey
    end

    it "keeps possible combination with three black pegs and three shared pegs" do
      expect(test.is_a_possible_combination?([1, 1, 1, 3], [3, 0], [1, 1, 1, 2])).to be_truthy
    end

    it "rejects possible combination with three black pegs but only two shared pegs" do
      expect(test.is_a_possible_combination?([1, 1, 1, 3], [3, 0], [1, 1, 2, 2])).to be_falsey
    end
  end

  describe "#reduce_remaining_combinations" do
    it "correctly reduces to one combination with 4 black pegs and four 1 pegs" do
      possible_combinations = test.generate_all_combinations
      expect(test.reduce_remaining_combinations([1, 1, 1, 1], [4, 0], possible_combinations)).to eq([[1, 1, 1, 1]])
    end

    it "correctly reduces to one combination with 4 black pegs and four 2 pegs" do
      possible_combinations = test.generate_all_combinations
      expect(test.reduce_remaining_combinations([2, 2, 2, 2], [4, 0], possible_combinations)).to eq([[2, 2, 2, 2]])
    end

    it "correctly reduces to two combinations with 3 black pegs" do
      expect(test.reduce_remaining_combinations([1, 1, 1, 1], [3, 0], [[1, 1, 1, 2], [1, 1, 1, 3], [1, 2, 3, 4]])).to eq([[1, 1, 1, 2], [1, 1, 1, 3]])
    end

    it "correctly reduces to one combination with 1 black peg" do
      expect(test.reduce_remaining_combinations([1, 1, 1, 1], [1, 0], [[1, 1, 1, 2], [1, 1, 1, 3], [1, 2, 3, 4]])).to eq([[1, 2, 3, 4]])
    end
  end
end
