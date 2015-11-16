require './event_dispatcher'
require './display_board'
require './display_player'
require './display_game'
require './board'
require './player'
require './game'

game = Game.new
DisplayGame.new(game)

game.run_game
