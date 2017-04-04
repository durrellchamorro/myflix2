Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  ActionMailer::Base.smtp_settings = {
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => 'durrellsnetflixstaging.herokuapp.com',
    :authentication => :plain
  }
  ActionMailer::Base.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'durrellsnetflixstaging.herokuapp.com' }

  uri = URI.parse(Rails.application.secrets.redistogo_url)
  REDIS = Redis.new(:url => uri)
end
