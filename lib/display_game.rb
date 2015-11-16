class DisplayGame
  def initialize(game)
    writer = Writer

    game.subscribe(:start) {
      writer.clear_screen
      writer.announce_start
    }

    game.subscribe(:player_1_turn) {
      writer.turn(1)
    }

    game.subscribe(:player_2_turn) {
      writer.clear_screen
      writer.turn(2)
    }

    game.subscribe(:player_1_win) {
      writer.announce_win(1)
    }

    game.subscribe(:player_2_win) {
      writer.announce_win(2)
    }
  end

  class Writer
    def self.clear_screen
      system "clear" or system "cls"
    end

    def self.announce_start(o_stream=$stdout)
      o_stream.print "Let's get this game started!\n\n"
    end

    def self.turn(player_num, o_stream=$stdout)
      o_stream.print "\nPlayer #{player_num}'s turn\n\n\n"
    end

    def self.announce_win(player_num, o_stream=$stdout)
      o_stream.print "\nPlayer #{player_num} wins!\n"
    end
  end
end
