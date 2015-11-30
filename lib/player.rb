class Player
  include EventDispatcher

  attr_accessor :player_count_cb
  attr_accessor :player_type
  attr_accessor :marker
  attr_accessor :other_marker
  attr_accessor :board

  @@player_count = 0

  def initialize(board)
    setup_listeners
    @@player_count += 1

    @player_count_cb = @@player_count
    @marker_selected = false

    @board = board
  end

  def get_player_type
    notify(:player_type)
  end

  def get_marker
    notify(:player_marker)
    @board.markers << @marker
  end

  def get_other_marker
    @other_marker = nil
    if @player_count_cb == 2
      @other_marker = @board.markers[0]
    else
      @other_marker = @board.markers[1]
    end
  end

  def move
    if @player_type == "y"
      human_move
    else
      computer_move
    end
  end

  def human_move
    notify(:make_move)
  end

  def computer_move
    available_spaces = []
    best_move_found = nil

    @board.board.each do |s|
      if !@board.markers.include?(s)
        available_spaces << s
      end
    end

    available_spaces.each do |as|
      if best_move_found = winning_move?(@board, as, @marker)
        notify(:victory, as)
        @board[as.to_i] = @marker
        break
      elsif best_move_found = winning_move?(@board, as, other_marker)
        notify(:victory, as)
        @board[as.to_i] = @marker
        break
      elsif best_move_found = as == @board.center.to_s && @corner_used == true
        notify(:center, as)
        @board[as.to_i] = @marker
        break
      else
        best_move_found = nil
        @board[as.to_i] = as
      end
    end

    if !best_move_found
      c = @board.board_size
      corners = ["0", (c-1).to_s, (c*(c-1)).to_s, ((c*c)-1).to_s]
      corner = 1

      om = @other_marker
      unless (available_spaces & corners).length == 0
        selection_made = 0
        check_top_row = check_row(0, om)
        check_bot_row = check_row(@board.board_size - 1, om)
        check_left_col = check_col(0, om)
        check_right_col = check_col(@board.board_size - 1, om)

        top_corners = available_spaces & [corners[0], corners[1]]
        bottom_corners = available_spaces & [corners[2], corners[3]]
        left_corners = available_spaces & [corners[0], corners[2]]
        right_corners = available_spaces & [corners[1], corners[3]]

        included = ->(corner_number) {
          return available_spaces.include?(corners[corner_number])
        }

        pair_corners = ->(a, z) {
          if included.call(a)
            return corners[a]
          elsif included.call(z)
            return corners[z]
          end
        }

        if check_top_row
          if check_top_diag(om)
            corner = pair_corners.call(3, 2)
          elsif check_left_col
            corner = pair_corners.call(0, 3)
          elsif check_right_col
            corner = pair_corners.call(2, 0)
          else
            corner = bottom_corners.sample
          end
        elsif check_bot_row
          if check_bot_diag(om)
            corner = pair_corners.call(0, 2)
          elsif check_left_col
            corner = pair_corners.call(2, 0)
          elsif check_right_col
            corner = pair_corners.call(0, 3)
          else
            corner = top_corners.sample
          end
        elsif check_left_col
          corner = right_corners.sample
        elsif check_right_col
          corner = left_corners.sample
        else
          corner = (available_spaces & corners).sample
        end
      end

      if corner != 1 && corner != nil
        notify(:corner, corner)
        best_moved_found = true
        @board[corner.to_i] = @marker
        @corner_used = true
      else
        n = available_spaces.sample.to_i
        notify(:random, n)
        @board[n.to_i] = @marker
      end
    end
  end

  def check_row(row, marker)
    if @board.get_row(row).include?(marker)
      return true
    end
  end

  def check_col(col, marker)
    if @board.get_col(col).include?(marker)
      return true
    end
  end

  def check_top_diag(marker)
    if @board.top_diag.include?(marker)
      return true
    end
  end

  def check_bot_diag(marker)
    if @board.bot_diag.include?(marker)
      return true
    end
  end

  def winning_move?(board, choice, next_player)
    winning_move = nil
    board[choice.to_i] = next_player
    if @board.win?
      winning_move = choice.to_i
      board[choice.to_i] = choice
      return winning_move
    end
  end
end
