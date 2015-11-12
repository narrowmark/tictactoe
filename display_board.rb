class DisplayBoard
  def initialize(board)
    board.subscribe(:display_board) {
      puts_row = ->(row) {
        0.upto(board.board_size-1) do |r|
          print "|_#{board.board[row * board.board_size + r]}_"
        end
          puts "|"
      }

      0.upto(board.board_size-1) do |c|
        puts_row.call(c)
      end
    }

    board.subscribe(:game_over) {
      system "clear" or system "cls"
      puts "Game over!\n"
    }
    board.subscribe(:tie) {
      system "clear" or system "cls"
      puts "It's a tie!\n"
    }
  end
end

