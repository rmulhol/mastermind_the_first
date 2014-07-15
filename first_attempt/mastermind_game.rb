class MastermindGame

	def initialize
		@colors = 6
		@rows = 4
		@possible_colors = {red: 1, blue: 2, green: 3, yellow: 4, purple: 5, orange: 6, violet: 7, indigo: 8}
		@double_check = ""
		@correct_color_and_correct_placement = ""
		@correct_color_and_incorrect_placement = ""
	end

	def play_game
		welcome_user
		game_setup
		tell_user_game_is_about_to_begin
		game_ai
	end

	private

	def welcome_user
		puts "Hello, welcome to Mastermind. In this game, you'll think up a sequence of colors, and I'll try to figure it out."
	end

	def game_setup
		generate_actual_colors_for_users_chosen_number_of_colors
		find_all_possible_combinations_of_colors_in_users_chosen_number_of_rows
	end

	def generate_actual_colors_for_users_chosen_number_of_colors
		@possible_colors.keep_if {|key, value| value <= @colors}
	end

	def find_all_possible_combinations_of_colors_in_users_chosen_number_of_rows
		@possible_combinations = (1..@colors).to_a.repeated_permutation(@rows).to_a
	end

	def tell_user_game_is_about_to_begin
		puts "In order to play, you need to think up a secret code with #{@rows} spots."
		puts "The colors you can choose from are: "
		@possible_colors.each do |key, value|
			puts "- #{key} "
		end
		puts "Hit enter when you're ready for my first guess!"
		ready = gets.chomp
	end

	def game_ai
		provide_first_guess_to_the_user
		figure_out_the_secret_code
	end

	def provide_first_guess_to_the_user
		@guess = @possible_combinations[rand(@possible_combinations.length)]
		color_number_conversion(@guess)
		puts "My first guess is " + @guess.to_s
		@turns = 1
		get_feedback_on_guess_from_user
	end

	def figure_out_the_secret_code
		until @correct_color_and_correct_placement.to_i == @rows
			color_number_conversion(@guess)
			@possible_combinations.keep_if do |possible_combination|
				compare_guess_to_remaining_options(@guess, possible_combination) == [@correct_color_and_correct_placement.to_i, @correct_color_and_incorrect_placement.to_i]
			end
			if @possible_combinations.empty?
				puts "Hmm. Seems like I've run out of possible guesses. Would you like to restart my guessing sequence with the same guess? (y/n)"
				response = gets.chomp
				if response[0] == "y" || response[0] == "Y"
					puts "OK! Restarting from the beginning!"
					game_setup
					game_ai
				end
				abort("Sorry it didn't work out this time. Hope to play again soon.") if response[0] != "y" && response[0] != "Y"
			end
			@guess = @possible_combinations[rand(@possible_combinations.length)]
			color_number_conversion(@guess)
			puts "OK, my next guess is " + @guess.to_s
			@turns += 1
			get_feedback_on_guess_from_user
		end
	end

	def color_number_conversion(guess)
		if guess[0].class == Fixnum
			guess.each_with_index do |value, index|
				guess[index] = @possible_colors.key(value).to_s
			end
		elsif guess[0].class == String
			guess.each_with_index do |value, index|
				guess[index] = @possible_colors[value.to_sym]
			end
		end
	end


	def compare_guess_to_remaining_options(last_guess, possibility)
		correct_color_and_placement = 0
		correct_color_and_incorrect_placement = 0
		possible_correct_color_but_incorrect_placement = []
		remaining_options = []
		last_guess.each_with_index do |value, index|
			if last_guess[index] == possibility[index]
				correct_color_and_placement += 1
			else
				possible_correct_color_but_incorrect_placement << last_guess[index]
				remaining_options << possibility[index]
			end
		end
		possible_correct_color_but_incorrect_placement.each do |value|
			if remaining_options.include? value
				correct_color_and_incorrect_placement += 1
				remaining_options.delete_at(remaining_options.index(value))
			end
		end
		[correct_color_and_placement,correct_color_and_incorrect_placement]
	end

	def get_feedback_on_guess_from_user
		until @double_check[0] == "y" || @double_check[0] == "Y"
			get_feedback_from_user_on_correct_color_and_correct_placement
			get_feedback_from_user_on_correct_color_and_incorrect_placement
			if @correct_color_and_correct_placement.to_i == (@rows - 1) && @correct_color_and_incorrect_placement.to_i == 1
				error_message
				get_feedback_on_guess_from_user
			end
			puts "OK, so I have #{@correct_color_and_correct_placement} picks with the correct color in the correct position, and #{@correct_color_and_incorrect_placement} picks with the correct color in the incorrect position? (y/n)"
			@double_check = gets.chomp
		end
		@double_check = ""
	end

	def get_feedback_from_user_on_correct_color_and_correct_placement
		puts "How many of my picks are in the correct color and in the correct position? (0-#{@rows})"
		@correct_color_and_correct_placement = gets.chomp
		if @correct_color_and_correct_placement.to_i < 0 || @correct_color_and_correct_placement.to_i > @rows
			error_message
			get_feedback_from_user_on_correct_color_and_correct_placement
		elsif @correct_color_and_correct_placement.to_i == 0 && @correct_color_and_correct_placement.strip != "0"
			error_message
			get_feedback_from_user_on_correct_color_and_correct_placement
		end
		abort("I figured out your code in #{@turns} turns!") unless @correct_color_and_correct_placement.to_i != @rows
	end

	def get_feedback_from_user_on_correct_color_and_incorrect_placement
		puts "How many of my picks are the correct color but in the incorrect placement? (0-#{@rows})"
		@correct_color_and_incorrect_placement = gets.chomp
		if @correct_color_and_incorrect_placement.to_i < 0 || @correct_color_and_incorrect_placement.to_i > @rows
			error_message
			get_feedback_from_user_on_correct_color_and_incorrect_placement
		elsif @correct_color_and_incorrect_placement.to_i == 0 && @correct_color_and_incorrect_placement.strip != "0"
			error_message
			get_feedback_from_user_on_correct_color_and_incorrect_placement
		end
	end

	def error_message
		puts "Oops! That's not a valid response. Try again."
	end

end

test = MastermindGame.new

test.play_game


