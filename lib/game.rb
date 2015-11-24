class Game
  include EventDispatcher

  def initialize
    setup_listeners

    @board = Board.new
    @player1 = Player.new(@board)
    @player2 = Player.new(@board)

    DisplayPlayer.new(@player1)
    DisplayPlayer.new(@player2)
    DisplayBoard.new(@board)

    @player1.get_player_type
    @player1.get_marker

    @player2.get_player_type
    @player2.get_marker

    @player1.get_other_marker
    @player2.get_other_marker
  end

  def run_game
    notify(:start)

    while true
      notify(:player_1_turn)
      @board.display_board
      @player1.move
      if @board.game_over?
        notify(:player_1_win) if @board.victory_type == "win"
        break
      end

      notify(:player_2_turn)
      @board.display_board
      @player2.move
      if @board.game_over?
        notify(:player_2_win) if @board.victory_type == "win"
        break
      end
    end
  end
end
