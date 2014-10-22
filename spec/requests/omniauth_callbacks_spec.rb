require 'rails_helper'

RSpec.describe 'Omniauth Callbacks', type: :request do

  describe 'Twitter' do

    it 'redirects to finish_sign_up after twitter auth' do
      get user_omniauth_authorize_path(:twitter)

      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]

      follow_redirect!

      expect(@response).to redirect_to(user_finish_sign_up_path)
    end
  end

end
