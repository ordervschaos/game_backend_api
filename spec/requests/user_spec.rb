require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /create" do
    context "when valid values are passed" do
      let(:valid_values) do
         {
          email: "tgest@test.com",
          password: "pwinewr12"
        }
      end

      it "creates a user entry in the DB" do
        expect{
          post("/api/user",params: valid_values)
      }.to change(User,:count).by(1)

        
      end
    end
  end

  describe "GET /show" do
    let(:user) { create(:user, id: 3) }
    let(:user_without_subscription) { create(:user, id: 103) }
    context "when an authenticated user requests" do
      before do
        user.game_events.create!({
          game_name:"ee",
          event_type:"COMPLETED",
          occurred_at: Time.now
        })
        token = user.jwt
        get "/api/user", headers: { "Authorization": "Bearer #{token}" }
      end

      it "sends user data" do
        token = user.jwt
        headers = {
          "Authorization": "Bearer #{token}"
        }
        get "/api/user", headers: headers
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status :ok
        expect(json_response).to include("email" => user.email)
        expect(json_response["stats"]["total_games_played"]).to eq(1)
        expect(json_response["subscription_status"]).to eq("expired")
      end
    end

    context "when an invalid user requests" do
      it "sends unauthorized status" do
        headers = {
          "Authorization": "Bearer invalid_token"
        }

        get "/api/user", headers: headers

        expect(response).to have_http_status :unauthorized
      end
    end

    context "when an authenticated user without a subscription " do
      before do
        token = user_without_subscription.jwt
        get "/api/user", headers: { "Authorization": "Bearer #{token}" }
      end

      it "should throw a server error" do
        token = user_without_subscription.jwt
        headers = {
          "Authorization": "Bearer #{token}"
        }
        get "/api/user", headers: headers
        expect(response).to have_http_status :server_error
        
      end
    end
  end
end
