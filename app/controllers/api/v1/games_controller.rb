class Api::V1::GamesController < ApplicationController
  def search
    @games = Game.search(params[:query])
    render json: @games
  end
end
