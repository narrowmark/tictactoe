class Board
  attr_accessor :board
  attr_accessor :markers

  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @markers = Array.new
  end

  def display_board
    puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n\n"
  end

  def win?
    b = @board
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
    if win?
      system "clear" or system "cls"
      puts "Game over!\n"
      display_board
      return true
    elsif tie?
      system "clear" or system "cls"
      puts "It's a tie!\n"
      display_board
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
    tmp = gets.chomp.to_s
    while @marker == nil
      if !tmp.match(/[^A-Za-z]/) == false
        puts "Could you select a letter instead?"
        tmp = gets.chomp.to_s
      elsif @board.markers.include?(tmp)
        puts "Shoot, that one is already taken!"
        tmp = gets.chomp.to_s
      elsif tmp.length > 1
        puts "Multiple characters for a marker? Really?"
        tmp = gets.chomp.to_s
      elsif tmp == ""
        puts "This can't go on without you. What will it be?"
        tmp = gets.chomp.to_s
      else
        @marker = tmp
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
      if best_move_found = winning_move?(@board, as, @board.markers[0])
        puts "#{as} selected. Victory shall be mine!"
        @board[as.to_i] = @marker
        break
      elsif best_move_found = winning_move?(@board, as, @board.markers[1])
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

class Game
  def initialize
    @board = Board.new
    @player1 = Player.new(@board)
    @player2 = Player.new(@board)
  end

  def run_game
    system "clear" or system "cls"
    puts "Let's get this game started!\n"

    while true
      puts "\nPlayer 1's turn\n\n"
      @board.display_board
      @player1.move
      if @board.game_over?
        puts "Player 1 wins!"
        break
      end

      system "clear" or system "cls"
      puts "Player 2's turn\n\n"
      @board.display_board
      @player2.move
      if @board.game_over?
        puts "Player 2 wins!"
        break
      end
    end
  end
end

game = Game.new
game.run_game
