class Pledge < ActiveRecord::Base
  belongs_to :referrer, class_name: 'Pledge'
  belongs_to :user
  belongs_to :charity

  has_one :stripe_charge

  validates :user_id, :expiration, presence: true

  enum action: [:refund_by_default, :refund, :donate, :continue]
end
