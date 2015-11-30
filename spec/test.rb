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

  def test_game_not_tie_at_start
    assert_equal false, @board.tie?
  end

  def test_game_not_over_at_start
    assert_equal nil, @board.game_over?
  end

  def test_player_numbers
    assert_not_equal @player1.player_count_cb, @player2.player_count_cb
  end

  def test_player_types
    assert_equal "n", @player1.player_type
    assert_equal "n", @player2.player_type
  end

  def test_num_markers
    assert_equal 2, @board.markers.length
  end

  def test_spaces_unique
    assert_equal @board.board.uniq.length, @board.board.length
  end

  def test_markers_unique
    assert_not_equal @player1.marker, @player2.marker
  end

  def test_center_move
    @player1.computer_move
    refute_equal @board.board[4], @player1.marker

    @player2.computer_move
    refute_equal @board.board[4], @player2.marker

    @player1.computer_move
    assert_equal @board.board[4], @player1.marker
  end

  def test_corner_move
    @player1.computer_move
    @player2.computer_move
    c = @size

    corners = [@board.board[0], @board.board[c-1],
               @board.board[c*(c-1)], @board.board[(c*c)-1]]

    others = []
    @board.board.each do |s|
      if !@board.markers.include?(s) and s != "4"
        others << s
      end
    end

    assert_includes corners, @player2.marker
    refute_includes others, @player2.marker
  end

  def test_counter_move_on_diagonals
    pos = [0, 1, 2, 3, 5, 6, 7, 8]
    @board[4] = @player1.marker

    pos.each do |c|
      @board[c] = @player1.marker
      @player2.computer_move

      assert_equal @player2.marker, @board[8-c]
      assert_not_equal true, @board.win?

      @board[c] = c.to_s
      @board[8-c] = (8-c).to_s
    end
  end

  def get_row(row)
    pick = []
    0.upto(@size - 1) do |r|
      pick << @board[row * @size + r]
    end
    return pick
  end

  def fill_test_row(row, player=1)
    0.upto(@size - 2) do |r|
      if player == 1
        @board[row * @size + r] = @player1.marker
      else
        @board[row * @size + r] = @player2.marker
      end
    end
  end

  def reset_test_row(row, holder)
    0.upto(@size - 1) do |r|
      @board[row * @size + r] = holder[r]
    end
  end

  def get_col(col)
    pick = []
    0.upto(@size - 1) do |c|
      pick << @board[col + c * @size]
    end
    return pick
  end

  def fill_test_col(col, player=1)
    0.upto(@size - 2) do |c|
      if player == 1
        @board[col + c * @size] = @player1.marker
      else
        @board[col + c * @size] = @player2.marker
      end
    end
  end

  def reset_test_col(col, holder)
    0.upto(@size - 1) do |c|
      @board[col + c * @size] = holder[c]
    end
  end

  def test_counter_move_on_rows
    @board[4] = @player2.marker
    
    0.upto(@size - 1) do |t|
      row_holder = get_row(t)
      fill_test_row(t)

      @player2.computer_move
      test_row = get_row(t)

      0.upto(test_row.length - 2) do |e|
        assert_equal @player1.marker, test_row[e]
      end
      assert_equal @player2.marker, test_row[-1]
 
      reset_test_row(t, row_holder)
    end
  end

  def test_counter_move_on_columns
    @board[4] = @player2.marker

    0.upto(@size - 1) do |t|
      col_holder = get_col(t)
      fill_test_col(t)

      @player2.computer_move
      test_col = get_col(t)

      0.upto(test_col.length - 2) do |e|
        assert_equal @player1.marker, test_col[e]
      end
      assert_equal @player2.marker, test_col[-1]

      reset_test_col(t, col_holder)
    end
  end

  def test_three_move_victory
    0.upto(@size ** 2) do |e|
      @player1.computer_move
      @player1.computer_move
      @player1.computer_move
      assert_equal true, @board.win?
    end
  end

  def test_victory_move_on_diagonals
    pos = [0, 1, 2, 3, 5, 6, 7, 8]
    @board[4] = @player2.marker

    pos.each do |c|
      @board[c] = @player2.marker
      @player2.computer_move

      assert_equal @player2.marker, @board[8-c]
      assert_equal true, @board.win?

      @board[c] = c.to_s
      @board[8-c] = (8-c).to_s
    end
  end

  def test_victory_move_on_rows
    @board[4] = @player1.marker

    0.upto(@size - 1) do |t|
      row_holder = get_row(t)
      fill_test_row(t, 2)

      @player2.computer_move
      test_row = get_row(t)

      0.upto(test_row.length - 1) do |e|
        assert_equal @player2.marker, test_row[e]
      end

      reset_test_row(t, row_holder)
    end
  end

  def test_victory_move_on_columns
    @board[4] = @player1.marker

    0.upto(@size - 1) do |t|
      col_holder = get_col(t)
      fill_test_col(t, 2)

      @player2.computer_move
      test_col = get_col(t)

      0.upto(test_col.length - 1) do |e|
        assert_equal @player2.marker, test_col[e]
      end
      assert_equal @player2.marker, test_col[-1]

      reset_test_col(t, col_holder)
    end
  end

  def test_computer_vs_computer_ends_in_tie
    0.upto(100) do |t|
      new_board = Board.new(@size)
      @player1 = MockPlayer.new(1, new_board)
      @player2 = MockPlayer.new(2, new_board)

      @player1.get_player_type
      @player1.get_player_marker

      @player2.get_player_type
      @player2.get_player_marker

      0.upto(9) do |e|
        @player1.computer_move
        @player2.computer_move
        if @board.game_over?
          assert_equal("tie", new_board.victory_type, new_board.board)
        end
      end
    end
  end

  def test_computer_vs_computer_with_noncorner_first_move
    c = @size
    corners = ["0", (c-1).to_s, (c*(c-1)).to_s, ((c*c)-1).to_s]
    non_corners = []

    @board.board.each do |i|
      non_corners << i if corners.include?(i) == false
    end

    non_corners.each do |t|
      new_board = Board.new(@size)
      @player1 = MockPlayer.new(1, new_board)
      @player2 = MockPlayer.new(2, new_board)

      @player1.get_player_type
      @player1.get_player_marker

      @player2.get_player_type
      @player2.get_player_marker

      0.upto(8) do |e|
        new_board[t.to_i] = @player1.marker
        @player2.computer_move
        @player1.computer_move
        if @board.game_over?
          assert_equal("win", new_board.victory_type, new_board)
        end
      end
    end
  end

  def test_check_row
    0.upto(@size) do |t|
      assert_not_equal true, @player1.check_row(t, @player1.marker)
      assert_not_equal true, @player1.check_row(t, @player2.marker)
    end
  end

  def test_populated_row
    0.upto(@size - 1) do |t|
      @board.board[t + (@size * t)] = @player1.marker
    end

    0.upto(@size - 1) do |t|
      assert_equal true, @player1.check_row(t, @player1.marker)
    end
  end

  def test_populated_col
    0.upto(@size - 1) do |t|
      @board.board[t] = @player1.marker
    end

    0.upto(@size - 1) do |t|
      assert_equal true, @player1.check_col(t, @player1.marker)
    end
  end

  def test_check_col
    0.upto(@size) do |t|
      assert_not_equal true, @player1.check_col(t, @player1.marker)
      assert_not_equal true, @player1.check_col(t, @player2.marker)
    end
  end
end
