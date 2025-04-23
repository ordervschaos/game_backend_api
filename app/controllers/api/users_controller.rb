class Api::UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  def show
    user = @current_user.as_json(only: [:email, :id])
    user[:stats] = { total_games_played: @current_user.game_events.count}
    user[:subscription_status] = SubscriptionLookUp.call(@current_user[:id])
    render json: user, status: :ok
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

