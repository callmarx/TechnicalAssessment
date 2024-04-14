# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuakeLog::Checks, type: :service do
  include QuakeLog::Checks

  describe "#is_start_match?" do
    it "returns true for start match" do
      line = '0:00 InitGame: \sv_floodProtect\1\sv_maxP...q3dm17\gamename\baseq3\g_needpass\0'
      expect(is_start_match?(line)).to be true
    end

    it "returns false for non-start match lines" do
      line = '0:25 ClientUserinfoChanged: 2 n\Dono da Bola\t\0\model\sarge/kr.......l\\0'
      expect(is_start_match?(line)).to be false
    end
  end

  describe "#is_end_match?" do
    it "returns true for end match" do
      line = "1:47 ShutdownGame:"
      expect(is_end_match?(line)).to be true
    end

    it "returns false for non-end match lines" do
      line = '0:00 InitGame: \sv_floodProtect\1\sv_maxP...q3dm17\gamename\baseq3\g_needpass\0'
      expect(is_end_match?(line)).to be false
    end
  end

  describe "#is_player_change?" do
    it "returns true for player change" do
      line = '1:47 ClientUserinfoChanged: 4 n\Zeh\t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(is_player_change?(line)).to be true
    end

    it "returns false for non-player change lines" do
      line = "2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET"
      expect(is_player_change?(line)).to be false
    end
  end

  describe "#is_kill?" do
    it "returns true for kill event" do
      line = "2:11 Kill: 2 4 6: Dono da Bola killed Zeh by MOD_ROCKET"
      expect(is_kill?(line)).to be true
    end

    it "returns false for non-kill event lines" do
      line = '1:47 ClientUserinfoChanged: 4 n\Zeh\t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(is_kill?(line)).to be false
    end
  end

  describe "#get_player_name" do
    it "returns the player name from the line" do
      line = '0:25 ClientUserinfoChanged: 2 n\Dono da Bola\t\0\model\sarge/kr.......l\\0'
      expect(get_player_name(line)).to eq("Dono da Bola")
    end

    it "returns nil if player name is not found" do
      line = '1:47 ClientUserinfoChanged: 4 ...t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(get_player_name(line)).to be_nil
    end
  end

  describe "#get_killer_name" do
    it "returns the killer name from the line" do
      line = "00:00 Kill: 1 2 6: Player1 killed Player2 by MOD_RAILGUN"
      expect(get_killer_name(line)).to eq("Player1")
    end

    it "returns nil if killer name is not found" do
      line = '1:47 ClientUserinfoChanged: 4 n\Zeh\t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(get_killer_name(line)).to be_nil
    end
  end

  describe "#get_victim_name" do
    it "returns the victim name from the line" do
      line = "00:00 Kill: 1 2 6: Player1 killed Player2 by MOD_RAILGUN"
      expect(get_victim_name(line)).to eq("Player2")
    end

    it "returns nil if victim name is not found" do
      line = '1:47 ClientUserinfoChanged: 4 n\Zeh\t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(get_victim_name(line)).to be_nil
    end
  end

  describe "#get_death_cause" do
    it "returns the death cause from the line" do
      line = "00:00 Kill: 1 2 6: Player1 killed Player2 by MOD_RAILGUN"
      expect(get_death_cause(line)).to eq("MOD_RAILGUN")
    end

    it "returns nil if death cause is not found" do
      line = '1:47 ClientUserinfoChanged: 4 n\Zeh\t\0\model\sar...\w\0\l\0\tt\0\tl\0'
      expect(get_death_cause(line)).to be_nil
    end
  end
end
