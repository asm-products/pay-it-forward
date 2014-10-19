require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  # auth.uid
  # auth.provider
  # auth.info.email
  # auth.info.verified
  # auth.info.verified_email
  # auth.extra.raw_info.name
  let(:auth_facebook) do
    OmniAuth::AuthHash.new(uid: 123_456_789,
                           provider: 'facebook',
                           info: OmniAuth::AuthHash::InfoHash.new(email: 'mail@example.com', verified: true),
                           extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(name: 'Frank')))
  end

  let(:auth_twitter) do
    OmniAuth::AuthHash.new(uid: 987_654_321,
                           provider: 'twitter',
                           info: OmniAuth::AuthHash::InfoHash.new({}),
                           extra: OmniAuth::AuthHash.new(raw_info: OmniAuth::AuthHash.new(name: 'Frank')))
  end

  # find_or_create_by_oauth
  it 'does create a new account with omniauth' do
    expect do
      User.find_or_create_by_oauth(auth_facebook)
    end.to change { User.count }.by(1)
  end

  it 'does find an account with omniauth' do
    User.find_or_create_by_oauth(auth_facebook)

    expect do
      User.find_or_create_by_oauth(auth_facebook)
    end.to change { User.count }.by(0)
  end

  it 'does add omniauth identity to existing account that is signed in' do
    user = create(:user, email: 'mail@example.com')

    expect do
      User.find_or_create_by_oauth(auth_facebook, user)
    end.to change { User.count }.by(0)
  end

  it 'does add omniauth identity to existing account that is signed out' do
    create(:user, email: 'mail@example.com')

    expect do
      User.find_or_create_by_oauth(auth_facebook)
    end.to change { User.count }.by(0)
  end

  it 'does rotate password of existing that is not signed in' do
    user = create(:user, email: 'mail@example.com')

    expect do
      User.find_or_create_by_oauth(auth_facebook)
      user.reload
    end.to change { user.encrypted_password }
  end

  it 'does confirm an unconfirm email if omniauth source with verified_email is added' do
    user = User.find_or_create_by_oauth(auth_twitter)
    user.finish_signup(email: 'mail@example.com')
    expect(user.confirmed_at).to be nil

    user = User.find_or_create_by_oauth(auth_facebook)
    expect(user.email_verified?).to_not be nil
  end

  # finish_signup
  it "does update user's email" do
    user_params = { email: 'testing@test.com' }

    user.finish_signup(user_params)
    user.reload

    expect(user.email).to eq user_params[:email]
  end

  it 'does validate user_params' do
    user_params = { email: 'testing' }

    expect do
      user.finish_signup(user_params)
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email is invalid')
  end

  it 'does update user to act as devise sign up' do
    user_params = { email: 'testing@test.com' }

    user.finish_signup(user_params)
    user.reload

    expect(user.confirmed_at).to be nil
    expect(user.unconfirmed_email).to be nil
  end

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
