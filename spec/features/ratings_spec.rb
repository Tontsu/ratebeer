require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "is showed on ratings page and number of ratings is showed" do
    FactoryGirl.create(:rating, user:user, score:10, beer:beer1)
    FactoryGirl.create(:rating, user:user, score:20, beer:beer1)
    visit ratings_path

    expect(page).to have_content 'iso 3 10'
    expect(page).to have_content 'iso 3 20'
    expect(page).to have_content 'Number of ratings 2'
  end

  it "is showed only on users page who created it" do
    user2 = FactoryGirl.create(:user, username:"Kalle", password:"Secret1", password_confirmation:"Secret1")
    FactoryGirl.create(:rating, user:user, score:10, beer:beer1)
    FactoryGirl.create(:rating, user:user2, score:10, beer:beer2)
    visit user_path(user)

    expect(page).to have_content "iso 3"
    expect(page).not_to have_content "Karhu"
  end

  it "is deleted from database when user deletes it" do
    FactoryGirl.create(:rating, user:user, score:10, beer:beer1)
    visit user_path(user)
    expect{
      click_link "delete"
    }.to change{Rating.count}.from(1).to(0)

  end

end
