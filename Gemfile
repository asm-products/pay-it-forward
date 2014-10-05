source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails', '4.2.0.beta1'
gem 'puma'
gem 'pg'

gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'paperclip'
gem 'fog'
gem 'asset_sync'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'flutie'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'rails-html-sanitizer', '~> 1.0'
gem 'high_voltage', '~> 2.2.1'


group :development do
  gem 'pry-rails'
  gem 'byebug'
  gem 'pry-byebug'
  gem 'web-console', '~> 2.0.0.beta2'
  gem 'spring'
  gem 'rubocop'
end

group :development, :test do
  gem 'dotenv-rails', '0.11.1' # Locked for spring error
end

group :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'coveralls', require: false
end

group :production do
  gem 'rails_12factor'
  gem 'rack-timeout'
end
