require 'rails_helper'

describe 'User page' do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "should show favorite beer style and favorite brewery" do
    rating = FactoryGirl.create(:rating, user:user, score:10, beer:beer1)
    visit user_path(user)
    expect(page).to have_content "Favorite beer style #{beer1.style.name}"
    expect(page).to have_content "Favorite brewery #{beer1.brewery.name}"
  end
end
