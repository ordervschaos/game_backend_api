FactoryBot.define do
  factory :game_event do
    game_name {"Brevity"}
    event_type { 'COMPLETED' }
    occurred_at {Time.now}
  end
end
