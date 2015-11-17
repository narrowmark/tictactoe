require 'test/unit'

require '../lib/event_dispatcher'
require '../lib/display_board'
require '../lib/display_player'
require '../lib/display_game'
require '../lib/board'
require '../lib/player'
require '../lib/game'

class TestInitBoard < Test::Unit::TestCase
  def setup
    @size = 3
    @board = Board.new(@size)
  end

  def test_board_size
    assert_equal @size, @board.board_size
  end

  def test_board_elements_are_strings
    @board.board.each do |e|
      assert_kind_of String, e
    end
  end

  def test_corners
    assert_equal "0", @board.board[0]
    assert_equal (@size - 1).to_s, @board.board[@size - 1]
    assert_equal (@size * (@size - 1)).to_s, @board[@size * (@size - 1)]
    assert_equal ((@size * @size) - 1).to_s, @board[(@size * @size) - 1]
  end

  def test_first_element_is_zero
    assert_equal @size**2, @board.board.length
    assert_equal "0", @board.board[0]
  end

  def test_last_element
    last_element = @size * @size - 1
    assert_equal last_element.to_s, @board[-1]
  end

  def test_markers_empty_at_start
    assert_equal [], @board.markers
  end

  def test_game_not_tie_at_start
    assert_equal false, @board.tie?
  end

  def test_game_not_over_at_start
    assert_equal nil, @board.game_over?
  end
end
