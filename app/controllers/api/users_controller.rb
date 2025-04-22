class Api::UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  def show
    render json: @current_user.as_json(only: [:email,:id])
  end
  def create
    user = User.new(format_user)

    if user.save
      render json: user.slice(:email,:id), status: :created
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def format_user
    params.permit(:email, :password)
    
  end
end

