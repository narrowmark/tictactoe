class Board
  include EventDispatcher

  attr_accessor :board
  attr_reader :board_size
  attr_accessor :markers
  attr_reader :victory_type
  attr_reader :center

  def initialize(size=3)
    setup_listeners

    @board_size = size
    @board = []

    @center = (@board_size ** 2 / 2) if @board_size % 2 != 0 

    0.upto(@board_size ** 2 - 1) do |p|
      @board << p.to_s
    end

    @markers = Array.new
  end

  def display_board
    notify(:display_board)
  end

  def get_row(row)
    b = @board
    row_pick = []
    0.upto(@board_size - 1) do |r|
      row_pick << b[row * @board_size + r]
    end
    return row_pick
  end

  def get_col(col)
    b = @board
    col_pick = []
    0.upto(@board_size - 1) do |c|
      col_pick << b[col + c * @board_size]
    end
    return col_pick
  end

  def top_diag
    b = @board
    diag_pick = []
    0.upto(@board_size - 1) do |d|
      diag_pick << b[d * (@board_size + 1)]
    end
    return diag_pick
  end

  def bot_diag
    b = @board
    diag_pick = []
    1.upto(@board_size) do |d|
      diag_pick << b[(@board_size - 1) * d]
    end
    return diag_pick
  end

  def win?
    0.upto(@board_size - 1) do |t|
      if get_row(t).uniq.length == 1 ||
         get_col(t).uniq.length == 1
        return true
      end
    end

    if top_diag.uniq.length == 1 ||
       bot_diag.uniq.length == 1
      return true
    end
  end

  def tie?
    @board.all? { |s| s == "#{@markers[0]}" || s == "#{@markers[1]}" }
  end

  def game_over?
    @victory_type = nil
    if win?
      notify(:game_over)
      display_board
      @victory_type = "win"
      return true
    elsif tie?
      notify(:tie)
      display_board
      @victory_type = "tie"
      return true
    else
    end
  end

  def [](x)
    @board[x]
  end

  def []=(x, value)
    @board[x] = value
  end
end
