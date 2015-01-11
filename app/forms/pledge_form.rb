class PledgeForm
  include Virtus.model
  include ActiveModel::Model

  attribute :amount, Integer
  attribute :tip_percentage, Integer
  attribute :stripe_auth_token, String

  attribute :name, String
  attribute :email, String

  attribute :charity_id, Integer
  attribute :user_id, Integer
  attribute :referrer_id, Integer

  validates :charity, :amount, :tip_percentage, :stripe_auth_token, :name, :email, presence: true
  validates :amount, :tip_percentage, numericality: { only_integer: true }
  validates :amount, numericality: { greater_than: 0 }
  validates :tip_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :email, email: true

  validates :referrer, presence: true, if: 'referrer_id.present?'
  validates :user, presence: true, if: 'user_id.present?'

  validate :stripe_auth_token_must_be_valid, if: 'stripe_auth_token.present?'
  validate :email_not_taken, if: 'email.present?'
  validate :user_email_mismatch, if: 'email.present?'

  attr_reader :pledge

  def charity
    @charity ||= Charity.find_by_id(charity_id) unless charity_id.nil?
    @charity
  end

  def user
    @user ||= User.find_by_id(user_id) unless user_id.nil?
    @user
  end

  def referrer
    @referrer ||= User.find_by_id(referrer_id) unless referrer_id.nil?
    @referrer
  end

  def charity=(new_charity)
    @charity = new_charity
    self.charity_id = new_charity.nil? ? nil : new_charity.id
    @charity
  end

  def user=(new_user)
    @user = new_user
    self.user_id = new_user.nil? ? nil : new_user.id
    @user
  end

  def save
    return false unless valid?

    self.user ||= User.create_by_pledge_form!(
      name: name,
      email: email,
      stripe_auth_token: stripe_auth_token
      )

    if user.stripe_customer.nil?
      user.register_stripe_customer(stripe_auth_token)
      user.save!
    end

    @pledge = Pledge.create!(
      user: user,
      charity: charity,
      amount: amount,
      tip_percentage: tip_percentage,
      referrer: referrer
     )

    AuthorizePledgeJob.perform_later(@pledge)
    true
  end

  private

  def stripe_auth_token_must_be_valid
    if stripe_auth_token.match(/^tok_/).nil? || stripe_auth_token.size > 255
      return errors.add(:stripe_auth_token, 'Stripe token is Invalid')
    end

    return unless errors.empty?

    # TODO: Make remote calls async
    begin
      Stripe::Token.retrieve(stripe_auth_token)
    rescue Stripe::InvalidRequestError
      errors.add(:stripe_auth_token, 'Stripe token is Invalid')
    rescue Stripe::AuthenticationError
      errors.add(:stripe_auth_token, 'Authentication with Stripe failed')
    rescue Stripe::APIConnectionError
      errors.add(:stripe_auth_token, 'Network communication with Stripe failed')
    rescue Stripe::StripeError
      errors.add(:stripe_auth_token, 'Something with Stripe went wrong')
    end
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
