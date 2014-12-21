class PledgeForm
  include Virtus.model
  include ActiveModel::Model

  # include ActiveRecord::Associations
  # belongs_to :user

  attribute :amount, Integer
  attribute :tip_percentage, Integer
  attribute :stripe_customer_token, String

  attribute :name, String
  attribute :email, String

  attribute :charity_id, Integer
  attribute :user_id, Integer
  attribute :referrer_id, Integer

  validates :charity, :amount, :tip_percentage, :stripe_customer_token, :name, :email, presence: true
  validates :amount, :tip_percentage, numericality: { only_integer: true }
  validates :amount, numericality: { greater_than: 0 }
  validates :tip_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :email, email: true

  validates :referrer, presence: true, if: 'referrer_id.present?'
  validates :user, presence: true, if: 'user_id.present?'

  validate :stripe_customer_token_must_be_valid, if: 'stripe_customer_token.present?'
  validate :email_not_taken, if: 'email.present?'
  validate :user_email_mismatch, if: 'email.present?'

  def charity
    @charity ||= Charity.find_by_id(charity_id) unless charity_id.nil?
  end

  def user
    @user ||= User.find_by_id(user_id) unless user_id.nil?
  end

  def referrer
    @referrer ||= User.find_by_id(referrer_id) unless referrer_id.nil?
  end

  attr_reader :pledge

  def charity=(new_charity)
    @charity = new_charity
    self.charity_id = new_charity.nil? ? nil : new_charity.id
  end

  def user=(new_user)
    @user = new_user
    self.user_id = new_user.nil? ? nil : new_user.id
  end

  def referrer=(new_referrer)
    @referrer = new_referrer
    self.referrer_id = new_referrer.nil? ? nil : new_referrer.id
  end

  def save
    return false unless valid?

    user ||= User.create_by_pledge_form!(name: name, email: email,
                                         stripe_customer_token: stripe_customer_token)

    if user.stripe_customer.nil?
      user.register_stripe_customer(stripe_customer_token)
      user.save!
    end

    @pledge = Pledge.create!(user: user, charity: charity, amount: amount, tip_percentage: tip_percentage, referrer: referrer)
    @pledge.authorize!

    true
  end

  private

  def stripe_customer_token_must_be_valid
    if stripe_customer_token.match(/^tok_/).nil? || stripe_customer_token.size > 255
      errors.add(:stripe_customer_token, 'Stripe token is Invalid')
    end

    # TODO: Make remote calls async
    # begin
    #  Stripe::Token.retrieve(stripe_customer_token)
    # rescue Stripe::InvalidRequestError => e
    #  errors.add(:stripe_customer_token, "Stripe token is Invalid")
    # rescue Stripe::AuthenticationError => e
    #  errors.add(:stripe_customer_token, "Authentication with Stripe failed")
    # rescue Stripe::APIConnectionError => e
    #  errors.add(:stripe_customer_token, "Network communication with Stripe failed")
    # rescue Stripe::StripeError => e
    #  errors.add(:stripe_customer_token, "Something with Stripe went wrong")
    # end
  end

  def email_not_taken
    return if user.present?

    if User.find_by_email(email)
      errors.add(:email, 'User with this email already exists')
    end
  end

  def user_email_mismatch
    return if user.nil?

    if user.email != email
      errors.add(:email, 'Email does not match the logged in user')
    end
  end
end
