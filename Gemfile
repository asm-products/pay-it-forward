source 'https://rubygems.org'
ruby '2.1.3'

# Core
gem 'rails', '4.2.0.beta1'
gem 'puma'
gem 'pg'

# Assets
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'
gem 'jquery-rails'

gem 'paperclip'
gem 'fog'
gem 'asset_sync'

# Extensions
gem 'turbolinks'
gem 'rails-html-sanitizer', '~> 1.0'

# Helpers
gem 'flutie'
gem 'jbuilder', '~> 2.0'
gem 'high_voltage', '~> 2.2.1'
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
  gem 'web-console', '~> 2.0.0.beta2'
  gem 'spring'
  gem 'rubocop'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'dotenv-rails'
end

group :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'coveralls', require: false
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout'
end
