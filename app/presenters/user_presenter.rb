class UserPresenter
  def initialize(user)
    @user = user
  end

  def as_json
    user_data = @user.as_json(only: [:email, :id])
    user_data[:stats] = { total_games_played: @user.game_events.count }
    user_data[:subscription_status] = SubscriptionLookUp.call(@user.id)
    user_data
  end
end 