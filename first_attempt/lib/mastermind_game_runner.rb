require './mastermind_game.rb'

new_game = MastermindGame.new(CommandLineDisplay.new, GameAI.new)

new_game.play_game