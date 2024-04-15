require 'rails_helper'

RSpec.describe "Games", type: :request do
  describe "GET /games" do
    let!(:games) { create_list(:game_with_random_values, 5) }

    it "returns a success response" do
      get games_url
      expect(response).to be_successful
    end

    it "returns games data" do
      get games_url
      parsed_body = JSON.parse(response.body)

      expect(parsed_body["games"].size).to eq(5)
      
      games.each do |game|
        expect(parsed_body["games"]).to include(
          a_hash_including(
            "id" => game.id,
            "total_kills" => game.total_kills,
            "players" => game.players,
            "kills" => game.kills,
          )
        )
      end
    end
  end

  describe "GET /games/:id" do
    let(:game) { create(:game_with_random_values) } 

    it "returns a success response" do
      get game_url(game)
      expect(response).to be_successful
    end

    it "returns the correct game data" do
      get game_url(game)

      expect(JSON.parse(response.body)).to include(
          "id" => game.id,
          "total_kills" => game.total_kills,
          "players" => game.players,
          "kills" => game.kills,
          "has_crashed" => game.has_crashed,
          "kills_by_means" => game.kills_by_means
      )
    end
  end

  describe "GET /grouped_information" do
    let!(:games) { create_list(:game, 5) }

    it "returns a success response" do
      get grouped_information_games_url
      expect(response).to be_successful
    end

    it "returns grouped information for each match" do
      get grouped_information_games_url
      parsed_body = JSON.parse(response.body)

      expect(parsed_body["games"].size).to eq(5)
      
      games.each do |game|
        expect(parsed_body["games"]).to include(
          a_hash_including(
            "id" => game.id,
            "total_kills" => game.total_kills,
            "players" => game.players,
            "kills" => game.kills,
          )
        )
      end
    end
  end

  describe "GET /deaths_grouped_by_cause" do
    let!(:games) { create_list(:game, 5) }

    it "returns a success response" do
      get deaths_grouped_by_cause_games_url
      expect(response).to be_successful
    end

    it "returns deaths grouped by cause for each match" do
      get deaths_grouped_by_cause_games_url
      parsed_body = JSON.parse(response.body)

      expect(parsed_body["games"].size).to eq(5)
      
      games.each do |game|
        expect(parsed_body["games"]).to include(
          a_hash_including(
            "id" => game.id,
            "kills_by_means" => game.kills_by_means,
          )
        )
      end
    end
  end
end
