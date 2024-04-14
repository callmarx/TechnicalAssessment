# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuakeLog::Parser do
  describe "#perform" do
    context "when the log file is empty" do
      let(:file_path) { "spec/fixtures/empty.log" }

      it "does not create any game objects" do
        expect { described_class.new(file_path).perform }.not_to change(Game, :count)
      end
    end

    context "when the log file contains game data" do
      let(:file_path) { "spec/fixtures/double-clean-games.log" }

      it "creates game objects based on the log file" do
        expect { described_class.new(file_path).perform }.to change(Game, :count).by(2)
      end

      it "sets the correct attributes for the game objects" do
        described_class.new(file_path).perform

        game_1 = Game.first
        game_2 = Game.last

        expect(game_1.total_kills).to eq(3)
        expect(game_1.players).to include("Isgalamido", "Dono da Bola")
        expect(game_1.has_crashed).to eq(false)
        expect(game_1.kills).to eq({
          "Isgalamido" => -1,
          "Dono da Bola" => 0,
        })
        expect(game_1.kills_by_means).to eq({
          "MOD_UNKNOWN" => 0,
          "MOD_SHOTGUN" => 0,
          "MOD_GAUNTLET" => 0,
          "MOD_MACHINEGUN" => 0,
          "MOD_GRENADE" => 0,
          "MOD_GRENADE_SPLASH" => 0,
          "MOD_ROCKET" => 0,
          "MOD_ROCKET_SPLASH" => 1,
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
          "MOD_TRIGGER_HURT" => 2,
          "MOD_NAIL" => 0,
          "MOD_CHAINGUN" => 0,
          "MOD_PROXIMITY_MINE" => 0,
          "MOD_KAMIKAZE" => 0,
          "MOD_JUICED" => 0,
          "MOD_GRAPPLE" => 0
        })

        expect(game_2.total_kills).to eq(2)
        expect(game_2.players).to include("Dono da Bola", "Mocinha")
        expect(game_2.has_crashed).to eq(false)
        expect(game_2.kills).to eq({
          "Dono da Bola" => 0,
          "Mocinha" => 0,
        })
        expect(game_2.kills_by_means).to eq({
          "MOD_UNKNOWN" => 0,
          "MOD_SHOTGUN" => 0,
          "MOD_GAUNTLET" => 0,
          "MOD_MACHINEGUN" => 0,
          "MOD_GRENADE" => 0,
          "MOD_GRENADE_SPLASH" => 0,
          "MOD_ROCKET" => 1,
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
          "MOD_FALLING" => 1,
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

    context "when the log file contains a 'InitGame:' without a 'ShutdownGame'" do
      let(:file_path) { "spec/fixtures/crashed-games.log" }

      it "sets has_crashed as true" do
        described_class.new(file_path).perform

        game = Game.first

        expect(game.has_crashed).to eq(true)
      end
    end

    context "when the log file contains ends without a 'ShutdownGame'" do
      let(:file_path) { "spec/fixtures/crashed-end.log" }

      it "sets has_crashed as true" do
        described_class.new(file_path).perform

        game = Game.first

        expect(game.has_crashed).to eq(true)
      end
    end

    # Add more contexts and tests for other cases as needed
  end

  describe "private methods" do
    let!(:file_path) { "spec/fixtures/empty.log" }
    subject { described_class.new(file_path) }

    describe "#handle_crashed_match" do
      let(:game) { Game.new }

      context "when game is not nil" do
        it "sets has_crashed to true" do
          subject.send(:handle_crashed_match, game)
          expect(game.has_crashed).to eq(true)
        end

        it "saves the game" do
          expect(game).to receive(:save)
          subject.send(:handle_crashed_match, game)
        end
      end

      context "when game is nil" do
        it "does not set has_crashed to true" do
          subject.send(:handle_crashed_match, nil)
          expect(game.has_crashed).to eq(false)
        end

        it "does not save the game" do
          expect(game).not_to receive(:save)
          subject.send(:handle_crashed_match, nil)
        end
      end
    end

    describe "#handle_end_match" do
      let(:game) { Game.new }

      context "when game is not nil" do
        it "saves the game" do
          expect(game).to receive(:save)
          subject.send(:handle_end_match, game)
        end
      end

      context "when game is nil" do
        it "does not save the game" do
          expect(game).not_to receive(:save)
          subject.send(:handle_end_match, nil)
        end
      end
    end

    describe "#handle_player_change" do
      let(:game) { Game.new }

      context "when player is not in the game" do
        let(:line) { "ClientUserinfoChanged: 2 n\\Isgalamido\\t\\model\\g" }

        it "adds the player to the game" do
          subject.send(:handle_player_change, game, line)
          expect(game.players).to include("Isgalamido")
        end

        it "initializes the kill count for the player" do
          subject.send(:handle_player_change, game, line)
          expect(game.kills["Isgalamido"]).to eq(0)
        end
      end

      context "when player is already in the game" do
        let(:line1) { "ClientUserinfoChanged: 2 n\\Isgalamido\\t\\model\\g" }
        let(:line2) { "ClientUserinfoChanged: 3 n\\Isgalamido\\t\\model\\g" }

        before do
          subject.send(:handle_player_change, game, line1)
        end

        it "does not add the player again" do
          subject.send(:handle_player_change, game, line2)
          expect(game.players.count("Isgalamido")).to eq(1)
        end

        it "does not overwrite the kill count for the player" do
          game.kills["Isgalamido"] += 1
          subject.send(:handle_player_change, game, line2)
          expect(game.kills["Isgalamido"]).not_to eq(0)
        end
      end
    end

    describe "#handle_kill" do
      let(:game) { Game.new(kills: { "Isgalamido" => 0 }) }

      context "when killer is <world>" do
        let(:line) { "22:18 Kill: 2 2 7: <world> killed Isgalamido by MOD_ROCKET_SPLASH" }

        it "subtracts 1 from the victim's kill count" do
          subject.send(:handle_kill, game, line)
          expect(game.kills["Isgalamido"]).to eq(-1)
        end
      end

      context "when killer is the same as the victim (suicide)" do
        let(:line) { "22:18 Kill: 2 2 7: Isgalamido killed Isgalamido by MOD_ROCKET_SPLASH" }

        it "subtracts 1 from the victim's kill count" do
          subject.send(:handle_kill, game, line)
          expect(game.kills["Isgalamido"]).to eq(-1)
        end
      end

      context "when killer is not <world> and is different from the victim" do
        let(:line) { "22:18 Kill: 2 2 7: Isgalamido killed Zeh by MOD_ROCKET_SPLASH" }

        it "increments 1 in the killer's kill count" do
          subject.send(:handle_kill, game, line)
          expect(game.kills["Isgalamido"]).to eq(1)
        end
      end
    end
  end
end
