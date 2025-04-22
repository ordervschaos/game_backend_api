require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # Create a test controller that inherits from ApplicationController
  controller do
    def index
      render json: { message: 'success' }
    end
  end

  let(:user) { create(:user) }
  let(:valid_token) do
    JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.credentials.secret_key_base,
      'HS256'
    )
  end

  describe 'authentication' do
    context 'with valid token' do
      before do
        request.headers['Authorization'] = "Bearer #{valid_token}"
      end

      it 'allows access to the endpoint' do
        get :index
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq({ 'message' => 'success' })
      end

      it 'sets the current_user' do
        get :index
        expect(controller.instance_variable_get(:@current_user)).to eq(user)
      end
    end

    context 'with no token' do
      it 'returns unauthorized status' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid token' do
      before do
        request.headers['Authorization'] = 'Bearer invalid_token'
      end

      it 'returns unauthorized status' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with expired token' do
      let(:expired_token) do
        JWT.encode(
          { user_id: user.id, exp: 1.hour.ago.to_i },
          Rails.application.credentials.secret_key_base,
          'HS256'
        )
      end

      before do
        request.headers['Authorization'] = "Bearer #{expired_token}"
      end

      it 'returns unauthorized status' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with token for non-existent user' do
      let(:non_existent_user_token) do
        JWT.encode(
          { user_id: 999999, exp: 24.hours.from_now.to_i },
          Rails.application.credentials.secret_key_base,
          'HS256'
        )
      end

      before do
        request.headers['Authorization'] = "Bearer #{non_existent_user_token}"
      end

      it 'returns forbidden status' do
        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end 