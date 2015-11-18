class DisplayPlayer
  def initialize(player)
    writer = Writer
    reader = Reader

    player.subscribe(:player_type) {
      writer.clear_screen
      writer.ask_if_human(player)
      input = reader.read_player_type

      until input == "y" or input == "n"
        writer.user_type_error
        input = gets.chomp.to_s
      end

      player.player_type = input
    }

    player.subscribe(:player_marker) {
      writer.ask_which_marker
      input = reader.read_marker(player)

      while player.marker == nil
        if !input.match(/[^A-Za-z]/) == false
          writer.select_letter
          input = reader.read_marker(player)
        elsif player.board.markers.include?(input)
          writer.marker_taken
          input = reader.read_marker(player)
        elsif input.length > 1
          writer.too_many_chars
          input = reader.read_marker(player)
        elsif input == ""
          writer.blank_marker
          input = reader.read_marker(player)
        else
          player.marker = input
        end
      end
    }

    player.subscribe(:make_move) {
      move_made = nil
      until move_made
        choice = reader.read_move
        if choice.match(/[0-8]/)
          choice = choice.to_i
        else
          writer.space_does_not_exist
          next
        end

        if player.board[choice] != player.board.markers[0] && player.board[choice] != player.board.markers[1]
          player.board[choice] = player.marker
          move_made = true
          break
        else
          writer.space_taken
          next
        end
      end
    }

    player.subscribe(:victory) do |v|
      writer.victory_taunt(v)
    end

    player.subscribe(:center) do |v|
      writer.center_taunt(v)
    end

    player.subscribe(:corner) do |c|
      writer.corner_taunt(c)
    end

    player.subscribe(:random) do |r|
      writer.random_taunt(r)
    end
  end

  class Writer
    def self.clear_screen
      system "clear" or system "cls"
    end

    def self.ask_if_human(player, o_stream=$stdout)
      o_stream.puts "Is Player #{player.player_count_cb} human (y/n)?"
    end

    def self.ask_which_marker(o_stream=$stdout)
      o_stream.puts "Which marker will this player use?"
    end

    def self.select_letter(o_stream=$stdout)
      o_stream.puts "Could you select a letter instead?"
    end

    def self.user_type_error(o_stream=$stdout)
      o_stream.puts "... Sorry, I'm a computer. I don't understand what you mean."
    end

    def self.select_letter(o_stream=$stdout)
      o_stream.puts "Could you select a letter instead?"
    end

    def self.marker_taken(o_stream=$stdout)
      o_stream.puts "Shoot, that one is already taken!"
    end

    def self.too_many_chars(o_stream=$stdout)
      o_stream.puts "Multiple characters for a marker? Really?"
    end

    def self.blank_marker(o_stream=$stdout)
      o_stream.puts "This can't go on without you. What will it be?"
    end

    def self.victory_taunt(pos, o_stream=$stdout)
      o_stream.puts "#{pos} selected. Victory shall be mine!"
    end

    def self.center_taunt(pos, o_stream=$stdout)
      o_stream.puts "#{pos} selected for center. Did you not want this?"
    end

    def self.corner_taunt(pos, o_stream=$stdout)
      o_stream.puts "#{pos} selected from corners, all according to plan..."
    end

    def self.random_taunt(pos, o_stream=$stdout)
      o_stream.puts "#{pos} selected at random. I'll have you yet!"
    end

    def self.space_does_not_exist(o_stream=$stdout)
      o_stream.puts "Huh, I don't see that on the board. Maybe you should try again."
    end

    def self.space_taken(o_stream=$stdout)
      o_stream.puts "That space is already taken!"
    end
  end

  class Reader
    def self.read_player_type(i_stream=$stdin)
      input = i_stream.gets.chomp.to_s
      input = input.downcase
      return input
    end

    def self.read_marker(player, i_stream=$stdin)
      input = i_stream.gets.chomp.to_s
    end

    def self.read_move(i_stream=$stdin)
      input = i_stream.gets.chomp
      return input
    end
  end
end
