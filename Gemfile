source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass', '3.1.1.1'
gem 'bootstrap_form'
gem 'coffee-rails'
gem 'haml-rails'
gem 'jquery-rails'
gem 'pg'
gem 'activerecord-postgresql-citext'
gem 'rails', '4.1.1'
gem 'turbolinks', '~> 5.0', '>= 5.0.1'
gem 'sass-rails'
gem 'uglifier'
gem 'bcrypt'
gem 'friendly_id', '~> 5.2'
gem 'puma', '~> 3.8', '>= 3.8.2'
gem 'sidekiq', '~> 4.2', '>= 4.2.10'
gem 'redis', '~> 3.3', '>= 3.3.3'
gem 'shrine', '~> 2.6'
gem 'aws-sdk', '~> 2.9', '>= 2.9.7'
gem 'roda', '~> 2.24'
gem 'jquery-fileupload-rails', '~> 0.4.7'

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'thin'
  gem 'mailcatcher', '~> 0.6.5'
end

group :development, :test do
  gem 'dotenv-rails', '~> 2.2', require: 'dotenv/rails-now'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'faker', '~> 1.7', '>= 1.7.3'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3'
  gem 'capybara', '~> 2.13'
  gem 'launchy', '~> 2.4', '>= 2.4.3'
  gem 'capybara-email', '~> 2.5'
  gem 'shrine-memory', '~> 0.2.2'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'sentry-raven', '~> 2.4'
end
