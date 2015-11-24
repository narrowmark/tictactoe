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
    puts "Board markers", @board.markers
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
      elsif best_move_found = as == @board.center.to_s
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

        included = ->(corner_number) {
          return available_spaces.include?(corners[corner_number])
        }

        if check_bot_row && check_left_col
          puts "bottom left"
          if included.call(2)
            corner = corners[2]
          elsif included.call(0)
            corner = corners[0]
          end
        elsif check_bot_row && check_right_col
          puts "bottom right"
          if included.call(3)
            corner = corners[3]
          elsif included.call(1)
            corner = corners[1]
          end
        elsif check_top_row && check_left_col
          puts "top left"
          if included.call(0)
            corner = corners[0]
          elsif included.call(2)
            corner = corners[2]
          end
        elsif check_top_row && check_right_col
          puts "top right"
          if included.call(1)
            corner = corners[1]
          elsif included.call(3)
            corner = corners[3]
          end
        else
          if check_top_row
            top_corners = available_spaces & [corners[0], corners[1]]
            corner = top_corners.sample
          elsif check_bot_row
            bot_corners = available_spaces & [corners[2], corners[3]]
            corner = bot_corners.sample
          elsif check_left_col
            left_corners = available_spaces & [corners[0], corners[2]]
            corner = left_corners.sample
          elsif check_right_col
            right_corners = available_spaces & [corners[1], corners[3]]
            corner = right_corners.sample
          end
        end
      end

      if corner != 1 && corner != nil
        notify(:corner, corner)
        best_moved_found = true
        @board[corner.to_i] = @marker
      else
        n = available_spaces.sample.to_i
        notify(:random, n)
        @board[n] = @marker
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
