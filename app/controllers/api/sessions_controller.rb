class Api::SessionsController < ApplicationController
  def create
    # params will have email and password
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      render json: {token: user.jwt}, status: :ok
    else
      head :unauthorized
    end
    
  end
end
