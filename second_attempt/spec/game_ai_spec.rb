require 'game_ai'

describe GameAI do
  let(:test) {described_class.new(6, 4)}

  it "generates all possible combinations" do
    expect(test.generate_all_combinations.length).to eq(1296)
  end

end
