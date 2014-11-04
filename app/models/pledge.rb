class Pledge < ActiveRecord::Base
  attr_writer :current_step

  belongs_to :referrer, class_name: 'Pledge'
  belongs_to :user
  belongs_to :charity
  has_one :stripe_charge

  enum action: [:refunded_by_default, :refunded, :donated, :continued]

  validates :user_id, :expiration, :charity_id, :tip_percentage, :amount, presence: true

  def create_from_candidate(candidate)
    create do |pledge|
      pledge.referrer_id = candidate.referrer_id
      #pledge.user_id = 
      pledge.charity_id = candidate.charity_id
      pledge.expiration = DateTime.now + 7.days
      pledge.tip_percentage = candidate.tip_percentage
      pledge.amount = candidate.amount
    end
  end
end