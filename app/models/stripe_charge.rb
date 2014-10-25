class StripeCharge < ActiveRecord::Base
  belongs_to :stripe_customer

  after_initialize :default_values

  validates :stripe_id, :stripe_customer_id, :value, :currency, :status, presence: true
  validates :stripe_id, uniqueness: true

  enum status: [:authorized, :captured, :refunded, :disputed]

  private

  def default_values
    self.status ||= :authorized
  end
end
