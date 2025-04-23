class Rack::Attack
  # Store the rate limit info in Redis
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"))

  # Allow all requests from localhost
  # safelist('allow-localhost') do |req|
  #   '127.0.0.1' == req.ip || '::1' == req.ip
  # end

  # Throttle /api/sessions requests by IP (300 requests per 5 minutes)
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    if req.path == '/api/sessions' && req.post?
      req.ip
    end
  end

  # Throttle login attempts by email param (5 requests per minute)
  # Key: "rack::attack:login:#{Time.now.to_i/:period}:email:#{req.params['email']}"
  throttle('login/email', limit: 5, period: 1.minute) do |req|
    if req.path == '/api/sessions' && req.post?
      req.params['email'].to_s.downcase.gsub(/\s+/, "")
    end
  end

  # Return rate limit info in response headers
  Rack::Attack.throttled_response = lambda do |env|
    match_data = env['rack.attack.match_data']
    now = match_data[:epoch_time]
    retry_after = (match_data[:period] - (now % match_data[:period])).to_i

    [
      429, # status
      { 'Content-Type' => 'text/plain', 'Retry-After' => retry_after.to_s },
      ["Rate limit exceeded. Retry after #{retry_after} seconds"]
    ]
  end
end 