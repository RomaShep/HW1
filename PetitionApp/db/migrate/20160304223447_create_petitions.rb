class CreatePetitions < ActiveRecord::Migration
  def change
    create_table :petitions do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
