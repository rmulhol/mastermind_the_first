class MastermindGame
  
  attr_accessor :number_of_rows
	
  def initialize
    @number_of_rows = 4
	end

	def offer_first_guess
    first_guess = []
		(1..number_of_rows).to_a.each do |number|
      first_guess << number
		end
		first_guess
	end

  def get_feedback
  end

end
