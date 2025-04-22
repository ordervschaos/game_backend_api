class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  validates :password, presence: true, length: {minimum: 6}

  def jwt
    JWT.encode({
      user_id: self.id,
      exp: 24.hours.from_now.to_i
    }, Rails.application.credentials.secret_key_base)
  end
  
end
