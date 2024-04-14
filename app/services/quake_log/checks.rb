module QuakeLog
  module Checks
    def is_start_match?(line)
      line.include?("InitGame:")
    end

    def is_end_match?(line)
      line.include?("ShutdownGame:")
    end

    def is_player_change?(line)
      line.include?("ClientUserinfoChanged:")
    end

    def is_kill?(line)
      line.include?("Kill:")
    end

    def get_player_name(line)
      line[/n\\(.*?)\\t/]&.gsub("n\\", "")&.gsub("\\t", "")
    end

    def get_killer_name(line)
      line.match(/(?:[^:]+:){2}\s*([^:]+)\s+killed/)[1]
    end

    def get_victim_name(line)
      line.match(/killed\s+(.*?)\s+by/)[1]
    end

    def get_death_cause(line)
      line.match(/MOD_\w+$/)[0]
    end
  end
end
