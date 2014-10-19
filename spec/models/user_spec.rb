require 'rails_helper'

RSpec.describe User, type: :model do

  # find_or_create_by_oauth
  it 'does create a new account with omniauth'
  it 'does find an account with omniauth'
  it 'does add omniauth identity to existing account that is signed in'
  it 'does add omniauth identity to existing account that is signed out'
  it 'does rotate password of existing that is not signed in'
  it 'does verify an unverified email if omniauth source with verified_email is added'

  # finish_signup
  it "does update user's email"
  it 'does validate user_params'
  it 'does update user to act as devise sign up'

  # email_verified?
  it 'does not show placeholder email as verified' do
    expect(build(:user, email: User::TEMP_EMAIL_PREFIX).email_verified?).to be false
  end

  it 'does not show empty email as verified' do
    expect(build(:user, email: '').email_verified?).to be false
  end

  it 'does show valid email as verified' do
    expect(build(:user).email_verified?).to be true
  end

end
