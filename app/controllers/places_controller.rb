class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def show
  end

  def index
    render :index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  private

  def set_place
    @place = Rails.cache.read(session[:city]).group_by() {|r| r.id}[params[:id]].first
  end
end
