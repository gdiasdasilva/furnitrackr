class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :provider_identifier, null: false
      t.integer :provider, default: 0, null: false
      t.timestamps
    end
  end
end
