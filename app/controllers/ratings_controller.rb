class RatingsController < ApplicationController
  def index
    @ratings = cache_data("all ratings", "Rating.all", 5)
    @mostActiveUsers = cache_data("active users", "User.top(2)", 60)
    @bestRatedBeers = cache_data("best beers", "Beer.top(2)", 60)
    @bestRatedBreweries = cache_data("best breweries", "Brewery.top(2)", 60)
    @bestStyles = cache_data("best styles", "Style.top(2)", 60)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  private

  def cache_data(cache_key, from, time)
    Rails.cache.write(cache_key, eval(from), expires_in: time.seconds) unless Rails.cache.exist?(cache_key)
    Rails.cache.read cache_key
  end

end
