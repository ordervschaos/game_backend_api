class ApplicationController < ActionController::API
  before_action :authenticate!

  private

  def authenticate!
    token = request.headers['Authorization']&.split&.last
    return head :unauthorized unless token

    begin
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256').first
      @current_user = User.find_by(id: payload['user_id'])
      return head :forbidden unless @current_user
    rescue JWT::ExpiredSignature, JWT::DecodeError
      return head :unauthorized
    end
  end

end

