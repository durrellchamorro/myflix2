class User < ActiveRecord::Base
  validates_presence_of :full_name, :password_digest, :email
  validates_uniqueness_of :email

  has_secure_password
end
