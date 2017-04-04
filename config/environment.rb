# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Myflix::Application.initialize!

uri = URI.parse(Rails.application.secrets.redistogo_url)
REDIS = Redis.new(:url => uri)
