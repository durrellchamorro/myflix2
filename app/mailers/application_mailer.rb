class ApplicationMailer < ActionMailer::Base
  default from: 'MyFlix <no-reply@durrellsnetflix.herokuapp.com>'
  layout 'mailer'
end
