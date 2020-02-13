class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.integer :value, null: false
      t.references :product, null: false
      t.timestamps
    end
  end
end
