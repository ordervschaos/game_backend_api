class Api::GameEventsController < ApplicationController

  def create
    begin
      game_event = GameEvent.new(game_event_params)
      game_event.user = @current_user
      
      if game_event.save
        render json: { message: 'Game event created successfully', game_event: game_event.as_json(only: [:id, :game_name, :event_type, :occurred_at]) }, status: :created
      else
        render_error(game_event.errors.full_messages, :unprocessable_entity)
      end
    rescue ArgumentError => e
      render_error(e.message, :unprocessable_entity)
    rescue StandardError => e
      render_error("An unexpected error occurred: #{e.message}", :bad_request)
    end
  end

  private

  def game_event_params
    params.require(:game_event).permit(:game_name, :type, :occurred_at).tap do |whitelisted|
      whitelisted[:event_type] = whitelisted.delete(:type)
    end
  end

end
