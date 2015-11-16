require 'test/unit'

require '../lib/event_dispatcher'
require '../lib/display_board'
require '../lib/display_player'
require '../lib/display_game'
require '../lib/board'
require '../lib/player'
require '../lib/game'

require './mock_player'

class TestBoard < Test::Unit::TestCase
  def setup
    @size = 3
    @board = Board.new(@size)
    @player1 = MockPlayer.new(1, @board)
    @player2 = MockPlayer.new(2, @board)

    @player1.get_player_type
    @player2.get_player_type

    @player1.get_player_marker
    @player2.get_player_marker
  end

  def test_player_types
    assert_equal "n", @player1.player_type
    assert_equal "n", @player2.player_type
  end

  def test_num_markers
    assert_equal 2, @board.markers.length
  end

  def test_markers_unique
    assert_equal @board.board.uniq.length, @board.board.length
  end

  def test_first_move
    @player1.computer_move
    assert_equal @board.board[4], @player1.marker
  end
end
