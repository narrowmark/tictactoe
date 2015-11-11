class Display
  def initialize(player)
    player.subscribe(:player_type) {
#      system "clear" or sysem "cls"
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
=begin
        elsif @board.markers.include?(marker)
          puts "Shoot, that one is already taken!"
          marker = gets.chomp.to_s
=end
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
=begin
      puts "What marker will this player use?"
      marker = gets.chomp.to_s
      marker_selected = false


#      while player.marker_selected == false
      while marker_selected == false
        if !marker.match(/[^A-Za-z]/) == false
          puts "Could you select a letter instead?"
          marker = gets.chomp.to_s
=begin
        elsif @board.markers.include?(marker)
          puts "Shoot, that one is already taken!"
          player.marker = gets.chomp.to_s
=end
=begin
        elsif marker.length > 1
          puts "Multiple characters for a marker? Really?"
          marker = gets.chomp.to_s
        elsif marker == ""
          puts "This can't go on without you. What will it be?"
          marker = gets.chomp.to_s
        else
          marker_selected = true
          player.marker_selected = true
          player.marker = marker
        end
      end
=end
    }
  end
end
