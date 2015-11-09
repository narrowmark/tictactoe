class Player
  @@player_count = 0

  def initialize(board)
    @@player_count += 1
    @board = board

    system "clear" or system "cls"
    puts "Is Player #{@@player_count} a human (y/n)?"
    @player_type = gets.chomp.to_s
    until @player_type.downcase == "y" or @player_type.downcase == "n"
      puts "... Sorry, I'm a computer. I don't understand what you mean."
      @player_type = gets.chomp.to_s
    end

    puts "What marker will this player use?"
    marker = gets.chomp.to_s
    while @marker == nil
      if !marker.match(/[^A-Za-z]/) == false
        puts "Could you select a letter instead?"
        marker = gets.chomp.to_s
      elsif @board.markers.include?(marker)
        puts "Shoot, that one is already taken!"
        marker = gets.chomp.to_s
      elsif marker.length > 1
        puts "Multiple characters for a marker? Really?"
        marker = gets.chomp.to_s
      elsif marker == ""
        puts "This can't go on without you. What will it be?"
        marker = gets.chomp.to_s
      else
        @marker = marker
        @board.markers << @marker
      end
    end
  end

  def move
    if @player_type == "y"
      human_move
    else
      computer_move
    end
  end

  def human_move
    move_made = nil
    until move_made
      choice = gets.chomp
      if choice.match(/[0-8]/)
        choice = choice.to_i
      else
        puts "Huh. I don't see that on the board. Maybe you should try again."
        next
      end

      if @board[choice] != @board.markers[0] && @board[choice] != @board.markers[1]
        @board[choice] = @marker
        move_made = true
        break
      else
        puts "That space is already taken"
        next
      end
      move_made
    end
  end

  def computer_move
    available_spaces = []
    best_move_found = nil

    @board.board.each do |s|
      if !@board.markers.include?(s)
        available_spaces << s
      end
    end

    available_spaces.each do |as|
      if best_move_found = winning_move?(@board, as, @board.markers[1])
        puts "#{as} selected. Victory shall be mine!"
        @board[as.to_i] = @marker
        break
      elsif best_move_found = winning_move?(@board, as, @board.markers[0])
        puts "#{as} selected. Victory shall be mine!"
        @board[as.to_i] = @marker
        break
      elsif best_move_found = as == "4"
        puts "#{as} selected for center. Did you not want this?"
        @board[as.to_i] = @marker
        break
      else
        @board[as.to_i] = as
      end
    end

    if !best_move_found
      corner = 1
      unless (available_spaces & ["0", "2", "6", "8"]).length == 0
        corner = available_spaces.sample until corner.to_i.even?
      end

      if corner
        puts "#{corner} selected from corners, all according to plan..."
        best_moved_found = true
        @board[corner.to_i] = @marker
      else
        puts available_spaces & ["0", "2", "6", "8"]
        n = available_spaces.sample.to_i
        puts "#{n} selected at random. I'll have you yet!"
        @board[n] = @marker
      end
    end
  end

  def winning_move?(board, choice, next_player)
    winning_move = nil
    board[choice.to_i] = next_player
    if @board.win?
      winning_move = choice.to_i
      board[choice.to_i] = choice
      return winning_move
    end
  end
end
