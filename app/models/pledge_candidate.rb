class PledgeCandidate
  include ActiveModel::Model
  attr_accessor :referrer_id, :charity_id, :tip_percentage
  
  # Step 1
  validates :charity_id, presence: true
  
  # Step 2
  validates :tip_percentage, presence: true
  
end


