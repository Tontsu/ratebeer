class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def is_member?(user)
    users.include? user
  end

  def to_s
    "#{self.name}"
  end
end
