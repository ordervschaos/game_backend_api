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
    let(:user) { create(:user) }
    context "when an authenticated user requests" do
      it "sends user data" do
        token = user.jwt
        headers = {
          "Authorization": "Bearer #{token}"
        }
        get "/api/user", headers: headers

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to include("email" => user.email)
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
  end
end
