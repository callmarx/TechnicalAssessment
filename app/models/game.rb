# frozen_string_literal: true

class Game < ApplicationRecord
  after_initialize :set_default_values

  private
    def set_default_values
      self.total_kills ||= 0
      self.players ||= []
      self.kills ||= {}
      self.has_crashed ||= false
      self.kills_by_means ||= {
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
      }
    end
end
