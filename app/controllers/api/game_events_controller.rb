class Api::GameEventsController < ApplicationController

  def create
    begin
      game_event = GameEvent.new(game_event_params)
      game_event.user = @current_user
      
      if game_event.save
        render json: { message: 'Game event created successfully', game_event: game_event }, status: :created
      else
        render_error(game_event.errors.full_messages)
      end
    rescue ActionController::UnpermittedParameters, ActionController::ParameterMissing, ArgumentError => e
      render_error(e)
    end
  end

  private

  def game_event_params
    params.require(:game_event).permit(:game_name, :type, :occurred_at).tap do |whitelisted|
      whitelisted[:event_type] = whitelisted.delete(:type)
    end
  end

end
