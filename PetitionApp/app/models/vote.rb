class Vote < ActiveRecord::Base
  belongs_to :petition

  validates_presence_of :user_id, :petition_id
  validates_uniqueness_of :petition_id, scope: :user_id

end
