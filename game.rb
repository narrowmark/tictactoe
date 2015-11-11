class Game
  include EventDispatcher

  def initialize
    @board = Board.new
    @player1 = Player.new(@board)
    @player2 = Player.new(@board)

    Display.new(@player1)
    Display.new(@player2)

    @player1.get_user_info
    @player2.get_user_info
  end

  def run_game
    system "clear" or system "cls"
    puts "Let's get this game started!\n"

    while true
      puts "\nPlayer 1's turn\n\n"
      @board.display_board
      @player1.move
      if @board.game_over?
        puts "Player 1 wins!" if @board.victory_type == "win"
        break
      end

      system "clear" or system "cls"
      puts "Player 2's turn\n\n"
      @board.display_board
      @player2.move
      if @board.game_over?
        puts "Player 2 wins!" if @board.victory_type == "win"
        break
      end
    end
  end
end
