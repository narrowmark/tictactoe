class DisplayBoard
  attr_accessor :writer

  def initialize(board)
    @writer = Writer

    board.subscribe(:display_board) {
      @writer.write_board(board)
    }

    board.subscribe(:game_over) {
      @writer.clear_screen
      @writer.announce_end
    }

    board.subscribe(:tie) {
      @writer.clear_screen
      @writer.announce_tie
    }
  end

  class Writer
    def self.clear_screen
      system "clear" or system "cls"
    end

    def self.announce_end(o_stream=$stdout)
      o_stream.puts "Game over!\n"
    end

    def self.announce_tie(o_stream=$stdout)
      o_stream.puts "It's a tie!\n"
    end

    def self.write_board(board, o_stream=$stdout)
      puts_row = ->(row) {
        0.upto(board.board_size-1) do |r|
          o_stream.print "|_#{board.board[row * board.board_size + r]}_"
        end
          o_stream.puts "|"
      }

      0.upto(board.board_size-1) do |c|
        puts_row.call(c)
      end
    end
  end
end
