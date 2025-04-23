class ApplicationController < ActionController::API
  before_action :authenticate!
  before_action :set_default_format
  rescue_from StandardError, with: :handle_error

  private

  def set_default_format
    request.format = :json
  end

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

  def render_error(errors, status = :unprocessable_entity)
    render json: ErrorSerializer.serialize(errors), status: status
  end

  def handle_error(error)
    # Rails.logger.error("\n=== Error Details ===")
    # Rails.logger.error("Error Class: #{error.class}")
    # Rails.logger.error("Message: #{error.message}")
    # Rails.logger.error("Backtrace:\n#{error.backtrace.join("\n")}")
    # Rails.logger.error("===================\n")

    if Rails.env.development? || Rails.env.test?
      render json: { 
        error: error.message,
        backtrace: error.backtrace
      }, status: :internal_server_error
    else
      render json: { error: "An unexpected error occurred" }, status: :internal_server_error
    end
  end
end

