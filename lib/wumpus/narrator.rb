module Wumpus
  class Narrator
    def initialize(cave, player)
      @cave   = cave
      @player = player
    end

    def say(message)
      STDOUT.puts message
    end

    def ask(question)
      print "#{question} "
      STDIN.gets.chomp
    end

    def tell_story
      until finished?
        describe_room
        ask_player_to_act
      end

      describe_ending
    end

    def finish_story(message)
      @ending_message = message
    end

    private
    
    def finished?
      !!@ending_message
    end

    def describe_ending
      say "-----------------------------------------"
      say @ending_message
    end

    def describe_room
      say "-----------------------------------------"
      say "You are in room #{@player.room.number}."

      @player.explore_room

      say "Exits go to: #{@player.room.exits.join(', ')}"
    end

    def ask_player_to_act
      actions = {"m" => :move, "s" => :shoot, "i" => :inspect }
      
      accepting_player_input do |command, room_number| 
        @player.act(actions[command], @cave.room(room_number))
      end
    end

    def accepting_player_input
      say "-----------------------------------------"
      command = ask("What do you want to do? (m)ove or (s)hoot?")

      unless ["m","s"].include?(command)
        say "INVALID ACTION! TRY AGAIN!"
        return
      end

      dest = ask("Where?").to_i

      unless @player.room.exits.include?(dest)
        say "THERE IS NO PATH TO THAT ROOM! TRY AGAIN!"
        return
      end

      yield(command, dest)
    end
  end
end
