class Pledge < ActiveRecord::Base
  belongs_to :referrer, class_name: 'Pledge'
  belongs_to :user
  belongs_to :charity

  enum action: [:refunded_by_default, :donated, :continued]
  enum status: [:authorized, :captured, :canceled, :refunded, :disputed]

  validates :user, :charity, :tip_percentage, :amount, presence: true
  validates :amount, :tip_percentage, numericality: { only_integer: true }
  validates :amount, numericality: { greater_than: 0 }
  validates :tip_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :referrer, presence: true, if: 'referrer_id.present?'

  before_validation :set_expiration, on: :create

  def authorize!
    self.stripe_charge = ::Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: user.stripe_customer_id,
      capture: false
    )

    self.status = :authorized

    # TODO: Handle validation errors
    self.save! unless self.new_record?
  end

  def stripe_charge
    @stripe_charge ||= ::Stripe::Charge.retrieve(stripe_charge_id) unless stripe_charge_id.nil?
    @stripe_charge
  end

  private

  def stripe_charge=(stripe_charge)
    self.stripe_charge_id = stripe_charge.id
    @stripe_charge = stripe_charge
  end

  def set_expiration
    self.expiration = DateTime.now + 7.days
  end
end
