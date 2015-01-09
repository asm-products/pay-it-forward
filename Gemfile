source 'https://rubygems.org'
ruby '2.1.3'

# Core
gem 'rails', '4.2.0'
gem 'puma'
gem 'pg'
gem 'sidekiq'

# Assets
gem 'sass-rails'
gem 'uglifier'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'
gem 'jquery-rails'

gem 'paperclip'
gem 'fog'
gem 'asset_sync'

# Extensions
gem 'turbolinks'
gem 'rails-html-sanitizer'
gem 'virtus'
gem 'aasm'

# Helpers
gem 'flutie'
gem 'jbuilder'
gem 'high_voltage'
gem 'wicked'
gem 'country_select'

# Users
gem 'sorcery'
gem 'email_validator'

# Payments
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

group :development do
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'byebug'
  gem 'web-console'
  gem 'spring'
  gem 'rubocop'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'dotenv-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'codeclimate-test-reporter', require: false
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout'
end
