class DisplayGame
  def initialize(game)
    game.subscribe(:start) {
      system "clear" or system "cls"
      puts "Let's get this game started!\n"
    }

    game.subscribe(:player_1_turn) {
      puts "\nPlayer 1's turn\n\n"
    }

    game.subscribe(:player_2_turn) {
      system "clear" or system "cls"
      puts "\nPlayer 2's turn\n\n"
    }

    game.subscribe(:player_1_win) {
      puts "Player 1 wins!"
    }

    game.subscribe(:player_2_win) {
      puts "Player 2 wins!"
    }
  end
end
