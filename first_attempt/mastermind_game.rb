class MastermindGame

	def initialize
		@colors = 0
		@rows = 0
		@possible_colors = {red: 1, blue: 2, green: 3, yellow: 4, purple: 5, orange: 6, violet: 7, indigo: 8}
	end

	def play_game
		welcome_user
		game_setup
		game_ai
	end

	private

	def welcome_user
		puts "Hello, welcome to Mastermind. In this game, you'll think up a sequence of colors, and I'll try to figure it out."
		let_user_select_the_number_of_colors
		let_user_select_the_number_of_rows
	end

	def let_user_select_the_number_of_colors
		puts "You can choose the number of possible colors available to our sequence." 
		while @colors < 2 || @colors > 8 || @color_answer != "y"
			puts "How many colors would you like to play with? (Pick a number between 2 and 8)"
			@colors = gets.chomp.to_i
				if @colors >= 2 && @colors <= 8
					puts "OK, great. Is it correct that you want to play with #{@colors} colors? (y/n)"
					@color_answer = gets.chomp
					@color_answer = @color_answer[0].downcase
				end
		end
		@color_answer = ""
	end

	def let_user_select_the_number_of_rows
		puts "You can also choose how long our sequence will be." 
		while @rows < 2 || @rows > 6 || @rows_answer != "y"
			puts "How long of a sequence do you want to play with? (Pick a number between 2 and 6)"
			@rows = gets.chomp.to_i
				if @rows >= 2 && @rows <= 6
					puts "Sounds good. So you want to play with #{@rows} rows? (y/n)"
					@rows_answer = gets.chomp
					@rows_answer = @rows_answer[0].downcase
				end
		end
		@rows_answer = ""
	end

	def game_setup
		generate_actual_colors_for_users_chosen_number_of_colors
		find_all_possible_combinations_of_colors_in_users_chosen_number_of_rows
        tell_user_game_is_about_to_begin
	end

	def generate_actual_colors_for_users_chosen_number_of_colors
		@possible_colors.keep_if {|key, value| value <= @colors}
	end

	def find_all_possible_combinations_of_colors_in_users_chosen_number_of_rows
		@possible_combinations = (1..@colors).to_a.repeated_permutation(@rows).to_a
	end

    def tell_user_game_is_about_to_begin
        puts "Alright, we're just about ready to play. Now you need to think up a secret code with #{@rows} rows."
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
		color_number_conversion
		puts "My first guess is " + @guess.to_s
		@turns = 1
		get_feedback_on_guess_from_user
	end

	def figure_out_the_secret_code
		until @black.to_i == @rows
			color_number_conversion
			@possible_combinations.keep_if do |x|
				compare_guess_to_remaining_options(@guess, x) == [@black.to_i, @white.to_i]
			end
			@guess = @possible_combinations[rand(@possible_combinations.length)]
			color_number_conversion
			puts "OK, my next guess is " + @guess.to_s
			@turns += 1
			get_feedback_on_guess_from_user
		end
	end

	def color_number_conversion
		if @guess[0].class == Fixnum
			@guess.each_with_index do |value, index|
				@guess[index] = @possible_colors.key(value).to_s
			end
		elsif @guess[0].class == String
			@guess.each_with_index do |value, index|
				@guess[index] = @possible_colors[value.to_sym]
			end
		end
	end


	def compare_guess_to_remaining_options(last_guess, possibility)
		blacks = 0
		whites = 0

		possible_white = []
		remaining_options = []

		last_guess.each_with_index do |value, index|
			if last_guess[index] == possibility[index]
				blacks += 1
			else
				possible_white << last_guess[index]
				remaining_options << possibility[index]
			end
		end

		possible_white.each do |value|
			if remaining_options.include? value
				whites += 1
				remaining_options.delete_at(remaining_options.index(value))
			end
		end

		[blacks,whites]
	end

	def get_feedback_on_guess_from_user
		while @double_check != "y"
			puts "How many of my picks are the correct color AND in the correct position?"
			@black = gets.chomp
				if @black.to_i == @rows
					puts "I won in #{@turns} turns!"
					break
				end
			puts "How many of my picks are the correct color in the incorrect position?"
			@white = gets.chomp
			puts "OK, so I have #{@black} picks with the correct color in the correct position, and #{@white} picks with the correct color in the incorrect position?"
			@double_check = gets.chomp
			@double_check = @double_check[0].downcase
		end
		@double_check = ""
	end


end

test = MastermindGame.new

test.play_game