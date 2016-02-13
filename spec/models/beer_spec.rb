require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved when name and style is set" do
    Beer.create name: "Bisse", style: "rölli"
    expect(Beer.count).to eq(1)
  end

  it "is not saved if name is not set" do
    Beer.create style: "rölli"
    expect(Beer.count).to eq(0)
  end

  it "is not saved if style is not set" do
    Beer.create name: "Bisse"
    expect(Beer.count).to eq(0)
  end



end
