# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    @games = Game.page(params[:page]).per(params[:per_page])
  end

  def show
    @game = Game.find(params[:id])
  end

  def grouped_information
    @games = Game.all
    render 'grouped_information', formats: :json
  end

  def deaths_grouped_by_cause
    @games = Game.all
    render 'deaths_grouped_by_cause', formats: :json
  end
end
