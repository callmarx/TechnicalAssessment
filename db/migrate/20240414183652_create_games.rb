class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :total_kills
      t.jsonb :players
      t.jsonb :kills
      t.boolean :has_crashed
      t.jsonb :kills_by_means

      t.timestamps
    end
  end
end
