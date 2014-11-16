class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  validates :password, length: { minimum: 6 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true
  validates :email, email: true
  
  class << self
    def create_by_stripe!(stripe_params)
      User.create! do |user|
        user.email = stripe_params[:email]
        user.password = user.password_confirmation = ::Sorcery::Model::TemporaryToken::generate_random_token
        user.register_stripe_customer(stripe_params)
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

  def register_stripe_customer(stripe_params)
    self.stripe_customer = ::Stripe::Customer.create(
      card: stripe_params[:token],
      email: stripe_params[:email]
      )
    self.save! unless self.new_record?
  end
end
