# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample users
users_data = [
  { email: 'admin@example.com', password: 'Admin123!' },
  { email: 'user1@example.com', password: 'User1234!' },
  { email: 'player2@example.com', password: 'Player123!' },
  { email: 'gamer3@example.com', password: 'Gamer123!' },
  { email: 'test@example.com', password: 'Test1234!' }
]

users_data.each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.password = user_data[:password]
  end
end

puts "Created #{User.count} users"

# Create sample game events
game_names = ['Minecraft', 'Fortnite', 'League of Legends', 'Valorant', 'Apex Legends']
users = User.all

# Create 20 random game events
20.times do
  GameEvent.create!(
    user: users.sample,
    game_name: game_names.sample,
    event_type: 'completed',
    occurred_at: rand(1..30).days.ago
  )
end

puts "Created #{GameEvent.count} game events"
