require './lib/mastermind_game.rb'
require './lib/game_ai.rb'
require './lib/command_line_display.rb'

new_game = MastermindGame.new(CommandLineDisplay.new, GameAI.new)

new_game.play_game