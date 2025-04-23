class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
  # Note: Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character
  validates :password, presence: true, length: {minimum: 8}, format: {with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}\z/, message: "must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character"}

  has_many :game_events

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

