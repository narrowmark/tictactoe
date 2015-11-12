require 'test/unit'

require './event_dispatcher'
require './board'

class StartTest < Test::Unit::TestCase
  def setup
    @size = 3
    @board = Board.new(@size)
  end

  def test_board_size
    assert_equal @size, @board.board_size
  end

  def test_board_dimensions
    assert_equal @board.board_size ** 2, @board.board.length
  end
end
