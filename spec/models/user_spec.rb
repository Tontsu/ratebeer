require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)

  end

  it "is not saved if password is under 4 characters" do
    user = User.create username:"Pekka", password:"Se1", password_confirmation:"Se1"
    expect(User.count).to eq(0)
  end

  it "is not saved if password contains only characters" do
    user = User.create username:"Pekka", password:"Secret", password_confirmation:"Secret"
    expect(User.count).to eq(0)
  end

  it "is not saved if password does not match with password confirmation" do
    user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret2"
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without rating does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)

    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 7, 20, 14)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) {FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without rating does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the one with ratings when only one style rated" do
      beer = create_beer_with_rating_style(user, 10, "IPA")
      create_beer_with_rating_style(user, 20, "IPA")

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating" do
      create_beer_with_rating_style(user, 10, "IPA")
      best = create_beer_with_rating_style(user, 20, "Paras")
      create_beer_with_rating_style(user, 5, "Bager")

      expect(user.favorite_style).to eq(best.style)
    end

    it "is the one with highest average rating" do
      create_beer_with_rating_style(user, 7, "IPA")
      create_beer_with_rating_style(user, 30, "Bager")
      create_beer_with_rating_style(user, 15, "IPA")
      create_beer_with_rating_style(user, 25, "Paras")
      create_beer_with_rating_style(user, 1, "Bager")
      best = create_beer_with_rating_style(user, 25, "Paras")
      create_beer_with_rating_style(user, 1, "Bager")

      expect(user.favorite_style).to eq(best.style)
    end

  end

  describe "favorite brewery" do
    let(:user) {FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without rating does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the one with rating when only one is rated" do
      beer = create_beer_with_rating(user, 10)
      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the one with highest rating" do
        create_beer_with_rating_brewery(user, 10, FactoryGirl.create(:brewery))
        best = create_beer_with_rating_brewery(user, 15, FactoryGirl.create(:brewery2))
        create_beer_with_rating_brewery(user, 1, FactoryGirl.create(:brewery3))
        expect(user.favorite_brewery).to eq(best.brewery.name)
    end

    it "is the one with highest average rating" do
        create_beer_with_rating_brewery(user, 10, FactoryGirl.create(:brewery))
        create_beer_with_rating_brewery(user, 5, FactoryGirl.create(:brewery))
        best = create_beer_with_rating_brewery(user, 25, FactoryGirl.create(:brewery2))
        create_beer_with_rating_brewery(user, 30, FactoryGirl.create(:brewery2))
        create_beer_with_rating_brewery(user, 31, FactoryGirl.create(:brewery3))
        create_beer_with_rating_brewery(user, 1, FactoryGirl.create(:brewery3))

        expect(user.favorite_brewery).to eq(best.brewery.name)

    end
  end

  def create_beer_with_rating_brewery(user, score, brewery)
    beer = FactoryGirl.create(:beer, brewery:brewery)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beer_with_rating_style(user, score, style)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beer_with_rating(user, score)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end

  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating(user, score)
    end
  end
end
