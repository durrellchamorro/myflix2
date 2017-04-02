class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :inviter_id, :recipient_name, :recipient_email, :message
  before_create :generate_token

  private 

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
