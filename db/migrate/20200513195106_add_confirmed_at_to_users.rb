class AddConfirmedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :email_confirmation_token, null: false, default: ""
      t.datetime :email_confirmed_at
    end
  end
end
