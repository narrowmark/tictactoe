class Player
  include EventDispatcher

  attr_accessor :player_count_cb
  attr_accessor :player_type
  attr_accessor :marker
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
      if best_move_found = winning_move?(@board, as, @board.markers[1])
        notify(:victory, as)
        @board[as.to_i] = @marker
        break
      elsif best_move_found = winning_move?(@board, as, @board.markers[0])
        notify(:victory, as)
        @board[as.to_i] = @marker
        break
      elsif best_move_found = as == "4"
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
      unless (available_spaces & corners).length == 0
        corner = available_spaces.sample until corner.to_i.even?
      end

      if corner != 1
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
