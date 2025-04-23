class GameEvent < ApplicationRecord
  enum :event_type, { completed: 'COMPLETED' }

  validates :game_name, presence: true
  validates :event_type, presence: true
  validates :occurred_at, presence: true

  belongs_to :user
end
