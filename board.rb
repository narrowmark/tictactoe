class Board
  include EventDispatcher

  attr_accessor :board
  attr_reader :board_size
  attr_accessor :markers
  attr_reader :victory_type

  def initialize(size=3)
    @board_size = size
    @board = []
    0.upto(@board_size ** 2 - 1) do |p|
      @board << p.to_s
    end
    @markers = Array.new
    puts "#{@board}"
  end

  def display_board
    puts_row = ->(row) {
      0.upto(@board_size-1) do |r|
        print "|_#{@board[row * @board_size + r]}_"
      end
        puts "|"
    }

    0.upto(@board_size-1) do |c|
      puts_row.call(c)
    end
  end

  def win?
    b = @board
    # Does not like calls to b[row * @board_size + ]
    # 37:in `*': nil can't be coerced into Fixnum (TypeError)
    # Figure it out later.
=begin
    row_pick = []
    get_row = ->(row) {
      row_pick = []
      0.upto(@board_side-1) do |r|
        puts "#{b[row * @board_size + r]}"
        # row_pick << b[row * @board_size + r]
      end
    }

    test = get_row.call(0)
    puts "#{test}"
=end
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
