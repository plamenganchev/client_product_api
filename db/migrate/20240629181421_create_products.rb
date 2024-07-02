class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.string :status
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, [:name, :brand_id], unique: true
  end
end
