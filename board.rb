class Board
  include EventDispatcher

  attr_accessor :board
  attr_reader :board_size
  attr_accessor :markers
  attr_reader :victory_type

  def initialize(size=3)
    setup_listeners

    @board_size = size
    @board = []

    0.upto(@board_size ** 2 - 1) do |p|
      @board << p.to_s
    end

    @markers = Array.new
  end

  def display_board
    notify(:display_board)
  end

  def win?
    b = @board
    get_row = ->(row) {
      row_pick = []
      0.upto(@board_size - 1) do |r|
        row_pick << b[row * @board_size + r]
      end
      return row_pick
    }

    get_col = ->(col) {
      col_pick = []
      0.upto(@board_size - 1) do |c|
        col_pick << b[col + c * @board_size]
      end
      return col_pick
    }

    top_diag = lambda {
      diag_pick = []
      0.upto(@board_size - 1) do |d|
        diag_pick << b[d * (@board_size + 1)]
      end
      return diag_pick
    }

    bot_diag = lambda {
      diag_pick = []
      1.upto(@board_size) do |d|
        diag_pick << b[(@board_size - 1) * d]
      end
      return diag_pick
    }

    puts "diag_pick: #{bot_diag.call()}"

    0.upto(@board_size - 1) do |t|
      if get_row.call(t).uniq.length == 1 ||
         get_col.call(t).uniq.length == 1
        return true
      end
    end

    if top_diag.call().uniq.length == 1 ||
       bot_diag.call().uniq.length == 1
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
