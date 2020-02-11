class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :provider_identifier, null: false
      t.string :provider, null: false
      t.timestamps
    end
  end
end
