require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /create" do
    context "when valid values are passed" do
      valid_values = {
        email:"tgest@test.com",
        password: "pwinewr12"

      }
      it "creates a user entry in the DB" do

        expect{
          post("/api/user",params: valid_values)
      }.to change(User,:count).by(1)

        
      end
    end

  end
end
