class Pledge < ActiveRecord::Base
  attr_writer :current_step

  belongs_to :referrer, class_name: 'Pledge'
  belongs_to :user
  belongs_to :charity
  has_one :stripe_charge

  enum action: [:refunded_by_default, :refunded, :donated, :continued]

  validates :user_id, :expiration, :charity_id, :tip_percentage, presence: true

  def create_from_candidate
  end
end
