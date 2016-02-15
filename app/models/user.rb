class User < ActiveRecord::Base
  include RatingAverage
  validates :username, uniqueness: true,
                       length: {within: 3..15}
  validates :password,  length: {minimum: 4}
  validate :at_least_one_upper
  validate :at_least_one_number

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships


  has_secure_password

  def at_least_one_upper
    if not /[A-Z]/.match(password)
      errors.add(:password, "must contain at least one upper character")
    end
  end

  def at_least_one_number
    if not /[0-9]/.match(password)
      errors.add(:password, "must contain at least one number")
    end
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    group = ratings.group_by {|r| r.beer.style}
    averages = group.map { |k, v| v.inject(0.0){ |sum, i| sum + i.score} / v.size}
    Hash[group.keys.zip(averages)].max.first
  end

  def favorite_brewery
    Hash[ratings.group_by {|r| r.beer.brewery.name}.keys.zip(ratings.group_by {|r| r.beer.brewery.name}.map { |k, v| v.inject(0.0){ |sum, i| sum + i.score} / v.size})].max.first rescue nil
  end

end
