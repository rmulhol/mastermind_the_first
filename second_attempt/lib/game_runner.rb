require './mastermind_game.rb'
require './command_line_display.rb'
require './game_ai.rb'

new_game = MastermindGame.new(logic: GameAI.new, display: CommandLineDisplay.new)

new_game.play_game
