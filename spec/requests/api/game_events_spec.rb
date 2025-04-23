require 'rails_helper'

RSpec.describe "Api::GameEvents", type: :request do
  describe "POST /create" do
    let!(:user){create(:user)}
    
    context 'avalid game event is submitted' do
      it "creates a game event" do
        expect{
          post "/api/user/game_events", params: {
            game_event:{
              type: "COMPLETED",
              game_name: "Brevity",
              occurred_at: Time.now
          }
        },headers: {'Authorization'=>"Bearer #{user.jwt}"}
      }.to change(GameEvent, :count).by(1)
      end
    end

    context "an invalid type is submitted" do
      it "rejects the request with unprocessable entity status" do
        post "/api/user/game_events", params: {
              game_event:{
                type: "NOT_VALID",
                game_name: "Brevity",
                occurred_at: Time.now
            }
          },headers: {'Authorization'=>"Bearer #{user.jwt}"}
        puts "Response: #{response.body}"
        expect(response).to have_http_status :unprocessable_entity
      end
    end
    context "an empty occured_at is submitted" do
      it "rejects the request with unprocessable entity status" do
        post "/api/user/game_events", params: {
              game_event:{
                type: "COMPLETED",
                game_name: "Brevity"
            }
          },headers: {'Authorization'=>"Bearer #{user.jwt}"}
        puts "Response: #{response.body}"
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context "bad data is submitted" do
      it "rejects the request with bad request status" do
        post "/api/user/game_events", params:"some string",headers: {'Authorization'=>"Bearer #{user.jwt}"}
        puts "Response: #{response.body}"
        expect(response).to have_http_status :bad_request
      end
    end


  end
end
