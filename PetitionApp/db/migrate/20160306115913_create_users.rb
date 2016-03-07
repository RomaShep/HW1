class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :second_name
      t.string :email

      t.integer :user_id
      t.string :password_hash
      t.string :password_salt

      t.timestamps null: false
    end
  end
end





