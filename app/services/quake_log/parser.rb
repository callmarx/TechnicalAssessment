module QuakeLog
  class Parser
    include Checks

    def initialize(file_path)
      @file_path = file_path
    end

    def perform
      game = nil
      File.foreach(@file_path) do |line|
        if is_start_match?(line)
          if game
            # Consider a 'start_match' without a respective 'end_match'
            game.has_crashed = true
            puts game.inspect
          end
          game = Game.new
        end

        if is_end_match?(line)
          puts game.inspect
          game = nil
        end

        if is_player_change?(line)
          name = get_player_name(line)
          game.players.push(name) unless game.players.include?(name)
        end

        if is_kill?(line)
          game.total_kills += 1

          killer_name = get_killer_name(line)

          if killer_name != '<world>'
            ### TO-DO: Should I check if game.kills and game.players have the same names/players?
            game.kills[killer_name] ? game.kills[killer_name] += 1 : game.kills[killer_name] = 1
          else
            victim_name = get_victim_name(line)
            game.kills[victim_name] ? game.kills[victim_name] -= 1 : game.kills[victim_name] = -1
          end

          death_cause = get_death_cause(line)
          game.kills_by_means[death_cause] += 1
        end
      end
    end
  end
end
