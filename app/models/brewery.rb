class Brewery < ActiveRecord::Base
  include RatingAverage

  validates :name, length: {allow_blank: false}
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                   only_integer: true}
  validate :validate_this_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def validate_this_year
    if year > Date.today.year
      errors.add(:year, "Year can't be in the future")
    end
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

end
