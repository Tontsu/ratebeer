class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:beer_club_id]


  def to_s
    "#{self.beer_club.name}"
  end
end
