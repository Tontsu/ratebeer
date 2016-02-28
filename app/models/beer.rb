class Beer < ActiveRecord::Base
  include RatingAverage

  validates :name, length: {allow_blank: false}
  validates :style, presence: true

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  def average
    return 0 if ratings.empty?
    ratings.map {|r| r.score }.sum / ratings.count.to_f
  end

  def to_s
    "#{self.name}, #{self.brewery.name}"
  end

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order[0..n]
  end

end
