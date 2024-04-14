# frozen_string_literal: true

module QuakeLog
  class Parser
    include Checks

    def initialize(file_path)
      @file_path = file_path
    end

    def perform
      game = nil

      File.foreach(@file_path) do |line|
        case
        when is_start_match?(line)
          handle_crashed_match(game)
          game = Game.new
        when is_end_match?(line)
          handle_end_match(game)
          game = nil
        when is_player_change?(line)
          handle_player_change(game, line)
        when is_kill?(line)
          handle_kill(game, line)
        end
      end
      handle_crashed_match(game)
    end

    private
      def handle_crashed_match(game)
        if game
          game.has_crashed = true
          game.save
        end
      end

      def handle_end_match(game)
        game.save if game
      end

      def handle_player_change(game, line)
        name = get_player_name(line)

        unless game.players.include?(name)
          game.players.push(name)
          game.kills[name] = 0
        end
      end

      def handle_kill(game, line)
        game.total_kills += 1

        killer_name = get_killer_name(line)
        victim_name = get_victim_name(line)
        death_cause = get_death_cause(line)

        if killer_name == "<world>" || killer_name == victim_name
          # -1 kill score if it was cause by <world> OR suicide
          game.kills[victim_name] -= 1
        else
          game.kills[killer_name] += 1
        end

        game.kills_by_means[death_cause] += 1
      end
  end
end
