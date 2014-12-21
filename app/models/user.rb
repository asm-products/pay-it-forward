class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :pledges

  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true
  validates :email, email: true

  class << self
    def create_by_pledge_form!(pledge_user_params)
      User.create! do |user|
        user.name     = pledge_user_params[:name]
        user.email    = pledge_user_params[:email]
        user.password = user.password_confirmation = ::Sorcery::Model::TemporaryToken.generate_random_token
        user.register_stripe_customer(pledge_user_params[:stripe_customer_token])
      end
    end
  end

  def stripe_customer
    @stripe_customer ||= ::Stripe::Customer.retrieve(stripe_customer_id) unless stripe_customer_id.nil?
  end

  def stripe_customer=(stripe_customer)
    self.stripe_customer_id = stripe_customer.id
    @stripe_customer = stripe_customer
  end

  def register_stripe_customer(stripe_token)
    self.stripe_customer = ::Stripe::Customer.create(card: stripe_token, email: email)
  end
end
