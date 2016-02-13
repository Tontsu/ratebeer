require 'rails_helper'

describe "Beer" do

  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is created with valid name" do
    visit new_beer_path

    fill_in('beer_name', with:'Bisse')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

  end

  it "is created with invalid name should show error and not saved" do
    visit new_beer_path
    click_button "Create Beer"
    expect(page).to have_content "Name is too short"
    expect(Beer.count).to eq(0)

  end

end
