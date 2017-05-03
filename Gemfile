source 'https://rubygems.org'
ruby '2.4.1'

gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap_form', '~> 2.7'
gem 'haml-rails', '~> 1.0'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'pg', '~> 0.20.0'
gem 'rails', '~> 4.2', '>= 4.2.8'
gem 'turbolinks', '~> 5.0', '>= 5.0.1'
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'uglifier', '~> 3.2'
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
gem 'friendly_id', '~> 5.2'
gem 'puma', '~> 3.8', '>= 3.8.2'

gem 'sidekiq', '~> 4.2', '>= 4.2.10'
gem 'redis', '~> 3.3', '>= 3.3.3'
gem 'shrine', '~> 2.6'
gem 'aws-sdk', '~> 2.9', '>= 2.9.7'
gem 'roda', '~> 2.24'
gem 'jquery-fileupload-rails', '~> 0.4.7'
gem 'unobtrusive_flash', '~> 3.3', '>= 3.3.1'
gem 'ruby-filemagic', '~> 0.7.1'

gem 'stripe', '~> 2.4'

group :development do
  gem 'better_errors', '~> 2.1', '>= 2.1.1'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'thin', '~> 1.5.0'
  gem 'mailcatcher', '~> 0.6.5'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.2', require: 'dotenv/rails-now'
  gem 'pry', '~> 0.10.4'
  gem 'pry-nav', '~> 0.2.4'
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'faker', '~> 1.7', '>= 1.7.3'
end

group :test do
  gem 'database_cleaner', '~> 1.5', '>= 1.5.3'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '~> 3.0', '>= 3.0.3'
  gem 'webmock', '~> 3.0', '>= 3.0.1'
  gem 'capybara', '~> 2.13'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  gem 'capybara-email', '~> 2.5'
  gem 'poltergeist', '~> 1.15'
  gem 'selenium-webdriver', '~> 3.3'
  gem 'shrine-memory', '~> 0.2.2'
end

group :production, :staging do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'sentry-raven', '~> 2.4'
end
