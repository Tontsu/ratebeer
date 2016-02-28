class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @mostRatedUsers = User.top 2
    @bestRatedBeers = Beer.top 2
    @bestRatedBreweries = Brewery.top 2
    @bestStyles = Style.top 2
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

end
