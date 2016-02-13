class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, length: {allow_blank: false}
  validates :style, length: {allow_blank: false}

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  def average
    return 0 if ratings.empty?
    ratings.map {|r| r.score }.sum / ratings.count.to_f
  end

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end

end
