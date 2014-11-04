class PledgeCandidate
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :referrer_id, :charity_id, :tip_percentage, :pledge_amount

  # steps :select_charity, :set_value
  attr_accessor :current_step
  validates :charity_id, presence: true, if: proc { |f| f.should_be_valid? :select_charity }
  validates :tip_percentage, :amount, presence: true, if: proc { |f| f.should_be_valid? :set_value }

  def attributes
    {
      'referrer_id' => @referrer_id,
      'charity_id' => @charity_id,
      'tip_percentage' => @tip_percentage,
      'amount' => @amount
    }
  end

  def assign_attributes(hash)
    hash.each do |k, v|
      send("#{k}=", v) if respond_to? "#{k}="
    end
  end

  def save
    valid?
  end

  def should_be_valid?(step)
    current_step.nil? || current_step == step
  end
end
