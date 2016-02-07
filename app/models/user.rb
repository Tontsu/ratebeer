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

end
