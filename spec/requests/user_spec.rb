require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /create" do
    context "when valid values are passed" do
      let(:valid_values) do
         {
          email: "tgest@test.com",
          password: "Password123!"
        }
      end

      it "creates a user entry in the DB" do
        expect{
          post("/api/user",params: valid_values)
      }.to change(User,:count).by(1)

      expect(response).to have_http_status :created
      expect(response.body).to include("token")

        
      end
    end
    
    context "when email already exists" do
      let(:existing_email) { "existing@example.com" }
      let(:existing_password) { "Password123!" }
      let(:duplicate_values) do
        {
          email: existing_email,
          password: "NewPassword123!"
        }
      end
      
      before do
        # Create a user with the email that will be used in the test
        User.create!(
          email: existing_email,
          password: existing_password
        )
      end
      
      it "does not create a new user and returns unprocessable entity status" do
        expect {
          post("/api/user", params: duplicate_values)
        }.not_to change(User, :count)
        
        expect(response).to have_http_status :unprocessable_entity
        expect(JSON.parse(response.body)).to include("errors" => [{"detail" => "Email has already been taken"}])
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
        expect(["expired", "active"]).to include(json_response["subscription_status"])
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

      it "should return no_subscription status" do
        token = user_without_subscription.jwt
        headers = {
          "Authorization": "Bearer #{token}"
        }
        get "/api/user", headers: headers
        expect(JSON.parse(response.body)['subscription_status']).to eq('no_subscription')
        
      end
    end
  end
end
