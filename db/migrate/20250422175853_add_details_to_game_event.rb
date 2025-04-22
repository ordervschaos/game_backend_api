class AddDetailsToGameEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :game_events, :game_name, :string
    add_column :game_events, :event_type, :string
    add_column :game_events, :occurred_at, :timestamp
  end
end
