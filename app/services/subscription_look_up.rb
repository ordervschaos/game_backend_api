# Note: because this looks like something that'll come in handy
class SubscriptionLookUp
  include Retryable

  class SubscriptionError < StandardError; end

  def self.call(user_id)
    with_retries.new(user_id).call
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    retry_with_exponential_backoff(
      error_classes: [Faraday::ConnectionFailed, Faraday::TimeoutError, Faraday::SSLError, JSON::ParserError],
      context: "Subscription lookup for user #{@user_id}"
    ) do
      response = make_request @user_id
      
      if response.status == 404
        # Note: If every user is supposed to have a subscription status, we want to flag this as an error so that we can investigate
        Rails.logger.error("Subscription lookup for user #{@user_id} returned 404")

        # Note: Not raising an error here because we don't want to block the user from accessing other details
        return 'no_subscription'
      end

      parsed_response = JSON.parse(response.body)
      
      if parsed_response.key?('error')
        # This will trigger the retry mechanism
        raise Faraday::ConnectionFailed, "API returned an error: #{parsed_response['error']}"
      end
      
      parsed_response['subscription_status']
    end
  end

  private

  def make_request(user_id)
    Faraday.get("https://interviews-accounts.elevateapp.com/api/v1/users/#{user_id}/billing") do |req|
      req.headers['Authorization'] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg"
    end
  end
end 