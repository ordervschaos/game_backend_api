class Api::UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  def show
    # Note: using a presenter here to keep the controller thin
    render json: UserPresenter.new(@current_user).as_json, status: :ok
  end
  def create
    user = User.new(format_user)

    if user.save
      # Note: sending the token to the client here because this would make the user able to login immediately after signing up
      render json: {token: user.jwt}, status: :created

    else
      render_error(user.errors.full_messages)
    end
  end

  private
  def format_user
    params.permit(:email, :password)
    
  end
end

