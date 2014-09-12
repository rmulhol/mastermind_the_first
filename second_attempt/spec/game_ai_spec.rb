require '../lib/game_ai.rb'

describe GameAI do
  let(:test) {described_class.new}

  it "generates all possible combinations" do
    expect(test.generate_all_combinations.length).to eq(test.number_of_colors ** test.number_of_rows)
  end

end
