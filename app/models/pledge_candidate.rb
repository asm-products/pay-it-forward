class PledgeCandidate
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :referrer_id, :charity_id, :tip_percentage

  # steps :select_charity, :set_value
  attr_accessor :current_step
  validates :charity_id, presence: true, if: proc { |f| f.current_step.nil? || f.current_step == :select_charity }
  validates :tip_percentage, presence: true, if: proc { |f| f.current_step.nil? || f.current_step == :set_value }

  def attributes
    {
      'referrer_id' => @referrer_id,
      'charity_id' => @charity_id,
      'tip_percentage' => @tip_percentage
    }
  end

  def assign_attributes(hash)
    hash.each do |k, v|
      send("#{k}=", v)
    end
  end

  def save
    valid?
  end
end
