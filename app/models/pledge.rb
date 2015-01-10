class Pledge < ActiveRecord::Base
  include AASM

  belongs_to :referrer, class_name: 'Pledge'
  belongs_to :user
  belongs_to :charity

  enum state: [:created, :authorized, :captured, :refunded]

  validates :user, :charity, :tip_percentage, :amount, presence: true
  validates :amount, :tip_percentage, numericality: { only_integer: true }
  validates :amount, numericality: { greater_than: 0 }
  validates :tip_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :referrer, presence: true, if: 'referrer_id.present?'

  before_validation :set_expiration, on: :create

  aasm no_direct_assignment: true, column: :state do
    state :created, initial: true
    state :authorized
    state :captured
    state :refunded

    event :authorize do
      transitions from: :created, to: :authorized do
        after do
          # TODO: See about being process safe: self.lock!

          self.stripe_authorization_charge = ::Stripe::Charge.create(
            amount: amount,
            currency: 'usd',
            customer: user.stripe_customer_id,
            statement_descriptor: 'PayItForward.io - Auth',
            capture: false
          )
        end
      end
    end

    event :capture do
      transitions from: :authorized, to: :captured do
        after do
          # TODO: See about being process safe: self.lock!

          if stripe_authorization_charge.refunds.count.zero?
            stripe_authorization_charge.refund(
              reason: 'requested_by_customer'
            )
          end

          self.stripe_charge = ::Stripe::Charge.create(
            amount: amount,
            currency: 'usd',
            customer: user.stripe_customer_id,
            statement_descriptor: 'PayItForward.io',
            capture: true
          )
        end
      end
    end

    event :refund do
      transitions from: [:authorized, :captured], to: :refunded do
        after do
          # TODO: See about being process safe: self.lock!
          stripe_authorization_charge.refund if stripe_authorization_charge.present? && stripe_authorization_charge.refunds.count.zero?
          stripe_charge.refund if stripe_charge.present? && stripe_charge.refunds.count.zero?
        end
      end
    end
  end

  def stripe_authorization_charge
    @stripe_authorization_charge ||= ::Stripe::Charge.retrieve(stripe_authorization_charge_id) unless stripe_authorization_charge_id.nil?
    @stripe_authorization_charge
  end

  def stripe_charge
    @stripe_charge ||= ::Stripe::Charge.retrieve(stripe_charge_id) unless stripe_charge_id.nil?
    @stripe_charge
  end

  def expired?
    expiration.past?
  end

  private

  def stripe_authorization_charge=(stripe_authorization_charge)
    self.stripe_authorization_charge_id = stripe_authorization_charge.id
    @stripe_authorization_charge = stripe_authorization_charge
  end

  def stripe_charge=(stripe_charge)
    self.stripe_charge_id = stripe_charge.id
    @stripe_charge = stripe_charge
  end

  def set_expiration
    self.expiration = DateTime.now + 7.days
  end
end
