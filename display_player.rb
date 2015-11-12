class DisplayPlayer
  def initialize(player)
    # Display logic for the Player class
    player.subscribe(:player_type) {
      system "clear" or sysem "cls"
      puts "Is Player #{player.player_count_cb} human (y/n)?"
      player_type = gets.chomp.to_s

      until player_type.downcase == "y" or player_type.downcase == "n"
        puts "... Sorry, I'm a computer. I don't understand what you mean."
        player_type = gets.chomp.to_s
      end

      player.player_type = player_type
    }

    player.subscribe(:player_marker) {
      puts "What marker will this player use?"
      marker = gets.chomp.to_s
      while player.marker == nil
        if !marker.match(/[^A-Za-z]/) == false
          puts "Could you select a letter instead?"
          marker = gets.chomp.to_s
        elsif player.board.markers.include?(marker)
          puts "Shoot, that one is already taken!"
          marker = gets.chomp.to_s
        elsif marker.length > 1
          puts "Multiple characters for a marker? Really?"
          marker = gets.chomp.to_s
        elsif marker == ""
          puts "This can't go on without you. What will it be?"
          marker = gets.chomp.to_s
        else
          player.marker = marker
        end
      end
    }

    player.subscribe(:make_move) {
      move_made = nil
      until move_made
        choice = gets.chomp
        if choice.match(/[0-8]/)
          choice = choice.to_i
        else
          puts "Huh. I don't see that on the board. Maybe you should try again."
          next
        end

        if player.board[choice] != player.board.markers[0] && player.board[choice] != player.board.markers[1]
          player.board[choice] = player.marker
          player.move_made = true
          break
        else
          puts "That space is already taken"
          next
        end
      end
    }

    player.subscribe(:victory) do |v|
      puts "#{v} selected. Victory shall be mine!"
    end

    player.subscribe(:center) do |v|
      puts "#{v} selected for center. Did you not want this?"
    end

    player.subscribe(:corner) do |c|
      puts "#{c} selected from corners, all according to plan..."
    end

    player.subscribe(:random) do |r|
      puts "#{r} selected at random. I'll have you yet!"
    end
  end
end
=begin
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
=end
