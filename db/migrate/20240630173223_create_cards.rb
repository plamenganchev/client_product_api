class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :activation_number
      t.string :pin
      t.string :status

      t.timestamps
    end
    add_index :cards, [:product_id, :user_id], unique: true
  end
end
