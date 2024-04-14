# frozen_string_literal: true

require "rails_helper"

RSpec.describe Game, type: :model do
  describe "default values" do
    it "has default values" do
      game = Game.new

      expect(game.total_kills).to eq(0)
      expect(game.players).to eq([])
      expect(game.kills).to eq({})
      expect(game.has_crashed).to be false
      expect(game.kills_by_means).to eq({
        "MOD_UNKNOWN" => 0,
        "MOD_SHOTGUN" => 0,
        "MOD_GAUNTLET" => 0,
        "MOD_MACHINEGUN" => 0,
        "MOD_GRENADE" => 0,
        "MOD_GRENADE_SPLASH" => 0,
        "MOD_ROCKET" => 0,
        "MOD_ROCKET_SPLASH" => 0,
        "MOD_PLASMA" => 0,
        "MOD_PLASMA_SPLASH" => 0,
        "MOD_RAILGUN" => 0,
        "MOD_LIGHTNING" => 0,
        "MOD_BFG" => 0,
        "MOD_BFG_SPLASH" => 0,
        "MOD_WATER" => 0,
        "MOD_SLIME" => 0,
        "MOD_LAVA" => 0,
        "MOD_CRUSH" => 0,
        "MOD_TELEFRAG" => 0,
        "MOD_FALLING" => 0,
        "MOD_SUICIDE" => 0,
        "MOD_TARGET_LASER" => 0,
        "MOD_TRIGGER_HURT" => 0,
        "MOD_NAIL" => 0,
        "MOD_CHAINGUN" => 0,
        "MOD_PROXIMITY_MINE" => 0,
        "MOD_KAMIKAZE" => 0,
        "MOD_JUICED" => 0,
        "MOD_GRAPPLE" => 0
      })
    end
  end
end
