class CreateTrackers < ActiveRecord::Migration[6.0]
  def change
    create_table :trackers do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.integer :threshold_price, null: false
      t.boolean :enabled, default: true
      t.references :user, null: false

      t.timestamps
    end
  end
end
