FactoryBot.define do
  factory :game do
    total_kills { 0 }
    players { [] }
    kills { {} }
    has_crashed { false }
    kills_by_means do
      {
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

  factory :game_with_random_values, parent: :game do
    total_kills { Faker::Number.between(from: 0, to: 100) }
    players { Faker::Lorem.words(number: Faker::Number.between(from: 1, to: 10)) }
    kills do
      players.map { |player| [player, Faker::Number.between(from: 0, to: 50)] }.to_h
    end
    has_crashed { Faker::Boolean.boolean }
    kills_by_means do
      {
        "MOD_UNKNOWN" => Faker::Number.between(from: 0, to: 5),
        "MOD_SHOTGUN" => Faker::Number.between(from: 0, to: 5),
        "MOD_GAUNTLET" => Faker::Number.between(from: 0, to: 5),
        "MOD_MACHINEGUN" => Faker::Number.between(from: 0, to: 5),
        "MOD_GRENADE" => Faker::Number.between(from: 0, to: 5),
        "MOD_GRENADE_SPLASH" => Faker::Number.between(from: 0, to: 5),
        "MOD_ROCKET" => Faker::Number.between(from: 0, to: 5),
        "MOD_ROCKET_SPLASH" => Faker::Number.between(from: 0, to: 5),
        "MOD_PLASMA" => Faker::Number.between(from: 0, to: 5),
        "MOD_PLASMA_SPLASH" => Faker::Number.between(from: 0, to: 5),
        "MOD_RAILGUN" => Faker::Number.between(from: 0, to: 5),
        "MOD_LIGHTNING" => Faker::Number.between(from: 0, to: 5),
        "MOD_BFG" => Faker::Number.between(from: 0, to: 5),
        "MOD_BFG_SPLASH" => Faker::Number.between(from: 0, to: 5),
        "MOD_WATER" => Faker::Number.between(from: 0, to: 5),
        "MOD_SLIME" => Faker::Number.between(from: 0, to: 5),
        "MOD_LAVA" => Faker::Number.between(from: 0, to: 5),
        "MOD_CRUSH" => Faker::Number.between(from: 0, to: 5),
        "MOD_TELEFRAG" => Faker::Number.between(from: 0, to: 5),
        "MOD_FALLING" => Faker::Number.between(from: 0, to: 5),
        "MOD_SUICIDE" => Faker::Number.between(from: 0, to: 5),
        "MOD_TARGET_LASER" => Faker::Number.between(from: 0, to: 5),
        "MOD_TRIGGER_HURT" => Faker::Number.between(from: 0, to: 5),
        "MOD_NAIL" => Faker::Number.between(from: 0, to: 5),
        "MOD_CHAINGUN" => Faker::Number.between(from: 0, to: 5),
        "MOD_PROXIMITY_MINE" => Faker::Number.between(from: 0, to: 5),
        "MOD_KAMIKAZE" => Faker::Number.between(from: 0, to: 5),
        "MOD_JUICED" => Faker::Number.between(from: 0, to: 5),
        "MOD_GRAPPLE" => Faker::Number.between(from: 0, to: 5)
      }
    end
  end
end
