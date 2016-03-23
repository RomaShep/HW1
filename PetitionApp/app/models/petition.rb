class Petition < ActiveRecord::Base
  belongs_to :user
  has_many :votes
  EXPIRE_TIME = 30
  VOTES_NUM = 100


  def expired?
    self.created_at < EXPIRE_TIME.day.ago 
  end

  def old?
    self.created_at < (EXPIRE_TIME + 1).day.ago 
  end

  def petition_vin?
    self.votes.count >= VOTES_NUM
  end

end
