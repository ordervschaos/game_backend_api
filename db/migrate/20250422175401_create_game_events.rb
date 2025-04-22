class CreateGameEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :game_events do |t|

      t.timestamps
    end
  end
end
