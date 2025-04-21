require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /create" do

    let(:user) {create(:user)}

    let(:valid_credentials) do 
        {
        email: user.email,
        password: user.password
      }
    end

    context "when right creds are passed" do
      it "returns a token" do
        post "/api/sessions", params: valid_credentials
        expect(response).to have_http_status :success
        expect(JSON.parse(response.body)).to have_key "token"
      end
    end

    context "when wrong creds are passed" do
      it "returns unathorized status" do
        invalid_credentials = {
          email:user.email,
          password: "incorrect_pw"
        }
        post "/api/sessions", params: invalid_credentials
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
