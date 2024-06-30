class CreateAccessibleProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :accessible_products do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
    add_index :accessible_products, [:user_id, :product_id], unique: true
  end
end
