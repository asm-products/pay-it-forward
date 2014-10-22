OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new(provider: 'default',
                                                             uid: 'uid',
                                                             info: {
                                                               name: 'Frank Underwood',
                                                               email: 'mail@exmaple.com'
                                                             },
                                                             extra: { raw_info: {} })

OmniAuth.config.add_mock(:twitter, provider: 'twitter', info: { email: nil })
OmniAuth.config.add_mock(:facebook, provider: 'facebook')
