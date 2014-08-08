
require './spec_helper.rb'
require '../lib/mastermind_game.rb'

describe GameAI do
  let(:test_run) {described_class.new}
  
  it "generates all 1296 possible combinations" do
    expect(test_run.find_all_possible_combinations_of_colors(6,4).length).to eq(1296)
  end

  it "correctly compares arrays" do
    expect(test_run.compare_guess_to_remaining_options([0,1,2,3],[1,1,4,2])).to eq([1,1])
  end

end


