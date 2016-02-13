require 'rails_helper'

describe "when initialized with name Schlenkerla and year 1674" do
  subject{ Brewery.create name: "Schlenkerla", year: 1674 }

  it { should be_valid }
  its(:name) { should eq("Schlenkerla") }
  its(:year) { should eq(1674) }
end
