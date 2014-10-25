class StripeCharge < ActiveRecord::Base
  belongs_to :stripe_customer
  belongs_to :pledge

  after_initialize :default_values

  validates :stripe_id, :stripe_customer_id, :value, :currency, :status, :pledge, presence: true
  validates :stripe_id, :pledge, uniqueness: true

  enum status: [:authorized, :captured, :refunded, :disputed]

  private

  def default_values
    self.status ||= :authorized
  end
end
