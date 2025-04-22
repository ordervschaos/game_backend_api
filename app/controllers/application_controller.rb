class ApplicationController < ActionController::API
  before_action :authenticate!

  private

  def authenticate!
    token = request.headers['Authorization']&.split&.last
    return head :unauthorized unless token

    begin
      @current_user = User.from_jwt(token)
      return head :forbidden unless @current_user
    rescue JWT::ExpiredSignature, JWT::DecodeError
      return head :unauthorized
    end
  end

end

