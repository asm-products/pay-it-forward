# User Signup/Omniauth Flow:
#   When a user signs up with a omniauth that provides a verified_email that creates an account.
#   If the user tries to sign in with another source that verifies the same email, that account is
#   added. If a user signs up with an unverified email, then logins in with a source that verifies
#   the email, the password is rotated to prevent a situation where the account could of been setup
#   by someone who didn't own the email, waiting then for the person to signup via omniauth. If the
#   user is logged in, any omniauth accounts are just added to the account. Confirming the email if
#   provided. If an omniauth account is present, but a user tries to signup with via an unverified
#   method, the collision is detected, and they are asked to login/recover the account.

class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :lockable, :timeoutable

  has_many :identities
  has_one :stripe_customer
  has_many :stripe_charges, through: :stripe_customer

  class << self
    def find_or_create_by_oauth(auth, signed_in_resource = nil)
      identity = Identity.find_by_oauth(auth)

      # If a signed_in_resource is provided it always overrides the existing user
      # to prevent the identity being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated identity) which
      # can be cleaned up at a later date.
      # TODO: Handle Zombie Accounts
      user = signed_in_resource ? signed_in_resource : identity.user

      # Create the user if it's a new registration
      if user.nil?
        verified_email = auth.info.email if auth.info.email && (auth.info.verified || auth.info.verified_email)

        user = User.find_or_create_by!(email: verified_email) do |new_user|
          new_user.name = auth.extra.raw_info.name
          new_user.email = verified_email ? verified_email.downcase : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
          new_user.password = Devise.friendly_token
          new_user.skip_confirmation!
        end

        # Rotate password if confirming email with secondary source
        user.update_attributes!(confirmed_at: DateTime.now, password: Devise.friendly_token) if user.confirmed_at.nil? && user.email == verified_email
      end

      # Associate the identity with the user if needed
      identity.update_attributes!(user: user) if identity.user != user

      user
    end
  end

  def finish_sign_up(user_params)
    # Allow Validation, then bypass it
    update!(user_params) && update_columns(
      email: user_params[:email].downcase,
      confirmed_at: nil,
      unconfirmed_email: nil
      )
  end

  def email_verified?
    email && valid_attribute?(:email) && email !~ TEMP_EMAIL_REGEX
  end

  def sign_up_complete?
    email_verified? && confirmed?
  end
end
