class Board
  include EventDispatcher

  attr_accessor :board
  attr_accessor :markers
  attr_reader :victory_type

  def initialize
    @board_side = 3
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @markers = Array.new
  end

  def display_board
    puts_row = ->(row) {
      0.upto(@board_side-1) do |r|
        print "|_#{@board[row * @board_side + r]}_"
      end
        puts "|"
    }

    0.upto(@board_side-1) do |c|
      puts_row.call(c)
    end
  end

  def win?
    b = @board
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie?
    @board.all? { |s| s == "#{@markers[0]}" || s == "#{@markers[1]}" }
  end

  def game_over?
    @victory_type = nil
    if win?
      system "clear" or system "cls"
      puts "Game over!\n"
      display_board
      @victory_type = "win"
      return true
    elsif tie?
      system "clear" or system "cls"
      puts "It's a tie!\n"
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
