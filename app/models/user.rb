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

  # Will be nifty to have a class method that can decode the JWT and return the user object
  def self.from_jwt(token)
    payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
    User.find_by(id: payload['user_id'])
  end
end

