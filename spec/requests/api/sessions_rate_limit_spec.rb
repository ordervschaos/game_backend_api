require 'rails_helper'

RSpec.describe "API Sessions Rate Limiting", type: :request do
  let(:user) { create(:user, email: 'test@example.com', password: 'password123') }
  let(:valid_params) { { email: user.email, password: 'password123' } }
  let(:invalid_params) { { email: user.email, password: 'wrong_password' } }

  before do
    # Clear Redis cache before each test
    Rack::Attack.cache.store.clear
  end

  describe "IP-based rate limiting" do
    it "allows requests within the rate limit" do
      # Make 5 requests (under the limit of 300 per 5 minutes)
      5.times do |i|
        post "/api/sessions", params: valid_params
        expect(response).to have_http_status(:ok)
        puts "Request #{i+1} status: #{response.status}"
      end
    end

    it "blocks requests exceeding the rate limit" do
      # Make 301 requests (exceeding the limit of 300 per 5 minutes)
      301.times do |i|
        post "/api/sessions", params: valid_params
        puts "Request #{i+1} status: #{response.status}"
      end

      # The 301st request should be blocked
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe "Email-based rate limiting" do
    it "allows login attempts within the rate limit" do
      # Make 4 requests (under the limit of 5 per minute)
      4.times do |i|
        post "/api/sessions", params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        puts "Request #{i+1} status: #{response.status}"
      end
    end

    it "blocks login attempts exceeding the rate limit" do
      # Make 6 requests (exceeding the limit of 5 per minute)
      6.times do |i|
        post "/api/sessions", params: invalid_params
        puts "Request #{i+1} status: #{response.status}"
      end

      # The 6th request should be blocked
      expect(response).to have_http_status(:too_many_requests)
    end
  end

 
end 