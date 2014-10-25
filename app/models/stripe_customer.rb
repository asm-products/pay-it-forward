class StripeCustomer < ActiveRecord::Base
  belongs_to :user

  validates :stripe_id, :user_id, presence: true
  validates :stripe_id, :user_id, uniqueness: true
end
